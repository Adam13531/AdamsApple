-- This script allows for quick navigation between applications. It
-- remembers which window was last focused so that you can switch
-- quickly back to that specific window.

local lastFocusedWindowByApp = {}

-- To determine the bundle IDs, run "codesign -dr - /Applications/FOO.app" or
-- osascript -e 'id of app "Finder"'
local mappings = {
  { {"alt"}, "1", "com.google.Chrome"},
  { {"alt"}, "2", "com.apple.finder"},
  { {"alt"}, "3", "com.microsoft.VSCode"},
  { {"alt"}, "4", "md.obsidian"},
  { {"alt"}, "5", "com.googlecode.iterm2"},
  { {"alt"}, "6", "org.keepassxc.keepassxc"},
  { {"alt"}, "D", "com.hnc.Discord"},
  { {"alt"}, "O", "com.obsproject.obs-studio"}
}

for _, mapping in ipairs(mappings) do
  local mods=mapping[1]
  local key=mapping[2]
  local bundleId=mapping[3]

  print(string.format("Mapping %s+%s → %s", hs.inspect(mods), key, bundleId))

  hs.hotkey.bind(mods, key, function()
    activateApp(bundleId)
  end)
end

function activateApp(bundleId)
  -- (this only finds RUNNING applications)
  -- The second param is to only search for exact matches:
  -- https://www.hammerspoon.org/docs/hs.application.html#find
  local app = hs.application.find(bundleId, true)

  -- If the app isn't running, launch it.
  if app == nil then
    hs.application.launchOrFocusByBundleID(bundleId)
    return
  end

  -- If the app was already running but we weren't tracking a window,
  -- then focus the first window.
  lastFocusedWindow = lastFocusedWindowByApp[app:bundleID()]
  if lastFocusedWindow == nil then
    hs.application.launchOrFocusByBundleID(bundleId)
    return
  end

  -- Try to focus the last-focused window again. Due to race conditions,
  -- this can fail, so we retry in those situations.
  for i = 1,3,1
  do
    if i == 1 or app:focusedWindow():title() ~= lastFocusedWindow:title() then
      lastFocusedWindow:focus()
      lastFocusedWindow:raise()
    else
      return
    end
  end
end

-- Block ⌘H. It just annoys me.
hs.hotkey.bind({"cmd"}, "H", function()
  hs.alert.show("Hammerspoon blocked ⌘H 🔥")
end)

-- Note: you need to escape forward slashes for AppleScript, not Lua, so
-- "example.com/foo" becomes "example.com\\/foo".
--
-- Taken from https://stackoverflow.com/a/76454818/3595355
function goToChromeTabByUrl(url)
  local script = ([[(function() {
  var browser = Application('%s');
  browser.activate();

  for (win of browser.windows()) {
  var tabIndex =
    win.tabs().findIndex(tab => tab.url().match(/%s/));

  if (tabIndex != -1) {
    win.activeTabIndex = (tabIndex + 1);
    win.index = 1;
  }
  }
  })();
  ]]):format("Google Chrome", url)
  hs.osascript.javascript(script)
end

-- ⌥C - go to the tab in Chrome that has Twitch chat
hs.hotkey.bind({"alt"}, "C", function()
    goToChromeTabByUrl("twitch.tv\\/popout\\/adamlearnslive\\/")
end)

function winFocused(w)
  if w == nil then return end

  local bundleID=w:application():bundleID()

  lastFocusedWindowByApp[bundleID] = w
end

-- There's a known issue where windowFocused just stops working:
-- https://github.com/Hammerspoon/hammerspoon/issues/3038
-- From what I've seen, this happens exactly 5 seconds into running
-- Hammerspoon, and it's fixed by just switching between applications
-- once or twice.
local subscriptions={
  [hs.window.filter.windowFocused]=winFocused
}

windowFilter = hs.window.filter.new(nil, "my-log")
windowFilter:subscribe(subscriptions)
