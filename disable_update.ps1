#Requires -Version 5.1
<#
.SYNOPSIS
    用权限锁死目录，阻止应用自动更新（Windows）

.DESCRIPTION
    等价于 chmod 000 —— 把目录设成拒绝一切访问。

      on   锁定：去掉继承 + 拒绝所有人
      off  恢复：还原成从父目录继承的默认权限

    只改权限，不删文件。

.EXAMPLE
    .\disable_update.ps1 on
    .\disable_update.ps1 off

.NOTES
    若提示"禁止运行脚本"，先执行：
        Set-ExecutionPolicy -Scope Process Bypass
#>

param(
	[Parameter(Position = 0, Mandatory = $true)]
	[ValidateSet('on', 'off')]
	[string]$Action
)

# ===========================================================================
# 目标目录：按需增删
#
# 只锁"更新器专用目录"。不要锁应用自己的安装目录，
# 否则应用会直接打不开（不只是更新被挡）。
# ===========================================================================
$Paths = @(
	"$env:LOCALAPPDATA\Microsoft\EdgeUpdate"       # Edge
	"$env:LOCALAPPDATA\Google\Update"              # Chrome
	"$env:LOCALAPPDATA\apifox-updater"             # Apifox
	"$env:LOCALAPPDATA\SquirrelTemp"               # Claude Desktop 等 Squirrel 应用
	"$env:LOCALAPPDATA\antigravity-updater"        # Antigravity
	"$env:LOCALAPPDATA\Kingsoft\WPS Office\update" # WPS
)

foreach ($path in $Paths) {
	if (-not (Test-Path -LiteralPath $path)) {
		Write-Host "跳过（不存在）: $path"
		continue
	}

	if ($Action -eq 'on') {
		Write-Host "锁定: $path"
		# /inheritance:r              去掉从父目录继承来的权限
		# /deny *S-1-1-0:(OI)(CI)(F)  拒绝 Everyone 全部权限
		#                             （S-1-1-0 是 SID，不受系统语言影响）
		# /T /C /Q                    递归；单个失败继续；安静模式
		icacls.exe "$path" /inheritance:r /deny "*S-1-1-0:(OI)(CI)(F)" /T /C /Q
	}
	else {
		Write-Host "恢复: $path"
		# 还原成从父目录继承的默认权限
		icacls.exe "$path" /reset /T /C /Q
	}

	if ($LASTEXITCODE -ne 0) {
		Write-Warning "  上面有报错。若提示拒绝访问，请用管理员身份重跑。"
	}
}

Write-Host ''
Write-Host '完成。'
