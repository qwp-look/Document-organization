# file_organizer_recursive.ps1
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$SourceDir,

    [Parameter(Position=1)]
    [string]$TargetDir = "",

    [Parameter(Position=2)]
    [string[]]$ExcludeExt = @()  # 要排除的扩展名，不带 “.”
)

if (-not (Test-Path $SourceDir -PathType Container)) {
    Write-Error "源目录不存在：$SourceDir"
    exit 1
}
if ([string]::IsNullOrWhiteSpace($TargetDir)) {
    $TargetDir = Join-Path $SourceDir 'Organized'
}

$files = Get-ChildItem -Path $SourceDir -Recurse -File | Where-Object { $ExcludeExt -notcontains ($_.Extension.TrimStart('.')) }
$total = $files.Count
if ($total -eq 0) {
    Write-Host "未发现需要处理的文件，退出。"
    exit 0
}

# 日志文件
$LogFile = Join-Path $PSScriptRoot 'organizer.log'
if (Test-Path $LogFile) {
    Copy-Item $LogFile "$LogFile.bak" -Force
    Remove-Item $LogFile
}

[int]$index = 0
foreach ($file in $files) {
    $index++
    $ext = if ($file.Extension) { $file.Extension.TrimStart('.') } else { 'NoExt' }
    $destDir = Join-Path $TargetDir $ext

    # 显示进度条
    $percent = [math]::Round(($index / $total) * 100, 1)
    Write-Progress -Activity "文件整理中" `
                   -Status "处理 ($index/$total): $($file.Name)" `
                   -PercentComplete $percent

    # 创建目标文件夹
    if (-not (Test-Path $destDir)) {
        try { New-Item -Path $destDir -ItemType Directory -ErrorAction Stop | Out-Null }
        catch {
            Add-Content -Path $LogFile -Value "[$(Get-Date)] ERROR: 无法创建文件夹 $destDir"
            exit 2
        }
    }

    # 冲突处理
    $destFile = Join-Path $destDir $file.Name
    if (Test-Path $destFile) {
        $base = [IO.Path]::GetFileNameWithoutExtension($file.Name)
        $suf  = $file.Extension
        $n    = 1
        do {
            $newName  = "{0}_{1}{2}" -f $base, $n, $suf
            $destFile = Join-Path $destDir $newName
            $n++
        } while (Test-Path $destFile)
    }

    # 移动并记录日志
    try {
        Move-Item -Path $file.FullName -Destination $destFile -ErrorAction Stop
        Add-Content -Path $LogFile -Value "[$(Get-Date)] MOVE $($file.FullName) -> $destFile"
    } catch {
        Add-Content -Path $LogFile -Value "[$(Get-Date)] ERROR: 移动 $($file.FullName) 失败"
    }
}

Write-Host "完成，详细日志已写入 $LogFile"
