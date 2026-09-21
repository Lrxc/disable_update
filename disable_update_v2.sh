#!/usr/bin/env bash
set -euo pipefail

# 需要处理的路径
readonly PATHS=(
	"$HOME/Library/Application Support/Microsoft/EdgeUpdater"
	"$HOME/Library/Microsoft/MicrosoftSoftwareUpdate"
	"$HOME/Library/Application Support/Google/GoogleUpdater"
	"$HOME/Library/Google/GoogleSoftwareUpdate"
	"$HOME/Library/Application Support/Caches/apifox-updater"
	"$HOME/Library/Caches/com.anthropic.claudefordesktop.ShipIt"
	"$HOME/Library/Application Support/Claude-3p/vm_bundles"
	"$HOME/Library/Caches/com.google.antigravity-ide.ShipIt"
	"$HOME/Library/Containers/com.kingsoft.wpsoffice.mac/Data/.kingsoft/WpsUpdate"
)

# 权限配置
readonly MODE_DISABLED="555"  # 禁用(所有人只读)
readonly MODE_RESTORED="755" # 恢复

# 修改权限
set_mode() {
	local action="$1" mode="$2"
	for path in "${PATHS[@]}"; do
		if [ ! -e "$path" ]; then
			echo "\t新建: $path"
			sudo mkdir -p "$path"
		fi
		# echo "$action: $path -> $mode"
		echo "$action: $(realpath "$path") -> $mode"
		sudo chmod "$mode" "$path"
	done
}

usage() {
	echo "用法: $(basename "$0") {on|off}"
	echo "  on   开启禁用"
	echo "  off  恢复权限"
}

main() {
	local action mode
	case "${1:-}" in
	on)
		action="禁用"
		mode="$MODE_DISABLED"
		;;
	off)
		action="恢复"
		mode="$MODE_RESTORED"
		;;
	*)
		usage
		exit 1
		;;
	esac

	sudo -v                    # 先验证密码
	set_mode "$action" "$mode" # 处理所有路径
}

main "$@"
