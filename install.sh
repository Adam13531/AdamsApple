#!/bin/zsh

function updateSymlink() {
  local source=$1
  local target=$2

  if [[ -L "$target" ]]
  then
      rm $target
  fi

  if [[ -f "$target" ]]
  then
      echo "$target exists. Back it up first, then delete it"
      exit 1
  fi

  ln -s $source $target
}

function ensureFolderExists() {
  local target=$1
  if [[ ! -d "$target" ]]
  then
      mkdir "$target"
  fi

  if [[ -L "$target" || -f "$target" ]]
  then
      echo "$target exists as a file or symlink but needs to be a directory. Back it up first, then delete it"
      exit 1
  fi
}

ensureFolderExists ~/.zsh
updateSymlink ${0:a:h}/shell/zsh/.zshrc ~/.zshrc
updateSymlink ${0:a:h}/shell/zsh/plugins_after.zsh ~/.zsh/plugins_after.zsh

updateSymlink ${0:a:h}/espanso "/Users/adam/Library/Application Support/espanso"

updateSymlink ${0:a:h}/preferences/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
