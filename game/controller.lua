require("class")
require("entity")

Controller = class()

function Controller:init(gold_per_tick)
    self:initialize(gold_per_tick)
end

function Controller:initialize(gold_per_tick)
    self.gold = 0
    self.gold_timer = 0
    self.gold_per_tick = gold_per_tick or 1
end

function Controller:update(game)
    self:update_gold()
end

function Controller:update_gold()
    self.gold_timer = self.gold_timer + love.timer.getAverageDelta()

    if self.gold_timer > 0.2 then
        self.gold = self.gold + self.gold_per_tick
        self.gold_timer = self.gold_timer - 1
    end
end

function Controller:can_buy_entity(entity_class)
    return self.gold >= entity_class.database.cost
end

function Controller:buy_entity(game, entity_class, lane_index, controller_tag)
    if self:can_buy_entity(entity_class) then
        self.gold = self.gold - entity_class.database.cost

        local is_player = controller_tag == CONTROLLER_TAG.PLAYER

        local x = is_player and GAME.lanes[lane_index].start_player_x or GAME.lanes[lane_index].start_enemy_x;
        local y = is_player and GAME.lanes[lane_index].start_player_y or GAME.lanes[lane_index].start_enemy_y;

        game:add_entity(entity_class(
            x,
            y,
            lane_index,
            controller_tag
        ))
    end
end
