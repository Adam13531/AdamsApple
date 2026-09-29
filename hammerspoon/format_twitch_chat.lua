-- I want to see timestamps in Twitch chat, but when I copy messages from Twitch
-- chat, I don't want the timestamps to show in my clipboard. I couldn't figure
-- out how to write a "filter" for ⌘C, so I instead wrote this method which
-- processes the contents of the clipboard. I also couldn't figure out how to
-- get it to automatically paste, so you still have to manually paste.
--
-- (it's probably a good thing that it's not automatically pasting in case I
-- have something sensitive on my clipboard)
hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "V", function()
  local pasteboard = hs.pasteboard.getContents()
  local messages = {}
  for line in string.gmatch(pasteboard, "[^\r\n]+") do
    local actualMessage = string.match(line, "^%d+:%d%d(.*)")
    if actualMessage == nil then
      table.insert(messages, line)
    else
      table.insert(messages, actualMessage)
    end
  end

  hs.pasteboard.setContents(table.concat(messages, "\n"))

  hs.alert.show("Formatted Twitch chat. Don't forget to press ⌘V!")
end)
