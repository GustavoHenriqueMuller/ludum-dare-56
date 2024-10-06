require("class")
require("controller")
require("entities.Scorpion")

EnemyController = Controller:extend()

function EnemyController:init()
    -- self:base_init(1.5) @TODO
    self:base_init(50)
end

function EnemyController:update(game)
    self:update_gold()

    local lane_index = math.random(1, #game.lanes)
    self:buy_entity(game, Scorpion, lane_index, CONTROLLER_TAG.ENEMY)
end