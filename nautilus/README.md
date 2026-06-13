# DevCli IDE — Nautilus 快捷键

`devcli-ide.py` 是 GNOME Files (Nautilus) 的 nautilus-python 扩展:在「文件」窗口里
按 **`Ctrl+Shift+.`**,即可在**当前浏览的文件夹**启动 DevCli IDE(`../dev-cli.sh`)。

与 Nautilus 内置的 `Ctrl+.`(Open in Console)对称,只是换成启动 DevCli IDE。

## 安装

```bash
sudo apt install -y python3-nautilus           # 加载器(没装则所有 .py 扩展都不生效)
mkdir -p ~/.local/share/nautilus-python/extensions
cp nautilus/devcli-ide.py ~/.local/share/nautilus-python/extensions/
nautilus -q                                    # 重启文件管理器加载扩展
```

然后打开「文件」,进入任意文件夹,按 `Ctrl+Shift+.`。

## 实现要点 / 踩过的坑

- 用进程内的 `Gtk.ShortcutController`(scope=GLOBAL),**不是** `scripts-accels` ——
  后者在 GTK4 Nautilus 上失效,且脚本名带空格直接不触发。
- `Shift+.` 在多数键盘布局产生 keyval `greater`(`>`)而非 `period`,所以同时绑
  `<Primary><Shift>period` 和 `<Primary>greater`。
- 启动时 `env -u TMUX -u TMUX_PANE`,避免 `dev-cli.sh` 误判「已在 tmux 内」而退出。

## 换机器注意

`devcli-ide.py` 顶部 `DEVCLI` 常量是本机绝对路径,换机器/换用户名时需相应修改。
