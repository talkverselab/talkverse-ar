/// conversation_200_vi 의 누적 복습 학습 플래너 (v2 — exposure cap + 별표).
///
/// 사용자 결정 (2026-05-07):
///   1. 블록 N 학습 → 블록 N 복습 (알아요 X, 수행한 것만) → 1~N-1 누적 복습 (알아요 X, 수행한 것만)
///   2. 별표(favorite) sentence는 알아요 여부 무관 복습에 강제 포함
///   3. **exposure cap = 5** — 5번 노출됐는데 알아요 못 누르면 일단 PASS (진도 우선)
///   4. 9/10 알아요 = 1차 복습 완료 (자동 — 알아요는 review queue 제외)

enum LearningPhase {
  studyNew,           // 새 블록 N의 1~10 노출 (전부)
  reviewBlock,        // 현재 블록 복습 (수행 && 알아요 X) ∪ 별표
  reviewCumulative,   // 1~N-1 블록 (수행 && 알아요 X) ∪ 별표
  finished,
}

class Conv200LearningPlanner {
  /// 한 블록당 sentence 수.
  final int blockSize;
  /// 총 블록 수.
  final int totalBlocks;
  /// 외부 의존 — 알아요 여부 판정 (stage >= 1).
  final bool Function(int sentenceNum) isKnown;
  /// 외부 의존 — 별표(favorite) 여부 판정.
  final bool Function(int sentenceNum) isFavorite;
  /// **Cap** — 노출 N번 안에 알아요 못 누르면 일단 PASS (진도 우선).
  final int exposureCap;

  Conv200LearningPlanner({
    required this.isKnown,
    required this.isFavorite,
    this.blockSize = 10,
    this.totalBlocks = 20,
    this.exposureCap = 5,
  });

  int _currentBlock = 0;
  LearningPhase _phase = LearningPhase.studyNew;
  final List<int> _queue = [];

  /// 노출된 sentence 추적. cumulative review에서 "수행한 것만" 필터.
  final Set<int> _exposed = {};
  /// sentence별 노출 카운트. cap 초과 시 자동 skip.
  final Map<int, int> _exposureCount = {};
  /// cap 초과로 skip된 sentence (사용자가 명시 reset 안 하면 review에서 제외).
  final Set<int> _passed = {};

  LearningPhase get phase => _phase;
  int get currentBlock => _currentBlock;
  int get queueLength => _queue.length;
  Set<int> get exposed => Set.unmodifiable(_exposed);
  Set<int> get passed => Set.unmodifiable(_passed);

  void start() {
    _currentBlock = 0;
    _phase = LearningPhase.studyNew;
    _refillQueue();
  }

  /// 다음 sentence num (or null = 완료).
  /// 반환된 sentence는 자동으로 exposed에 추가, exposureCount++.
  /// cap 도달 시 _passed에 등록되어 다음 review부터 자동 skip.
  int? next() {
    while (_queue.isEmpty && _phase != LearningPhase.finished) {
      _advancePhase();
    }
    if (_queue.isEmpty) return null;
    final n = _queue.removeAt(0);
    _exposed.add(n);
    _exposureCount[n] = (_exposureCount[n] ?? 0) + 1;
    // cap 체크 — 알아요 X 인데 N번째 노출이면 PASS.
    if (_exposureCount[n]! >= exposureCap && !isKnown(n)) {
      _passed.add(n);
    }
    return n;
  }

  /// 사용자가 알아요 누르면 reset — _passed에서 제거 (재진입 가능).
  void onKnown(int n) {
    _passed.remove(n);
    _exposureCount.remove(n); // cap 카운터 리셋
  }

  /// 별표 reset — 별표 풀 때 호출 (planner는 isFavorite로 자체 query하므로 강제 X).
  /// 별도 처리 불필요.

  String phaseLabel() {
    switch (_phase) {
      case LearningPhase.studyNew:
        return '새 블록 ${_currentBlock + 1}/$totalBlocks 학습';
      case LearningPhase.reviewBlock:
        return '블록 ${_currentBlock + 1} 복습';
      case LearningPhase.reviewCumulative:
        return '1~$_currentBlock 누적 복습';
      case LearningPhase.finished:
        return '🎉 모든 블록 완료';
    }
  }

  double get progress {
    if (_phase == LearningPhase.finished) return 1.0;
    return (_currentBlock + (_phase == LearningPhase.studyNew ? 0 : 0.5)) /
        totalBlocks;
  }

  /// 디버그·UI용 stats.
  ({int total, int known, int favorite, int passed}) stats() {
    int total = totalBlocks * blockSize;
    int known = 0, fav = 0;
    for (int n = 1; n <= total; n++) {
      if (isKnown(n)) known++;
      if (isFavorite(n)) fav++;
    }
    return (total: total, known: known, favorite: fav, passed: _passed.length);
  }

  // ---------------- 내부 ----------------

  void _advancePhase() {
    switch (_phase) {
      case LearningPhase.studyNew:
        _phase = LearningPhase.reviewBlock;
        _refillQueue();
        return;
      case LearningPhase.reviewBlock:
        if (_currentBlock >= 1) {
          _phase = LearningPhase.reviewCumulative;
          _refillQueue();
        } else {
          _moveToNextBlock();
        }
        return;
      case LearningPhase.reviewCumulative:
        _moveToNextBlock();
        return;
      case LearningPhase.finished:
        return;
    }
  }

  void _moveToNextBlock() {
    _currentBlock++;
    if (_currentBlock >= totalBlocks) {
      _phase = LearningPhase.finished;
      _queue.clear();
      return;
    }
    _phase = LearningPhase.studyNew;
    _refillQueue();
  }

  /// review 큐에 포함되어야 하는지 판정.
  /// 룰:
  ///   - 별표(favorite) ⇒ 강제 포함 (알아요 무관)
  ///   - 그 외: 수행됨(_exposed) && 알아요 X && PASS X
  bool _eligibleForReview(int n) {
    if (isFavorite(n)) return true; // 별표는 강제
    if (!_exposed.contains(n)) return false; // 미수행 제외
    if (isKnown(n)) return false; // 알아요 제외
    if (_passed.contains(n)) return false; // 5번 cap 초과 제외
    return true;
  }

  void _refillQueue() {
    _queue.clear();
    switch (_phase) {
      case LearningPhase.studyNew:
        // 현재 블록 10개 모두 (새 학습이라 알아요 무관, exposed 무관)
        for (int i = 1; i <= blockSize; i++) {
          final n = _currentBlock * blockSize + i;
          _queue.add(n);
        }
        break;
      case LearningPhase.reviewBlock:
        for (int i = 1; i <= blockSize; i++) {
          final n = _currentBlock * blockSize + i;
          if (_eligibleForReview(n)) _queue.add(n);
        }
        break;
      case LearningPhase.reviewCumulative:
        for (int b = 0; b < _currentBlock; b++) {
          for (int i = 1; i <= blockSize; i++) {
            final n = b * blockSize + i;
            if (_eligibleForReview(n)) _queue.add(n);
          }
        }
        break;
      case LearningPhase.finished:
        break;
    }
  }
}
