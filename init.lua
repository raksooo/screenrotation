local awful = require("awful")
local gears = require("gears")

local rotation = {
  inited = false,
  display = nil,
  devices = { }
}

function init(disableKeys)
  rotation.inited = true
  for _, tag in pairs(root.tags()) do
    tag:connect_signal("property::selected", function()
      local r = tag.rotation or "normal"
      if not tag.selected then
        rotation.previousRotation = r
      elseif r ~= rotation.previousRotation then
        rotation.rotate(r)
      end
    end)
  end
end

function getDevices()
  getScreen()

  local cmd = "cat /proc/bus/input/devices | grep -i name"
  awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr)
    local rows = splitString(stdout, "\n")
    for _, v in pairs(rows) do
      local device = v:match([[N:%s+Name="([^"]+)]])
      if device:find("Touchpad") or device:find("Touchscreen") then
        table.insert(rotation.devices, device)
      end
    end
  end)
end

function getScreen()
  local cmd = "xrandr --current | grep primary | awk '{print $1}'"
  awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr)
    if #stderr > 0 then
      naughty.notify({
        title = "Screenrotator",
        text = "xrandr: command not found"
      })
    else
      rotation.display = stdout
    end
  end)
end

function rotation.rotate(rotationString)
  if not rotation.inited then init() end

  awful.screen.focused().selected_tag.rotation = rotationString
  awful.spawn("xrandr --output " .. rotation.display
              .. " --rotate " .. rotationString)
  rotateInput(rotationString)
end

function rotateInput(rotationString)
  local rotationMatrices = {
    normal = "1 0 0 0 1 0 0 0 1",
    inverted = "-1 0 1 0 -1 1 0 0 1",
    left = "0 -1 1 1 0 0 0 0 1",
    right = "0 1 0 -1 0 1 0 0 1",
  }
  for _, v in pairs(rotation.devices) do
    local cmd = "xinput set-prop \"" .. v
      .. "\" \"Coordinate Transformation Matrix\" "
      .. rotationMatrices[rotationString]
    awful.spawn(cmd)
  end
end

function splitString(str, sep)
  fields = { }
  str:gsub("([^" .. sep .. "]*)" .. sep, function(c)
     table.insert(fields, c)
  end)
  return fields
end

getDevices()
return rotation

