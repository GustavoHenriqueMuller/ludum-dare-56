require("class")
require("entity")

Controller = class()
Controller.MAX_GOLD_MULTIPLIER = 2

function Controller:init(gold, gold_per_tick)
    self:base_init(gold, gold_per_tick)
end

function Controller:base_init(gold, gold_per_tick)
    self.gold = gold
    self.gold_timer = 0
    self.gold_multiplier = 1
    self.gold_per_tick = gold_per_tick or 1
end

function Controller:update(game)
    self:update_gold()
end

function Controller:update_gold()
    local miliseconds_since_last_frame = love.timer.getAverageDelta() * 1000

    self.gold_timer = self.gold_timer + miliseconds_since_last_frame
    self.gold_multiplier = math.min(Controller.MAX_GOLD_MULTIPLIER, self.gold_multiplier + miliseconds_since_last_frame / 600000)

    if self.gold_timer > 1000 then
        self.gold = self.gold + math.floor(self.gold_per_tick * self.gold_multiplier)
        self.gold_timer = self.gold_timer - 1000
    end
end

function Controller:can_buy_entity(entity_class)
    return self.gold >= entity_class.database.cost
end

function Controller:buy_entity(game, entity_class, lane_index, controller_tag)
    if self:can_buy_entity(entity_class) then
        self.gold = self.gold - entity_class.database.cost

        local is_player = controller_tag == CONTROLLER_TAG.PLAYER

        local x = (is_player and GAME.lanes[lane_index].start_player_x) or GAME.lanes[lane_index].start_enemy_x;
        local y = (is_player and GAME.lanes[lane_index].start_player_y) or GAME.lanes[lane_index].start_enemy_y;

        local new_entity = entity_class(
            x,
            y,
            lane_index,
            controller_tag
        )

        -- Acount for sprites that are taller than normal (frog).
        local extra_sprite_height = math.max(0, new_entity.sprite.height - SPRITES.lane_spawn.height)
        new_entity.y = new_entity.y - extra_sprite_height

        game:add_entity(new_entity)
    end
end
