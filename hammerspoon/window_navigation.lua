mappings = {
  { {"alt"}, "1", "Google Chrome"},
  { {"alt"}, "2", "Finder"},
  { {"alt"}, "3", "Visual Studio Code"},
  { {"alt"}, "4", "Microsoft OneNote"},
  { {"alt"}, "5", "iTerm"},
  { {"alt"}, "6", "KeePassXC"},
  { {"alt"}, "D", "Discord"},
  { {"alt"}, "V", "VLC"}
}

for _, mapping in ipairs(mappings) do
  print(string.format("Mapping %s+%s → %s", hs.inspect(mapping[1]), mapping[2], mapping[3]))
  hs.hotkey.bind(mapping[1], mapping[2], function()
    hs.application.launchOrFocus(mapping[3])
  end)
end

-- Block ⌘H. It just annoys me.
hs.hotkey.bind({"cmd"}, "H", function()
  hs.alert.show("Hammerspoon blocked ⌘H 🔥")
end)
