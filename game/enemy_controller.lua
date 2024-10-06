require("class")
require("controller")
require("entities.ant")
require("entities.fire_ant")

EnemyController = Controller:extend()

function EnemyController:init()
    self:initialize()
end

function EnemyController:update(game)
    self:update_gold()

    local lane_index = math.random(1, #GAME.lanes)
    self:buy_entity(game, FireAnt, lane_index, CONTROLLER_TAG.ENEMY)
end