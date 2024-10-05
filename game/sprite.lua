require("class")

SPRITES = {}
Sprite = class()

function Sprite:init(name)
    self.name = name
    self.image = love.graphics.newImage("assets/" .. name .. ".png")

    SPRITES[name] = self
end