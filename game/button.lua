require("class")

Button = class()

function Button:init(sprite, x, y, opacity)
    self.sprite = sprite
    self.x = x
    self.y = y
    self.opacity = opacity or 1

    self.pressed = false
    self.is_enabled = true
end

function Button:contains_mouse()
    local mouse_x, mouse_y = love.mouse.getPosition()
    local contains_mouse = mouse_x >= self.x and mouse_x <= self.x + self.sprite.width and
                           mouse_y >= self.y and mouse_y <= self.y + self.sprite.height

    return contains_mouse
end

function Button:set_pressed(pressed)
    self.pressed = pressed
end

function Button:draw()
    self:base_draw()
end

function Button:base_draw()
    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.draw(self.sprite.image, self.x, self.y)

    if not self.is_enabled then
        love.graphics.setColor(1, 0, 0, 0.4)
        love.graphics.draw(self.sprite.image, self.x, self.y)
    end

    if self.pressed then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.sprite.image, self.x, self.y)
    end
end

function Button:update(game)
end

function Button:on_click(game)
end