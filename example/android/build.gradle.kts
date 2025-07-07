allprojects {
    repositories {
        google()
        mavenCentral()
        // 添加Sunmi官方仓库 - 支持PrintX SDK
        maven { url = uri("https://artifactory.sunmi.com/artifactory/sunmi-public/") }
        maven { url = uri("https://maven.aliyun.com/repository/public/") }
        // Sunmi的官方Maven仓库 - 允许不安全协议
        maven { 
            url = uri("http://maven.sunmi.com:8081/artifactory/sunmi-public/")
            isAllowInsecureProtocol = true
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
