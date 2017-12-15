# Awesome WM screen rotation
This is a module for awesome wm which enables the user to rotate the screen. It saves the rotation per tag which means that the screen will reorient when switching tags.

## Download
```sh
git clone https://github.com/raksooo/screenrotation.git ~/.config/awesome/screenrotation
```

## Usage
Import:
```lua
local rotation = require('screenrotation')
```

Set globalkeys:
```lua
globalkeys = gears.table.join(
  ...

  awful.key({ super }, "Up", function() rotation.rotate("normal") end,
    {description = "Normal tag rotation", group = "tag"}),
  awful.key({ super }, "Down", function() rotation.rotate("inverted") end,
    {description = "Inverted tag rotation", group = "tag"}),
  awful.key({ super }, "Left", function() rotation.rotate("left") end,
    {description = "Counter-clockwise tag rotation", group = "tag"}),
  awful.key({ super }, "Right", function() rotation.rotate("right") end,
    {description = "Clockwise tag rotation", group = "tag"})
)
```

### Specify display
If this script does not find a display or if it chooses the wrong one it can be changed using `rotation.display` property.
```lua
rotation.display = "HDMI-2"
```

### Specify devices
If this script does not find your input devices or chooses the wrong ones the table `rotation.devices` can be modified to include the correct ones.
```lua
table.insert(rotation.devices, "ELAN Touchscreen")
```

## Dependencies
* Awesome wm
* xrandr

