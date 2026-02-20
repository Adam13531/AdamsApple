-- Make the current window 1080x1080 for YouTube Shorts
hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "8", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = 0
  f.y = 0
  f.w = 1080
  f.h = 2160
  win:setFrame(f)

  hs.alert.show(string.format("Sized window to %dx%d", f.w, f.h))
end)
