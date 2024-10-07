require("class")
require("controller")
require("entities.Scorpion")

EnemyController = Controller:extend()

function EnemyController:init()
    self:base_init(15, 6, 1.15)
end

function EnemyController:update(game)
    self:update_gold()

    local roll = math.random(1, 3)

    if roll >= 2 then
        -- Spawn random entity in random lane. Else, save gold.
        local lane_index = math.random(1, #game.lanes)

        local roll_2 = math.random(1, 3)

        if roll_2 > 2 then
            -- Spawn biggest creature money can buy.
            for i = #UI_BUTTON_ENTITIES, 1, -1 do
                local entity_class = UI_BUTTON_ENTITIES[i]

                if self:can_buy_entity(entity_class) then
                    self:buy_entity(game, entity_class, lane_index, CONTROLLER_TAG.ENEMY)
                end
            end
        else
            if self:can_buy_entity(Ant) then
                self:buy_entity(game, Ant, lane_index, CONTROLLER_TAG.ENEMY)
            end
        end
    end
end