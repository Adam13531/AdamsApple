#!/usr/bin/python3
"""Interactive launcher for streaming tools. Opens iTerm2 tabs for selected tools."""

import sys
import tty
import termios
import subprocess
from dataclasses import dataclass

# ANSI escape codes
RESET        = '\033[0m'
BOLD_CYAN    = '\033[1;36m'
BOLD_YELLOW  = '\033[1;33m'
BOLD_GREEN   = '\033[1;32m'
BOLD_RED     = '\033[1;31m'
DIM_WHITE    = '\033[2;37m'
ERASE_LINE   = '\033[2K'
CURSOR_UP    = '\033[A'
HIDE_CURSOR  = '\033[?25l'
SHOW_CURSOR  = '\033[?25h'


@dataclass
class Tool:
    name: str
    directory: str
    command: str
    default_selected: bool


TOOLS = [
    Tool('StreamTitler',       '/Volumes/inland/code/StreamTitler',       'npm start',       default_selected=True),
    Tool('OBSPianoMuteToggle', '/Volumes/inland/code/OBSPianoMuteToggle', 'python3 main.py', default_selected=False),
]

BORDER = f"{BOLD_CYAN}{'─' * 50}{RESET}"
HEADER = f"{BOLD_CYAN}  STREAM LAUNCHER{RESET}"
HINT   = f"{BOLD_CYAN}  [↑↓] navigate  [Space] toggle  [Enter] launch  [q] quit{RESET}"


class Launcher:
    def __init__(self):
        self.cursor = 0
        self.selected = [t.default_selected for t in TOOLS]
        self.error_msg = None
        self._lines_drawn = 0

    def render(self):
        out = []

        # Erase previously drawn lines
        for _ in range(self._lines_drawn):
            out.append(f'{CURSOR_UP}{ERASE_LINE}')

        lines = [
            BORDER,
            HEADER,
            HINT,
            BORDER,
        ]

        for i, tool in enumerate(TOOLS):
            checked = 'x' if self.selected[i] else ' '
            label = f'[{checked}] {tool.name}'
            if i == self.cursor:
                lines.append(f'{BOLD_YELLOW}▶ {label}{RESET}')
            elif self.selected[i]:
                lines.append(f'  {BOLD_GREEN}{label}{RESET}')
            else:
                lines.append(f'  {DIM_WHITE}{label}{RESET}')

        lines.append(BORDER)

        if self.error_msg:
            lines.append(f'{BOLD_RED}  {self.error_msg}{RESET}')

        out.extend(line + '\r\n' for line in lines)
        sys.stdout.write(''.join(out))
        sys.stdout.flush()
        self._lines_drawn = len(lines)

    def read_key(self, fd):
        ch = sys.stdin.buffer.read(1)
        if ch == b'\x1b':
            # Temporarily set non-blocking read to disambiguate bare Escape
            old = termios.tcgetattr(fd)
            new = termios.tcgetattr(fd)
            new[6][termios.VMIN] = 0
            new[6][termios.VTIME] = 1
            termios.tcsetattr(fd, termios.TCSANOW, new)
            ch2 = sys.stdin.buffer.read(1)
            termios.tcsetattr(fd, termios.TCSANOW, old)
            if ch2 == b'[':
                ch3 = sys.stdin.buffer.read(1)
                if ch3 == b'A':
                    return 'up'
                if ch3 == b'B':
                    return 'down'
            return 'quit'  # bare Escape or unknown sequence
        if ch == b' ':
            return 'space'
        if ch == b'\r':
            return 'enter'
        if ch in (b'q', b'Q'):
            return 'quit'
        return None

    def launch(self, tool):
        cmd = f'title {tool.name}; cd {tool.directory} && {tool.command}'
        script = f'''tell application id "com.googlecode.iterm2"
    activate
    if (count of windows) is 0 then
        create window with default profile
    end if
    tell first window
        create tab with default profile
        tell current session of current tab
            write text "{cmd}"
        end tell
    end tell
end tell'''
        subprocess.run(['osascript', '-e', script], check=True)

    def run(self):
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        sys.stdout.write(HIDE_CURSOR)
        sys.stdout.flush()
        try:
            tty.setraw(fd)
            while True:
                self.render()
                key = self.read_key(fd)
                self.error_msg = None
                if key == 'up':
                    self.cursor = (self.cursor - 1) % len(TOOLS)
                elif key == 'down':
                    self.cursor = (self.cursor + 1) % len(TOOLS)
                elif key == 'space':
                    self.selected[self.cursor] = not self.selected[self.cursor]
                elif key == 'enter':
                    chosen = [t for i, t in enumerate(TOOLS) if self.selected[i]]
                    if not chosen:
                        self.error_msg = 'Nothing selected — use Space to select a tool.'
                        continue
                    break
                elif key == 'quit':
                    # Clear the UI before exiting
                    self.render()
                    return
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
            sys.stdout.write(SHOW_CURSOR)
            sys.stdout.flush()

        # Re-render final state before launching (clears UI)
        self.render()

        for tool in [t for i, t in enumerate(TOOLS) if self.selected[i]]:
            try:
                self.launch(tool)
            except subprocess.CalledProcessError:
                print(f'{BOLD_RED}  Failed to open {tool.name} — is iTerm2 running?{RESET}')


def main():
    Launcher().run()


if __name__ == '__main__':
    main()
