require("class")
require("entity")
require("player_controller")
require("enemy_controller")

Game = class()

function Game:init()
    self.entities = {}
    self.lanes = {}
    self.player_controller = PlayerController()
    self.enemy_controller = EnemyController()

    self:load_bases()
    self:load_lanes()
end

function Game:draw()
    -- Draw lanes, if on spawning mode.
    love.graphics.setColor(1, 1, 1, 0.5)

    if UI.mode == UI_MODE.SPAWNING then
        for i = 1, #GAME.lanes do
            love.graphics.draw(GAME.lanes[i].sprite.image, GAME.lanes[i].start_x, GAME.lanes[i].start_y)
        end
    end

    -- Draw bases.
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GAME.player_base.sprite.image, GAME.player_base.x, GAME.player_base.y)
    love.graphics.draw(GAME.enemy_base.sprite.image, GAME.enemy_base.x, GAME.enemy_base.y)

    -- Draw entities.
    for _, entity in pairs(GAME.entities) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(entity.sprite.image, entity.x, entity.y)

        -- Draw health bar.
        local entity_width = entity.sprite.image:getDimensions()
        local health_bar_margin_y = 5

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", entity.x, entity.y + health_bar_margin_y, entity_width, 4)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", entity.x, entity.y + health_bar_margin_y, entity_width * (entity.hp / entity.max_hp), 4)
    end
end

function Game:update()
    for _, entity in pairs(self.entities) do
        entity:update(self)
    end

    self.player_controller:update()
    self.enemy_controller:update()
end

function Game:load_bases()
    local base_hp = 100
    local base_margin_x = 10
    local base_margin_y = 175

    -- Spawn player base.
    self.player_base = Entity(self, SPRITES.player_base, base_margin_x, base_margin_y, 0, base_hp, 0, CONTROLLER_TAG.PLAYER)

    -- Spawn enemy base.
    local enemy_base_width = SPRITES.enemy_base.image:getDimensions()
    self.enemy_base = Entity(self, SPRITES.enemy_base, love.graphics.getWidth() - enemy_base_width - base_margin_x, base_margin_y, 0, base_hp, 0, CONTROLLER_TAG.ENEMY)
end

function Game:load_lanes()
    local lane_spawn_x = 225
    local lane_spawn_y = 216

    for _ = 1, 6 do
        local lane = Lane(lane_spawn_x, lane_spawn_y)
        self.lanes[#self.lanes + 1] = lane

        local button_lane = Button(SPRITES.lane_spawn, lane_spawn_x, lane_spawn_y)
        UI.button_spawn_lanes[#UI.button_spawn_lanes + 1] = button_lane

        lane_spawn_y = lane_spawn_y + 64
    end
end