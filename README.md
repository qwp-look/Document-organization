# 文档组织器

一个基于脚本的简单工具，用于将指定目录中的文件按扩展名自动分类到子文件夹中。支持 Windows Batch 和 PowerShell 两种版本，具备日志记录、排除指定文件类型、同名冲突处理和实时进度显示等功能。

## 功能特性

* **按扩展名分类**：将文件移动到以扩展名命名的子文件夹中，例如 `jpg/`、`pdf/`、`NoExt/`。
* **排除列表**：跳过指定扩展名的文件（如 `exe`、`msi`、`dll`）。
* **同名文件处理**：遇到重名时自动重命名（例如 `file_1.txt`）。
* **日志记录**：详细将操作记录到 `organizer.log`，并自动备份历史日志。
* **实时进度**：

  * **Batch 脚本**：控制台 ASCII 进度条
  * **PowerShell 脚本**：系统原生 `Write-Progress` 界面
* **编码支持**：可通过 `chcp` 切换控制台编码，正确显示中文等非 ASCII 字符。

## 环境要求

* 操作系统：Windows 10/11
* PowerShell：5.1 及以上（运行 PowerShell 版本时）

## 仓库结构

```
Document-organization/
├── file_organizer_recursive.bat    # 批处理版本脚本
├── file_organizer_recursive.ps1    # PowerShell 版本脚本
├── organizer.log                   # 运行时生成的日志文件
└── README.md                       # 本项目说明文档
```

## 使用说明

### 批处理脚本

1. 打开 **命令提示符**。
2. （可选）若脚本中含中文，需要切换编码：

   ```bat
   @echo off
   chcp 65001 >nul    :: 切换到 UTF-8 编码（需脚本以带 BOM 的 UTF-8 保存）
   ```
3. 执行脚本：

   ```bat
   file_organizer_recursive.bat "C:\Downloads" "D:\Organized" "exe,msi,dll"
   ```

* **`<SourceDir>`**：要整理的源文件夹路径
* **`[TargetDir]`**：可选，目标文件夹，默认在源目录下创建 `Organized` 子文件夹
* **`[ExcludeExt]`**：可选，逗号分隔的扩展名列表（无前导点），如 `exe,msi,dll`

### PowerShell 脚本

1. 打开 **PowerShell**（如有需要，先设置执行策略）：

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. 执行脚本：

   ```powershell
   .\file_organizer_recursive.ps1 -SourceDir "C:\Downloads" -TargetDir "D:\Organized" -ExcludeExt "exe","msi","dll"
   ```

* **`-SourceDir`**：必填，源文件夹路径
* **`-TargetDir`**：可选，目标文件夹，默认在源下创建 `Organized`
* **`-ExcludeExt`**：可选，要排除的扩展名数组（无前导点）

## 示例

```bat
:: 在 Downloads 下整理，跳过可执行文件
file_organizer_recursive.bat "C:\Users\Alice\Downloads" "D:\Archive" "exe,msi"
```

```powershell
# 在 C:\Temp 下整理，处理所有文件
.\file_organizer_recursive.ps1 -SourceDir "C:\Temp"
```

## 常见问题与排错

* **中文显示乱码**：

  * 使用 UTF-8 + BOM 并在脚本开头添加 `chcp 65001 >nul`。
  * 或保存为 ANSI（GBK）编码并在开头添加 `chcp 936 >nul`。
* **权限不足**：请以管理员身份运行，或选择可写目录。
* **脚本执行被阻止**（PowerShell）：设置执行策略 `RemoteSigned` 或 `Bypass`。

## 贡献指南

欢迎提交 Issue 或 PR：

1. Fork 本仓库
2. 新建分支：`git checkout -b feature-name`
3. 提交修改：`git commit -m "添加新功能"\`
4. 推送分支：`git push origin feature-name`
5. 发起 Pull Request

##
