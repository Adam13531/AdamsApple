-- Make the current window 1080x1080 for YouTube Shorts
hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "8", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = 0
  f.y = 0
  f.w = 1080
  f.h = 1080
  win:setFrame(f)

  hs.alert.show("Sized window to 1080x1080")
end)
