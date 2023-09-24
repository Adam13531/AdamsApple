local lastClickTime=0
local focusedWin=hs.window.focusedWindow()
local titleBarLineHeight=5
local windowFilter

local canvas = hs.canvas.new{x=0,y=0,h=500,w=500}:appendElements({
-- Title-bar highlight
    action = "fill",
    fillColor = { alpha = 0.0, blue = 0.6, green = 0.1 },
    frame = { h = 250.0, w = 250.0, x = 0.0, y = 0.0 },
    roundedRectRadii = { xRadius = 10, yRadius = 10 },
    type = "rectangle",
  },
  {
-- Line that remains at the top of the title bar
    action = "fill",
    fillColor = { alpha = 0.5, blue = 0.6, green = 0.1 },
    frame = { h = 0.0, w = 0.0, x = 0.0, y = 0.0 },
    roundedRectRadii = { xRadius = titleBarLineHeight, yRadius = titleBarLineHeight },
    type = "rectangle",
  }
 ):show()

-- Functions to get the specific canvas elements by their indices so
-- that we can update them without having to put "canvas[1]" everywhere.
function getTitleBar()
  return canvas[1]
end
function getLine()
  return canvas[2]
end

detectMouseDown = hs.eventtap.new({
  hs.eventtap.event.types.leftMouseDown
}, function(e)
  local button = e:getProperty(
      hs.eventtap.event.properties['mouseEventButtonNumber']
  )
  if button == 0 then lastClickTime = os.clock() end
end)

-- Relocates the canvas elements. This is safe to call repeatedly.
function relocateCanvasElements()
  -- Size the canvas so that it takes up the entirety of focused window.
  local frame = focusedWin:frame()
  canvas:frame(frame)

  -- These frames are relative to the canvas, which we just moved.
  getTitleBar().frame = {
    x = 0,
    y = 0,
    w = frame.w,
    h = 42
  }
  getLine().frame = {
    x = titleBarLineHeight,
    y = 0,
    w = frame.w - titleBarLineHeight * 2,
    h = 6
  }
  canvas:show()
end

function flashTitleBar()
  -- When the focus was changed due to clicking, don't redraw since it's
  -- obvious what was just clicked.
  elapsedTimeSinceLastClick = os.clock() - lastClickTime
  if elapsedTimeSinceLastClick < 0.05 then
    -- At least show the line in the right location
    getTitleBar().fillColor.alpha = 0.0
    relocateCanvasElements()
    return
  end

  local startAlpha

  -- When an application only has a single window open, then it doesn't
  -- need to be as obvious that it has the focus. Maybe this is a dumb
  -- feature though. 🤔
  if #hs.application.frontmostApplication():visibleWindows() == 1 then
    startAlpha = 0.25
  else
    startAlpha = 0.5
  end

  canvas:show()
  relocateCanvasElements()
  getTitleBar().fillColor.alpha = startAlpha
  getLine().fillColor.alpha = 0.5
  animTimer:start()
end

function updateAnimation()
  if getTitleBar().fillColor.alpha > 0.03 then
    getTitleBar().fillColor.alpha = getTitleBar().fillColor.alpha * 0.97
  else
    getTitleBar().fillColor.alpha = 0.0
    animTimer:stop()
  end
end

-- Use this instead of hs.window.focusedWindow() everywhere so that we
-- don't get "fake" windows (like the "Find" window in Chrome; see
-- internal comment).
function getFocusedWindow()
  local f=hs.window.focusedWindow()
  if f == nil then return nil end

  -- In the case that a user clicks a "Find" window in Chrome, we want
  -- to make sure that we don't consider it to be the focused window for
  -- the sake of highlighting. We can't just focus a different window
  -- because then the keyboard input would be redirected away from the
  -- "Find" window.
  if f:application():name() == "Google Chrome" and f:size().h < 100 and #hs.application.frontmostApplication():visibleWindows() > 1 then
    return hs.application.frontmostApplication():visibleWindows()[2]
  end

  return f
end

-- Every once in a while, an event like windowMoved won't fire, so the
-- canvas will be in the wrong position. This function fixes that.
function fixStaleness()
  focusedWin = getFocusedWindow()

  relocateCanvasElements()
end

animTimer = hs.timer.doEvery(0.05, updateAnimation)
animTimer:stop()

function winFocused(w)
  local newFocusedWindow=getFocusedWindow()

  -- Chrome considers the ⌘F window to be a different window (although
  -- annoyingly, it has the same "Find in page" title as the parent
  -- window, so we can't use an hs.window.filter to differentiate by
  -- title), so just switching between several open tabs in the same
  -- window can trigger the windowFocused event if one tab has a "Find"
  -- window open. To work around this, we make sure that the new window
  -- has a different ID.
  if focusedWin:id() == newFocusedWindow:id() then return end
  focusedWin=newFocusedWindow

  flashTitleBar()
end
function winMoved(w)
  relocateCanvasElements()
end

-- There's a known issue where windowFocused just stops working:
-- https://github.com/Hammerspoon/hammerspoon/issues/3038
-- From what I've seen, this happens exactly 5 seconds into running
-- Hammerspoon, and it's fixed by just switching between applications
-- once or twice.
--
-- Also, from what I can tell, there's ALWAYS a focused window even if
-- if you ⌘Q the focused application entirely, so I don't subscribe to
-- windowUnfocused or windowNotVisible.
local subscriptions={
  [hs.window.filter.windowVisible]=winFocused,
  [hs.window.filter.windowFocused]=winFocused,
  [hs.window.filter.windowMoved]=winMoved,
}

windowFilter = hs.window.filter.new(nil, "my-log")
windowFilter:subscribe(subscriptions)

-- Sometimes the window events don't trigger, so this is here just to
-- catch any issues where the canvas is in a stale location.  
fixStalenessTimer = hs.timer.doEvery(3, fixStaleness)
fixStalenessTimer:start()

detectMouseDown:start()
