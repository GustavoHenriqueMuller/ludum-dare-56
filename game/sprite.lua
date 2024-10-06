require("class")

SPRITES = {}
Sprite = class()

function Sprite:init(name)
    self.name = name
    self.image = love.graphics.newImage("assets/" .. name .. ".png")
    self.width, self.height = self.image:getDimensions()

    SPRITES[name] = self
end