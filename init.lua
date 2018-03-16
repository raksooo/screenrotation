local awful = require("awful")
local gears = require("gears")

local display = next(screen.primary.outputs)
local devices = nil
local previousRotation = nil

local rotationMatrices = {
  normal = "1 0 0 0 1 0 0 0 1",
  inverted = "-1 0 1 0 -1 1 0 0 1",
  left = "0 -1 1 1 0 0 0 0 1",
  right = "0 1 0 -1 0 1 0 0 1",
}

local function rotateInput(rotationString)
  for v in devices do
    local cmd = "xinput set-prop '" .. v
      .. "' 'Coordinate Transformation Matrix' "
      .. rotationMatrices[rotationString]
    awful.spawn(cmd, false)
  end
end

local function rotate(rotationString)
  awful.screen.focused().selected_tag.rotation = rotationString

  awful.spawn({ "xrandr", "--output", display, "--rotate", rotationString }, false)
  rotateInput(rotationString)
end

awful.spawn.easy_async("xinput --list --name-only", function(stdout)
  local rows = gears.string.split(stdout, "\n")
  devices = gears.table.iterate(rows, function(device)
    return device:find("Touchpad") or device:find("Touchscreen")
  end)
end)

tag.connect_signal("property::selected", function(t) 
  local r = t.rotation or "normal"
  if not t.selected then
    previousRotation = r
  elseif previousRotation ~= nil and r ~= previousRotation then
    rotate(r)
  end
end)

return rotate

