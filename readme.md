# disable_update

阻止应用自动更新，支持 macos/windows

## macOS

两个版本，功能一样，改的东西不同,推荐v2：

| 脚本 | on | off |
| --- | --- | --- |
| `disable_update.sh` | 属主改成 `root:wheel` | 属主改回自己 |
| `disable_update_v2.sh` | `chmod 000` | `chmod 755` |

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
