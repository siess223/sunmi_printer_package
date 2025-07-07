# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- ✨ 完整的商米打印机支持
- 🖨️ 文本打印功能（支持字体大小、加粗、下划线、对齐）
- 🖼️ 图片打印功能（支持 Bitmap 格式）
- 🔲 二维码打印功能（可设置大小和纠错级别）
- 📊 条形码打印功能（支持多种格式）
- 📋 表格打印功能（支持多列对齐）
- 🧾 小票打印功能（自定义格式）
- 🖥️ LCD 客显功能（单行/多行文本、图片、数字显示）
- ⚙️ 硬件控制（切纸、开钱箱、进纸）
- 📊 打印机状态查询
- 🔧 缓冲区管理
- 🎯 完整的错误处理机制
- 📱 Android 11+ 包可见性支持

### Technical
- 基于商米官方 `printerlibrary:1.0.18` SDK
- 使用 `InnerPrinterManager` 管理打印机服务连接
- 支持 `SunmiPrinterService` 提供的 LCD API
- 完整的异步回调和错误处理

### Documentation
- 📖 完整的 API 文档
- 🎯 详细的使用示例
- 🔧 安装和配置指南
- 🐛 常见问题解答

### Platform Support
- ✅ Android (主要支持)
- ⚪ iOS (基础框架)
- ⚪ Linux (基础框架)
- ⚪ macOS (基础框架)
- ⚪ Windows (基础框架)
- ⚪ Web (基础框架)

## [0.0.1] - 2024-01-XX

### Added
- 📦 初始项目结构
- 🏗️ 基础 Flutter 插件框架
