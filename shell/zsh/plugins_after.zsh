# External plugins (initialized after)

# Syntax highlighting

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

if [[ "$(tput colors)" == "256" ]]; then
  # See https://jonasjacek.github.io/colors/ for 256-color codes
  local Red3=160
  local LightSeaGreen=37
  local Chartreuse4=64
  local DarkOrange3=166
  local DarkOrange=208
  local DodgerBlue1=33
  local DeepPink4=125
  local DarkGoldenrod=136
  local SpringGreen1=48
  local Magenta3=164
  local Purple=129
  local Magenta1=201
  local CornflowerBlue=69
  local DarkViolet=92
  local Green3=40
  # Everything not covered below
  ZSH_HIGHLIGHT_STYLES[default]=none
  # Unknown tokens/errors
  ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=$Red3
  # Reserved shell words ("if", "for")
  ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=$Green3,bold #,standout
  # Aliases
  ZSH_HIGHLIGHT_STYLES[alias]=fg=$Magenta3,bold
  # Built-in shell commands ("shift", "pwd", "zstyle")
  ZSH_HIGHLIGHT_STYLES[builtin]=fg=$Magenta3,bold
  # Shell functions
  ZSH_HIGHLIGHT_STYLES[function]=fg=$Magenta3,bold
  # Not sure, but the wiki says "command names"
  ZSH_HIGHLIGHT_STYLES[command]=fg=$Magenta3,bold
  # Precommand modifiers ("noglob", "builtin")
  ZSH_HIGHLIGHT_STYLES[precommand]=fg=$Magenta3,underline
  # Command separation tokens (";", "&&")
  ZSH_HIGHLIGHT_STYLES[commandseparator]=none
  # Not sure, but the wiki says "hashed commands"
  ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=$Green3
  # Existing filenames
  ZSH_HIGHLIGHT_STYLES[path]=fg=$CornflowerBlue,underline
  # Path separators in filenames ("/")
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]=fg=$DarkViolet
  # Globbing expressions ("*.txt")
  ZSH_HIGHLIGHT_STYLES[globbing]=fg=$DodgerBlue1
  # History expansion expressions ("!foo", "^foo^bar")
  ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
  # Single-hyphen options ("-o")
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=$DeepPink4,bold
  # Double-hyphen options ("--option")
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=$DeepPink4,bold
  # Backtick command substitution ("`foo`")
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
  # Single-quoted argument ('foo')
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=$Green3
  # Double-quoted argument ("foo")
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=$Green3
  # Parameter expansion inside double quotes ("$foo")
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=$CornflowerBlue
  # Backslash escape sequences inside double-quoted arguments ("\"" in "foo\"bar")
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=$Green3
  # Parameter assignments ("x=foo")
  ZSH_HIGHLIGHT_STYLES[assign]=fg=$Green3
fi
