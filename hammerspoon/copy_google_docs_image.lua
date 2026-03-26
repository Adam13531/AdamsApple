-- In Google Docs, if you copy an image, you can't paste it outside of the document. Instead,
-- you have to copy it as markdown so that you get the base64 data on your clipboard, then
-- you have to convert it to an image. I used to use a site like https://base64.guru/converter/decode/image/png,
-- but I would still have to trim the copied markdown so that it just contained the base64
-- blob. I was sick of doing that and wrote this function.
local function copyBase64ImageToClipboard(input)
  if type(input) ~= "string" then
    return false, "Expected a string input"
  end

  local mimeType, base64 = input:match("data:([^;]+);base64,([^>%s]+)")
  if not mimeType or not base64 then
    return false, "Could not parse mimeType and base64 data from input"
  end

  local dataUrl = ("data:%s;base64,%s"):format(mimeType, base64)
  local img = hs.image.imageFromURL(dataUrl)

  if not img then
    return false, "Failed to create image from base64 data URL"
  end

  local ok = hs.pasteboard.writeObjects(img)
  if not ok then
    return false, "Failed to write image to clipboard"
  end

  return true
end

local function copyImage()
  copyBase64ImageToClipboard(hs.pasteboard.getContents())
  hs.alert.show(string.format("Copied image to clipboard"))
end

local function sendReturn()
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.25, copyImage)
end    

local function sendText()
    hs.eventtap.keyStrokes("copy markdown")
    
    hs.timer.doAfter(0.25, sendReturn)
end

hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "C", function()
    hs.eventtap.keyStroke({"alt"}, "/")
    hs.timer.doAfter(0.25, sendText)
end)
