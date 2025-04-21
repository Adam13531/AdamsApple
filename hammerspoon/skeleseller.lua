-- This sets up my whole stream for the Twitch front page such that we showcase
-- Skeleseller.
--
-- In short, it makes VSCode take the left half of the screen and Skeleseller
-- take the right half of the screen. It also launches Skeleseller if it isn't
-- already running.


-- Note: "first" here just means the one that was activated most recently, not
-- the application that was launched first
function find_first_code_window()
  local all_windows = hs.window.allWindows()
  for _, win in ipairs(all_windows) do
    if win:application():name() == "Code" then
      print("Found a Code window")
      return win
    end
  end

  return nil
end

function make_vscode_take_left_half()
  local first_code_window = find_first_code_window()

  if first_code_window == nil then
    hs.alert.show("No Code window found")
    return
  end

  local f = first_code_window:frame()
  f.x = 0
  f.y = 0
  f.w = 960
  f.h = 1080
  first_code_window:setFrame(f)
end

function make_skeleseller_take_right_half()
  local skeleseller_window = hs.window.find("Skeleseller for Twitch Front Page")

  if skeleseller_window == nil then
    hs.application.launchOrFocus("/Users/adam/tmp/delete_me/Skeleseller.app")
    hs.alert.show("Launched Skeleseller. Press the hotkey again to size it.")
    return
  end


  local f = skeleseller_window:frame()
  f.x = 960
  f.y = 0
  f.w = 960
  f.h = 900
  skeleseller_window:setFrame(f)
  skeleseller_window:focus()
end

hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "5", function()
  make_vscode_take_left_half()
  make_skeleseller_take_right_half()
end)
