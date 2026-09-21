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

# 属主配置
readonly OWNER_DISABLED="root:wheel"  # 禁用
readonly OWNER_RESTORED="lrxc:staff" # 恢复

# 修改属主
set_owner() {
	local action="$1" owner="$2"
	for path in "${PATHS[@]}"; do
		if [ ! -e "$path" ]; then
			echo "\t新建: $path"
			sudo mkdir -p "$path"
		fi
		# echo "$action: $path -> $owner"
		echo "$action: $(realpath "$path") -> $owner"
		sudo chown "$owner" "$path"
	done
}

usage() {
	echo "用法: $(basename "$0") {on|off}"
	echo "  on   开启禁用"
	echo "  off  恢复权限"
}

main() {
	local action owner
	case "${1:-}" in
	on)
		action="禁用"
		owner="$OWNER_DISABLED"
		;;
	off)
		action="恢复"
		owner="$OWNER_RESTORED"
		;;
	*)
		usage
		exit 1
		;;
	esac

	sudo -v                    # 先验证密码
	set_owner "$action" "$owner" # 处理所有路径
}

main "$@"
