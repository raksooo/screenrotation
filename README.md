# Awesome WM screen rotation
This is a module for awesome wm which enables the user to rotate the screen. It saves the rotation per tag which means that the screen will reorient when switching tags.

## Download
```sh
git clone https://github.com/raksooo/screenrotation.git ~/.config/awesome/screenrotation
```

## Usage
Import:
```lua
local rotate = require('screenrotation')
```

Set globalkeys:
```lua
globalkeys = gears.table.join(
  ...

  awful.key({ super }, "Up", function() rotate("normal") end,
    {description = "Normal tag rotation", group = "tag"}),
  awful.key({ super }, "Down", function() rotate("inverted") end,
    {description = "Inverted tag rotation", group = "tag"}),
  awful.key({ super }, "Left", function() rotate("left") end,
    {description = "Counter-clockwise tag rotation", group = "tag"}),
  awful.key({ super }, "Right", function() rotate("right") end,
    {description = "Clockwise tag rotation", group = "tag"})
)
```

## Dependencies
* Awesome wm
* xrandr
* xinput

