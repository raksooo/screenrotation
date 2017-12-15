local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local rotation = {
  inited = false,
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

function rotation.setKeys()
  globalkeys = gears.table.join(globalkeys,
    awful.key({ super }, "Up", function() rotation.rotate("normal") end,
      {description = "Normal tag rotation", group = "tag"}),
    awful.key({ super }, "Down", function() rotation.rotate("inverted") end,
      {description = "Inverted tag rotation", group = "tag"}),
    awful.key({ super }, "Left", function() rotation.rotate("left") end,
      {description = "Counter-clockwise tag rotation", group = "tag"}),
    awful.key({ super }, "Right", function() rotation.rotate("right") end,
      {description = "Clockwise tag rotation", group = "tag"})
  )
end

function rotation.getDevices()
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

function rotation.rotate(rotationString)
  if not rotation.inited then init() end

  awful.screen.focused().selected_tag.rotation = rotationString
  awful.spawn("rotate_desktop " .. rotationString)
end

function splitString(str, sep)
  fields = { }
  str:gsub("([^" .. sep .. "]*)" .. sep, function(c)
     table.insert(fields, c)
  end)
  return fields
end

rotation.getDevices()
return rotation

