# 📚 商米打印机插件发布教程

本教程将指导您如何将商米打印机插件发布到 GitHub，并在其他项目中使用。

## 🚀 发布到 GitHub

### 1. 准备工作

#### 检查项目完整性
确保您的项目包含以下必要文件：
- ✅ `README.md` - 项目介绍和使用说明
- ✅ `pubspec.yaml` - 插件配置文件
- ✅ `LICENSE` - 许可证文件
- ✅ `CHANGELOG.md` - 版本变更记录
- ✅ `lib/` - 插件核心代码
- ✅ `android/` - Android 平台代码
- ✅ `example/` - 示例项目

#### 更新 pubspec.yaml
确保 `pubspec.yaml` 包含正确的信息：
```yaml
name: sunmi_printer
description: A complete Flutter plugin for Sunmi printer...
version: 1.0.0
homepage: https://github.com/yourusername/sunmi_printer
repository: https://github.com/yourusername/sunmi_printer
```

### 2. 创建 GitHub 仓库

1. 登录 [GitHub](https://github.com)
2. 点击右上角的 "+" 按钮，选择 "New repository"
3. 填写仓库信息：
   - **Repository name**: `sunmi_printer`
   - **Description**: `A complete Flutter plugin for Sunmi printer with printing and LCD display features`
   - **Public**: 选择 Public（公开）
   - **Initialize this repository**: 不勾选（因为我们已有代码）

### 3. 本地 Git 配置

打开终端，在项目根目录执行：

```bash
# 初始化 Git 仓库（如果还没有）
git init

# 添加远程仓库
git remote add origin https://github.com/yourusername/sunmi_printer.git

# 添加所有文件
git add .

# 提交代码
git commit -m "Initial commit: Complete Sunmi printer plugin v1.0.0"

# 推送到 GitHub
git push -u origin main
```

### 4. 创建发布标签

```bash
# 创建标签
git tag v1.0.0

# 推送标签
git push origin v1.0.0
```

### 5. 创建 GitHub Release

1. 在 GitHub 仓库页面，点击 "Releases"
2. 点击 "Create a new release"
3. 填写信息：
   - **Tag version**: `v1.0.0`
   - **Release title**: `v1.0.0 - Initial Release`
   - **Description**: 复制 CHANGELOG.md 中的内容
4. 点击 "Publish release"

## 📱 在其他项目中使用

### 方法 1：从 GitHub 直接引用

在目标项目的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  sunmi_printer:
    git:
      url: https://github.com/yourusername/sunmi_printer.git
      ref: v1.0.0  # 指定版本
```

### 方法 2：从 GitHub 最新代码引用

```yaml
dependencies:
  sunmi_printer:
    git:
      url: https://github.com/yourusername/sunmi_printer.git
      ref: main  # 使用最新代码
```

### 方法 3：本地路径引用（开发阶段）

```yaml
dependencies:
  sunmi_printer:
    path: ../sunmi_printer  # 相对路径
```

### 安装和配置

1. **添加依赖后运行**：
   ```bash
   flutter pub get
   ```

2. **Android 权限配置**：
   在 `android/app/src/main/AndroidManifest.xml` 中添加：
   ```xml
   <!-- 商米打印机权限 -->
   <uses-permission android:name="android.permission.BLUETOOTH" />
   <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
   <uses-permission android:name="com.sunmi.permission.PRINTER" />
   
   <!-- 包可见性声明（Android 11+） -->
   <queries>
       <package android:name="woyou.aidlservice.jiuv5" />
       <package android:name="com.sunmi.hcservice" />
   </queries>
   ```

3. **基础使用示例**：
   ```dart
   import 'package:sunmi_printer/sunmi_printer.dart';
   
   final printer = SunmiPrinter();
   
   // 初始化
   await printer.bindService();
   
   // 打印文本
   await printer.printText('Hello Sunmi!');
   
   // LCD 显示
   await printer.lcdDisplayText('Welcome!');
   ```

## 🔄 版本更新流程

### 1. 更新代码
修改插件代码、修复 bug 或添加新功能

### 2. 更新版本号
在 `pubspec.yaml` 中更新版本：
```yaml
version: 1.0.1  # 修复 bug
# 或
version: 1.1.0  # 添加新功能
# 或
version: 2.0.0  # 重大更改
```

### 3. 更新文档
- 更新 `CHANGELOG.md` 记录变更
- 更新 `README.md` 如有必要

### 4. 提交和发布
```bash
# 提交更改
git add .
git commit -m "v1.0.1: Fix printer connection issue"

# 推送代码
git push origin main

# 创建新标签
git tag v1.0.1
git push origin v1.0.1
```

### 5. 创建 GitHub Release
重复上述发布步骤，创建新的 Release

## 📋 发布检查清单

发布前请确保：

- [ ] 🧪 **功能测试**：所有功能在商米设备上测试通过
- [ ] 📖 **文档完整**：README、API 文档、示例代码都完整
- [ ] 🔧 **配置正确**：pubspec.yaml 信息准确
- [ ] 📝 **版本记录**：CHANGELOG.md 已更新
- [ ] 🏷️ **标签正确**：Git 标签版本号正确
- [ ] 🔗 **链接有效**：所有文档中的链接都有效
- [ ] 💾 **示例运行**：example 项目可以正常运行

## 📦 发布到 pub.dev（可选）

如果您希望发布到 pub.dev 官方仓库：

### 1. 创建 pub.dev 账户
访问 [pub.dev](https://pub.dev) 创建账户

### 2. 验证插件
```bash
flutter packages pub publish --dry-run
```

### 3. 发布插件
```bash
flutter packages pub publish
```

**注意**：发布到 pub.dev 需要遵循更严格的命名和质量标准。

## 🛠️ 持续集成（CI/CD）

### GitHub Actions 配置
创建 `.github/workflows/ci.yml`：

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '11'
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.1'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
```

## 🔍 最佳实践

1. **版本管理**：
   - 使用语义化版本号
   - 每次发布都创建 Git 标签

2. **文档维护**：
   - 保持 README 更新
   - 记录 breaking changes

3. **测试覆盖**：
   - 在真实设备上测试
   - 编写单元测试

4. **社区支持**：
   - 及时回复 Issues
   - 接受 Pull Requests

## 💡 常见问题

### Q: 如何撤销已发布的版本？
A: 无法撤销 pub.dev 上的版本，但可以删除 GitHub 上的 Release 和 Tag。

### Q: 如何处理依赖冲突？
A: 更新 pubspec.yaml 中的依赖版本约束。

### Q: 如何支持多个 Flutter 版本？
A: 在 pubspec.yaml 中设置合适的 environment 约束。

---

**恭喜！** 🎉 您已经成功发布了商米打印机插件。现在其他开发者可以在他们的项目中使用您的插件了！ 