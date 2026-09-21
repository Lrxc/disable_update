# disable_update

阻止应用自动更新，可逆，用 `off` 恢复。

## macOS

改属主：`on` 改成 `root:wheel`，`off` 改回自己。

```bash
./disable_update.sh on
./disable_update.sh off
```

## Windows

等价于 `chmod 000`：把目录设成拒绝一切访问。

```powershell
.\disable_update.ps1 on
.\disable_update.ps1 off
```
