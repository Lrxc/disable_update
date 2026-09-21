# disable_update

阻止应用自动更新，支持 macos/windows

## macOS

两个版本，功能一样，改的东西不同,推荐v2：

| 脚本 | on | off |
| --- | --- | --- |
| `disable_update.sh` | 属主改成 `root:wheel` | 属主改回自己 |
| `disable_update_v2.sh` | `chmod 555`（只读） | `chmod 755` |

```bash
./disable_update.sh on
./disable_update_v2.sh on
```

## Windows

等价于 `chmod 000`：把目录设成拒绝一切访问。

```powershell
.\disable_update.ps1 on
.\disable_update.ps1 off
```

## 适配列表

### macOS

| 应用 | 路径 |
| --- | --- |
| Edge | `~/Library/Application Support/Microsoft/EdgeUpdater`<br>`~/Library/Microsoft/MicrosoftSoftwareUpdate` |
| Chrome | `~/Library/Application Support/Google/GoogleUpdater`<br>`~/Library/Google/GoogleSoftwareUpdate` |
| Apifox | `~/Library/Application Support/Caches/apifox-updater` |
| Claude Code Desktop | `~/Library/Caches/com.anthropic.claudefordesktop.ShipIt`<br>`~/Library/Application Support/Claude-3p/vm_bundles` |
| Antigravity | `~/Library/Caches/com.google.antigravity-ide.ShipIt` |
| WPS | `~/Library/Containers/com.kingsoft.wpsoffice.mac/Data/.kingsoft/WpsUpdate` |

### Windows

| 应用 | 路径 |
| --- | --- |
| Edge | `%LOCALAPPDATA%\Microsoft\EdgeUpdate` |
| Chrome | `%LOCALAPPDATA%\Google\Update` |
| Apifox | `%LOCALAPPDATA%\apifox-updater` |
| Claude Desktop | `%LOCALAPPDATA%\SquirrelTemp` |
| Antigravity | `%LOCALAPPDATA%\antigravity-updater` |
| WPS | `%LOCALAPPDATA%\Kingsoft\WPS Office\update` |

Windows 的路径是从 macOS 推断的，未在实机验证，请按实际安装情况调整。

## 注意

- macOS 路径用 `$HOME`，不能用 `~`（引号里的 `~` 不展开，会创建名为 `~` 的目录）
- 跑 `on` 前先退出对应应用，否则目录可能被应用重建
- 需要 `sudo` / 管理员权限
- `off` 是固定值（`755` / 重置继承），不会还原成原权限

