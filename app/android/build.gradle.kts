allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 일부 Flutter 플러그인이 Kotlin languageVersion 1.6을 지정하는데, Kotlin 2.x 컴파일러는
// 1.6을 더 이상 지원하지 않는다. 그렇다고 전부 1.8로 묶으면 최신 플러그인
// (package_info_plus 등)이 컴파일되지 않으므로, **명시적으로 1.9 미만을 지정한 모듈만** 1.9로 올린다.
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        val minVersion = org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_9
        compilerOptions {
            languageVersion.set(
                languageVersion.orNull?.let { if (it < minVersion) minVersion else it }
            )
            apiVersion.set(
                apiVersion.orNull?.let { if (it < minVersion) minVersion else it }
            )
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
