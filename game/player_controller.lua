require("class")
require("controller")

PlayerController = Controller:extend()

function PlayerController:init()
    self:base_init(10)
end