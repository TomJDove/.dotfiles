#!/usr/bin/env python3
"""
Toggle a "focus mode" that centres the text of the current kitty window by padding its left and right sides.

Map it in kitty.conf, optionally passing the desired number of columns (default 120):

    map f11 kitten focus_mode.py 120

Running it again on a window that is in focus mode restores that window's normal padding. Only the window the
shortcut is pressed in is affected, so splits and other tabs keep their usual width, and nothing is reloaded.
"""

from __future__ import annotations

from collections.abc import Sequence

from kittens.tui.handler import result_handler

DEFAULT_COLUMNS = 120
MAX_CORRECTION_PASSES = 4


def main(args: list[str]) -> None:
    """
    Nothing runs in the kitten's own window; all the work happens in handle_result inside the kitty process.
    """


def _target_columns(args: Sequence[str]) -> int:
    try:
        return max(1, int(args[1]))
    except (IndexError, ValueError):
        return DEFAULT_COLUMNS


@result_handler(no_ui=True)
def handle_result(args: Sequence[str], answer: object, target_window_id: int, boss: object) -> None:
    from kitty.fast_data_types import pt_to_px

    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    tab = boss.tab_for_window(window)
    if tab is None:
        return

    if window.padding.left is not None or window.padding.right is not None:
        # Focus mode is on for this window: drop the per-window override so the configured padding applies again.
        window.padding.left = window.padding.right = None
        tab.relayout()
        return

    columns = _target_columns(args)
    cell_width = window.geometry.right - window.geometry.left
    cell_width = cell_width // window.geometry.xnum if window.geometry.xnum else 0
    if cell_width <= 0:
        return
    px_per_pt = pt_to_px(1000, window.os_window_id) / 1000

    # Start from the padding currently in effect and widen it by half the excess text width on each side.
    pad_px = window.effective_padding("left") + (window.geometry.xnum - columns) * cell_width / 2
    if pad_px < window.effective_padding("left"):
        boss.show_error("Focus mode", f"The window is not wide enough to centre {columns} columns.")
        return

    # Point to pixel rounding can shift the result by a column, so nudge until the column count is exact.
    for _ in range(MAX_CORRECTION_PASSES):
        window.padding.left = window.padding.right = pad_px / px_per_pt
        tab.relayout()
        excess = window.geometry.xnum - columns
        if excess == 0:
            break
        pad_px += excess * cell_width / 2
