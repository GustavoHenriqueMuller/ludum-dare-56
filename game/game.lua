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
    -- Draw background.
    local background_sprite = SPRITES["background"]
    local _, background_height = background_sprite.image:getDimensions()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background_sprite.image, 0, love.graphics:getHeight() - background_height)

    -- Draw bases.
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(GAME.player_base.sprite.image, GAME.player_base.x, GAME.player_base.y)
    love.graphics.draw(GAME.enemy_base.sprite.image, GAME.enemy_base.x, GAME.enemy_base.y)

    -- Draw entities/shadows.
    for _, entity in pairs(GAME.entities) do
        love.graphics.setColor(1, 1, 1)

        -- Draw shadow.
        if entity.lane_index ~= -1 then
            love.graphics.draw(SPRITES["shadow"].image, entity.x, entity.y)
        end

        -- Draw entity.
        love.graphics.draw(entity.sprite.image, entity.x, entity.y)
    end

    -- Draw health bars/texts.
    for _, entity in pairs(GAME.entities) do
        -- Draw health bar.
        local entity_width = entity.sprite.image:getDimensions()
        local health_bar_margin_y = 5

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", entity.x, entity.y + health_bar_margin_y, entity_width, 4)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", entity.x, entity.y + health_bar_margin_y, entity_width * (entity.hp / entity.max_hp), 4)

        -- Draw health text.
        local health_text = entity.hp .. "/" .. entity.max_hp
        local health_text_width = FONT:getWidth(health_text)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(health_text, entity.x + entity_width / 2 - health_text_width / 2, entity.y - 15)
    end
end

function Game:update()
    for _, entity in pairs(self.entities) do
        entity:update(self)
    end

    self.player_controller:update()
    self.enemy_controller:update(self)
end

function Game:load_bases()
    local base_hp = 100
    local base_margin_x = 10
    local base_margin_y = 175

    -- Spawn player base.
    self.player_base = self:add_entity(Entity(
        SPRITES.player_base,
        base_margin_x,
        base_margin_y,
        0,
        base_hp,
        0,
        -1,
        CONTROLLER_TAG.PLAYER
    ))

    -- Spawn enemy base.
    local enemy_base_width = SPRITES.enemy_base.image:getDimensions()

    self.enemy_base = self:add_entity(Entity(
        SPRITES.enemy_base,
        love.graphics.getWidth() - enemy_base_width - base_margin_x,
        base_margin_y,
        0,
        base_hp,
        0,
        -1,
        CONTROLLER_TAG.ENEMY
    ))
end

function Game:add_entity(entity)
    self.entities[entity.id] = entity

    if entity.lane_index ~= -1 then
        local lane = self.lanes[entity.lane_index]
        lane.entities_ids[entity.id] = true
    end

    return entity
end

function Game:remove_entity(entity_id)
    local lane_index = self.entities[entity_id].lane_index

    if lane_index ~= -1 then
        self.lanes[lane_index].entities_ids[entity_id] = nil
    end

    self.entities[entity_id] = nil
end

function Game:load_lanes()
    local lane_spawn_x = 225
    local lane_spawn_y = 240

    for _ = 1, 5 do
        local lane = Lane(lane_spawn_x, lane_spawn_y, love.graphics.getWidth() - lane_spawn_x - 64, lane_spawn_y)
        self.lanes[#self.lanes + 1] = lane

        lane_spawn_y = lane_spawn_y + 72
    end
end