import 'package:flutter/material.dart';

import 'account_screen.dart';
import 'about_screen.dart';
import 'progress_screen.dart';

import '../core/theme.dart';
import '../widgets/spanish_decor.dart';
import '../core/l10n.dart';
import '../core/pane.dart';
import '../main.dart';
import '../services/achievement_service.dart';
import '../services/memorized_store.dart';
import '../widgets/reading_toggle.dart';
import '../services/learner_prefs.dart';

/// 프로필 — 계정 · 성과 · 기록 · 학습자 · 설정 · 정보(사용자 지시 2026-11-07, 일본어앱과 같은 정리).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _resetProgress(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr('학습 기록 초기화')),
        content: Text(tr('회화 진행·동사·외운 단어·성과 기록을 모두 지웁니다.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(tr('취소'))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(tr('초기화'), style: const TextStyle(color: AppColors.beni))),
        ],
      ),
    );
    if (ok != true) return;
    await appDb.delete(appDb.userProgress).go();
    await appDb.delete(appDb.verbProgress).go();
    await MemorizedStore.clear();
    await AchievementService.instance.clear();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('학습 기록을 지웠습니다')), backgroundColor: AppColors.sumi));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cal,
      appBar: AppBar(title: Text(tr('프로필'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(tr('계정')),
          const SizedBox(height: 8),
          _SettingsGroup(items: [
            _SettingItem(
                icon: Icons.account_circle_outlined,
                title: tr('계정'),
                subtitle: tr('Talkverse 로그인(선택) · 이용권'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountScreen()))),
          ]),
          const SizedBox(height: 18),
          _SectionTitle(tr('성과')),
          const SizedBox(height: 8),
          _SettingsGroup(items: [
            _SettingItem(
                icon: Icons.bar_chart,
                title: tr('진행'),
                subtitle: tr('이번 주 · 글자 · 회화 성과'),
                onTap: () => openPane(context, (_) => const ProgressScreen())),
          ]),
          const SizedBox(height: 18),
          _SectionTitle(tr('기록')),
          const SizedBox(height: 8),
          _SettingsGroup(items: [
            _SettingItem(
                icon: Icons.restart_alt,
                title: tr('학습 기록 초기화'),
                subtitle: tr('회화·동사·단어·성과 기록 삭제'),
                onTap: () => _resetProgress(context)),
          ]),
          const SizedBox(height: 18),
          // 학습자 프로필(일본어앱 learner_prefs) — 이름 → 회화의 {name} 자리, 성별 → 학습자 목소리(새 회화 구조부터)
          _SectionTitle(tr('학습자')),
          const SizedBox(height: 8),
          const _LearnerSection(),
          const SizedBox(height: 18),
          _SectionTitle(tr('설정')),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: LearnerPrefs.reading,
            builder: (context, on, _) => _SettingsGroup(items: [
              _SettingItem(
                  icon: Icons.language,
                  title: tr('언어 / Language'),
                  subtitle: '${AppLangPrefs.lang.value.label}  →  ${AppLangPrefs.peekNext().label}',
                  onTap: AppLangPrefs.next),
              _SettingItem(
                  icon: Icons.record_voice_over_outlined,
                  title: tr('독음'),
                  subtitle: on ? tr('표시 — 탭하면 숨김') : tr('숨김 — 탭하면 표시'),
                  onTap: () => ReadingToggleAction.toggle(context)),
            ]),
          ),
          const SizedBox(height: 16),
          _SectionTitle(tr('정보')),
          const SizedBox(height: 8),
          _SettingsGroup(items: [
            _SettingItem(
                icon: Icons.menu_book_outlined,
                title: tr('앱 소개'),
                subtitle: tr('절벽구간 — 단어를 나누는 기준'),
                onTap: () => openPane(context, (_) => const AboutScreen())),
            _SettingItem(icon: Icons.info_outline, title: tr('앱 버전'), subtitle: '0.1.0 · alpha'),
            _SettingItem(icon: Icons.copyright, title: tr('저작권'), subtitle: tr('아랍어유니버스 · 2026')),
            _SettingItem(
                icon: Icons.description_outlined,
                title: tr('라이선스'),
                subtitle: tr('오픈소스 라이선스'),
                onTap: () => showLicensePage(context: context, applicationName: tr('아랍어유니버스'))),
          ]),
          const SizedBox(height: 20),
          const BandDivider(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        color: AppColors.tinta,
        letterSpacing: 2,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gualda.withValues(alpha: 0.5)),
      ),
      child: Material(type: MaterialType.transparency, child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              onTap: items[i].onTap,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.rojo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.rojo, width: 0.8),
                ),
                child: Icon(items[i].icon, color: AppColors.rojo, size: 18),
              ),
              title: Text(items[i].title,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.tinta)),
              subtitle: Text(items[i].subtitle,
                  style: const TextStyle(color: AppColors.tintaLight, fontSize: 11)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.rojo, size: 18),
            ),
            if (i < items.length - 1)
              Container(height: 0.5, color: AppColors.gualda.withValues(alpha: 0.3)),
          ],
        ],
      )),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  _SettingItem({required this.icon, required this.title, required this.subtitle, this.onTap});
}
/// 학습자 이름·성별(일본어앱 profile_screen 학습자 프로필 이식, 2026-11-02).
class _LearnerSection extends StatelessWidget {
  const _LearnerSection();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
        valueListenable: LearnerPrefs.name,
        builder: (context, name, _) => ValueListenableBuilder<String>(
          valueListenable: LearnerPrefs.gender,
          builder: (context, gender, _) => Container(
            decoration: BoxDecoration(
              color: AppColors.cal,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gualda.withValues(alpha: 0.5)),
            ),
            child: Material(type: MaterialType.transparency, child: Column(children: [
              ListTile(
                leading: const Icon(Icons.badge_outlined, color: AppColors.rojo),
                title: Text(tr('이름'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.tinta)),
                subtitle: Text(name.isNotEmpty ? trf('{0} — 회화 속 「나」로 나와요', [name]) : tr('없음 — 회화에서 「○○」로 보여요'),
                    style: const TextStyle(color: AppColors.tintaLight, fontSize: 11)),
                trailing: const Icon(Icons.edit_outlined, color: AppColors.rojo, size: 18),
                onTap: () => _editName(context),
              ),
              Container(height: 0.5, color: AppColors.gualda.withValues(alpha: 0.3)),
              ListTile(
                leading: Icon(gender == 'female' ? Icons.face_3 : Icons.face, color: AppColors.rojo),
                title: Text(tr('성별'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.tinta)),
                subtitle: Text(gender == 'female' ? tr('여성 — 탭하면 남성') : tr('남성 — 탭하면 여성'),
                    style: const TextStyle(color: AppColors.tintaLight, fontSize: 11)),
                onTap: () => LearnerPrefs.setGender(gender == 'female' ? 'male' : 'female'),
              ),
            ])),
          ),
        ),
      );

  Future<void> _editName(BuildContext context) async {
    final c = TextEditingController(text: LearnerPrefs.name.value);
    final v = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr('이름')),
        content: TextField(controller: c, autofocus: true, decoration: InputDecoration(hintText: tr('회화에서 불릴 이름'))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(tr('취소'))),
          TextButton(onPressed: () => Navigator.pop(ctx, c.text), child: Text(tr('저장'))),
        ],
      ),
    );
    if (v != null) await LearnerPrefs.setName(v);
  }
}
