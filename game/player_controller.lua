require("class")
require("controller")

PlayerController = Controller:extend()

function PlayerController:init()
    self:initialize(5)
end