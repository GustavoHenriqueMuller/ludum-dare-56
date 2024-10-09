require("class")
require("controller")

PlayerController = Controller:extend()

function PlayerController:init()
    self:base_init(100, 4, 1)
end