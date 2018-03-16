local awful = require("awful")
local gears = require("gears")

local display = nil
local devices = { }
local previousRotation = nil

local rotationMatrices = {
  normal = "1 0 0 0 1 0 0 0 1",
  inverted = "-1 0 1 0 -1 1 0 0 1",
  left = "0 -1 1 1 0 0 0 0 1",
  right = "0 1 0 -1 0 1 0 0 1",
}

local function getDevices()
  display = next(screen.primary.outputs)

  awful.spawn.easy_async({ "xinput", "--list", "--name-only" }, function(stdout, stderr)
    local rows = gears.string.split(stdout, "\n")
    for _, device in pairs(rows) do
      if device:find("Touchpad") or device:find("Touchscreen") then
        table.insert(devices, device)
      end
    end
  end)
end

local function rotateDisplay(rotationString)
  awful.spawn({
    "xrandr",
    "--output",
    display,
    "--rotate",
    rotationString
  }, false)
end

local function rotateInput(rotationString)
  for _, v in pairs(devices) do
    local cmd = "xinput set-prop '" .. v
      .. "' 'Coordinate Transformation Matrix' "
      .. rotationMatrices[rotationString]
    awful.spawn(cmd, false)
  end
end

local function rotate(rotationString)
  awful.screen.focused().selected_tag.rotation = rotationString
  rotateDisplay(rotationString)
  rotateInput(rotationString)
end

tag.connect_signal("property::selected", function(t) 
  local r = t.rotation or "normal"
  if not t.selected then
    previousRotation = r
  elseif r ~= previousRotation then
    rotate(r)
  end
end)

getDevices()
return rotate

