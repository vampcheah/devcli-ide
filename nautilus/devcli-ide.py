# DevCli IDE 键盘快捷键扩展 for GNOME Files (Nautilus)
#
# Ctrl+Shift+. → 在当前浏览的文件夹启动 DevCli IDE (dev-cli.sh)。
#
# 工作原理:
#   - 运行在 Nautilus 进程内部(由 python3-nautilus 加载器加载),因此能直接挂一个
#     真正会触发的 GtkShortcutController —— scripts-accels 在 GTK4 Nautilus 上失效,
#     这是可靠的替代方案,且不污染右键菜单。
#   - get_background_items 会在切换目录/标签页时被调用,从中拿到当前文件夹完整路径并缓存。
#   - Shift+. 在多数键盘布局上产生 keyval 'greater'(>) 而非 'period',故两个都绑。
#
# 位置: ~/.local/share/nautilus-python/extensions/devcli-ide.py
# 依赖: python3-nautilus

import gi
gi.require_version('Gtk', '4.0')  # nautilus-python 不会自动 require
from gi.repository import Nautilus, GObject, Gio, Gtk
from urllib.parse import unquote

DEVCLI = '/home/francischeah/Documents/projects/003_devcli_ide/dev-cli.sh'
TRIGGERS = ['<Primary><Shift>period', '<Primary>greater']  # Ctrl+Shift+.


class DevCliIdeExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()
        self.uri_for_window = {}   # 窗口 -> 当前目录
        self.installed = set()     # 已挂过 controller 的窗口

    def _install(self, window):
        ctrl = Gtk.ShortcutController.new()
        ctrl.set_scope(Gtk.ShortcutScope.GLOBAL)  # 无视焦点在哪个子控件
        for spec in TRIGGERS:
            trigger = Gtk.ShortcutTrigger.parse_string(spec)
            if trigger is not None:
                ctrl.add_shortcut(
                    Gtk.Shortcut.new(trigger, Gtk.CallbackAction.new(self._on_shortcut)))
        window.add_controller(ctrl)

    def get_background_items(self, current_folder):
        uri = current_folder.get_uri()
        for window in Gtk.Window.get_toplevels():
            if window.is_active():
                if window not in self.installed:
                    self._install(window)
                    self.installed.add(window)
                if uri.startswith('file://'):
                    self.uri_for_window[window] = unquote(uri[7:])
        # 清理已关闭的窗口
        live = set(Gtk.Window.get_toplevels())
        for dead in (set(self.uri_for_window) - live):
            del self.uri_for_window[dead]
        self.installed &= live
        return []

    def _on_shortcut(self, widget, _args):
        path = self.uri_for_window.get(widget)
        if path is None:   # 容错: widget 可能不是窗口本身
            for window in Gtk.Window.get_toplevels():
                if window.is_active() and window in self.uri_for_window:
                    path = self.uri_for_window[window]
                    break
        if path:
            # 剥掉 TMUX/TMUX_PANE, 避免 dev-cli.sh 误判「已在 tmux 内」而退出
            Gio.Subprocess.new(
                ['env', '-u', 'TMUX', '-u', 'TMUX_PANE',
                 'bash', '-lc', 'exec "$0" "$1"', DEVCLI, path],
                Gio.SubprocessFlags.NONE,
            )
        return True   # 已处理
