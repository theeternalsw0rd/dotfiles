from __future__ import annotations
from xonsh.xontribs import xontribs_load
import os
import subprocess
from shutil import which
from xonsh.built_ins import XSH

from prompt_toolkit.cursor_shapes import CursorShape, CursorShapeConfig
from prompt_toolkit.enums import EditingMode
from prompt_toolkit.key_binding.vi_state import InputMode

#__xonsh__.env['XONSH_COLOR_STYLE'] = 'dracula'

xontribs_load(['prompt_starship', 'zoxide'])

__xonsh__.env['VI_MODE'] = "true"

class BlinkingViCursor(CursorShapeConfig):
    """Cursor shape config that blinks and follows vi insert/normal modes."""

    def get_cursor_shape(self, app) -> CursorShape:
        """Return the cursor shape for the current prompt_toolkit application state."""
        if app.editing_mode == EditingMode.VI:
            if app.vi_state.input_mode == InputMode.NAVIGATION:
                return CursorShape.BLINKING_BLOCK
            return CursorShape.BLINKING_BEAM

        # If you ever run emacs mode in xonsh, pick a reasonable default.
        return CursorShape.BLINKING_BEAM


def _enable_blinking_vi_cursor() -> None:
    """Configure xonsh to use a blinking cursor that matches vi mode."""
    # xonsh exposes the environment through the global __xonsh__ object in Python configs.
    __xonsh__.env["XONSH_PROMPT_CURSOR_SHAPE"] = BlinkingViCursor()


_enable_blinking_vi_cursor()

if os.name == 'nt':
    __xonsh__.aliases['pwd'] = 'pwsh -NoProfile -Command "pwd"'

__xonsh__.aliases['cd'] = 'z'

if which('eza'):
    __xonsh__.aliases['ls'] = 'eza --icons'
else:
    print("Warning: 'eza' not found in PATH. 'ls' aliases will not be set.")

if which('bat'):
    __xonsh__.aliases['cat'] = 'bat'
else:
    print("Warning: 'bat' not found in PATH. 'cat' aliases will not be set.")

if which('rg'):
    __xonsh__.aliases['grep'] = 'rg'
else:
    print("Warning: 'rg' (ripgrep) not found in PATH. 'grep' aliases will not be set.")

def _null_device() -> str:
    """Return the platform-appropriate null device path."""
    return "NUL" if os.name == "nt" else "/dev/null"

def _atuin_on_path() -> bool:
    """Return True if 'atuin' is available on PATH."""
    return which("atuin") is not None

if not _atuin_on_path():
    print("Atuin not found on PATH; skipping atuin init")
else:
    null_dev = _null_device()
    with open(null_dev, "w", encoding="utf-8", errors="ignore") as devnull:
        # Get the xonsh init script from atuin
        proc = subprocess.run(
            ["atuin", "init", "xonsh"],
            check=False,
            stdout=subprocess.PIPE,
            stderr=devnull,
            text=True,
        )

    if proc.returncode != 0 or not proc.stdout.strip():
        print("Atuin init failed (atuin returned non-zero or empty output); skipping")
    else:
        # Execute the generated xonsh init script in the current shell context
        execx(proc.stdout)

if which('fastfetch'):
    subprocess.run(['fastfetch'])
