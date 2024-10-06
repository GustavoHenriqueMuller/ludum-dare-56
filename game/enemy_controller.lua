require("class")
require("controller")
require("entities.ant")

EnemyController = Controller:extend()

function EnemyController:init()
    self:base_init(1.5)
end

function EnemyController:update(game)
    self:update_gold()

    local lane_index = math.random(1, #GAME.lanes)
    self:buy_entity(game, Ant, lane_index, CONTROLLER_TAG.ENEMY)
end