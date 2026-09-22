#!/usr/bin/env bash
set -euo pipefail

# 需要处理的路径
readonly PATHS=(
	"$HOME/Library/Application Support/Microsoft/EdgeUpdater"
	"$HOME/Library/Microsoft/MicrosoftSoftwareUpdate"
	"$HOME/Library/Application Support/Google/GoogleUpdater"
	"$HOME/Library/Google/GoogleSoftwareUpdate"
	"$HOME/Library/Application Support/Caches/apifox-updater"
	# "$HOME/Library/Caches/com.anthropic.claudefordesktop.ShipIt"
	"$HOME/Library/Application Support/Claude-3p/vm_bundles"
	# "$HOME/Library/Caches/com.google.antigravity-ide.ShipIt"
	"$HOME/Library/Containers/com.kingsoft.wpsoffice.mac/Data/.kingsoft/WpsUpdate"
	"$HOME/Library/Caches/Sublime Text/Update"
)

# 标志配置
readonly FLAG_DISABLED="uchg"   # 禁用(加锁，即 Finder 里的"已锁定")
readonly FLAG_RESTORED="nouchg" # 恢复

# 修改标志
# -R 递归：只锁目录本身挡不住"改写已有文件"，必须连内部一起锁
set_flag() {
	local action="$1" flag="$2"
	for path in "${PATHS[@]}"; do
		if [ ! -e "$path" ]; then
			echo "\t新建: $path"
			mkdir -p "$path"
		fi
		# echo "$action: $path -> $flag"
		echo "$action: $(realpath "$path") -> $flag"
		sudo chflags -R "$flag" "$path"
	done
}

usage() {
	echo "用法: $(basename "$0") {on|off}"
	echo "  on   开启禁用"
	echo "  off  恢复权限"
}

main() {
	local action flag
	case "${1:-}" in
	on)
		action="禁用"
		flag="$FLAG_DISABLED"
		;;
	off)
		action="恢复"
		flag="$FLAG_RESTORED"
		;;
	*)
		usage
		exit 1
		;;
	esac

	sudo -v                    # 先验证密码
	set_flag "$action" "$flag" # 处理所有路径
}

main "$@"
