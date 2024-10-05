require("class")

Button = class()

function Button:init(sprite, x, y)
    self.sprite = sprite
    self.pressed = false
    self.x = x
    self.y = y
end

function Button:contains_mouse()
    local mouse_x, mouse_y = love.mouse.getPosition()
    local sprite_width, sprite_height = self.sprite.image:getDimensions()

    local contains_mouse = mouse_x >= self.x and mouse_x <= self.x + sprite_width and mouse_y >= self.y and mouse_y <= self.y + sprite_height

    return contains_mouse
end

function Button:set_pressed(pressed)
    self.pressed = pressed
end

function Button:draw()
    love.graphics.draw(self.sprite.image, self.x, self.y)

    if self.pressed == true then
        love.graphics.setColor(0, 0, 0, 0.5)

        local sprite_width, sprite_height = self.sprite.image:getDimensions()
        love.graphics.rectangle("fill", self.x, self.y, sprite_width, sprite_height)
    end
end
