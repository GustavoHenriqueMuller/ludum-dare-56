require("class")

EnemyController = class()

function EnemyController:init()
    self.gold = 5
    self.gold_timer = 0
end

function EnemyController:update(game)
    local new_timer = self.gold_timer + love.timer.getAverageDelta()

    if new_timer > 1 then
        -- self.gold = self.gold + 5
        self.gold_timer = new_timer - 1
    else
        self.gold_timer = new_timer
    end

    local lane_index = math.random(1, 6)

    if self.gold >= ENTITY_COSTS[1] then
        self.gold = self.gold - ENTITY_COSTS[1]

        GAME:add_entity(Entity(
            SPRITES.ant_enemy,
            game.lanes[lane_index].start_enemy_x,
            game.lanes[lane_index].start_enemy_y,
            20,
            3,
            1,
            lane_index,
            CONTROLLER_TAG.ENEMY
        ))
    end
end