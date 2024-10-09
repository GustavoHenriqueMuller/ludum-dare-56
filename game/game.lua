require("class")
require("entity")
require("player_controller")
require("enemy_controller")
require("utils")
require("source")

GAME_STATE = {PLAYING = "Playing", VICTORY = "Victory", DEFEAT = "Defeat", DRAW = "DRAW"}
Game = class()
Game.state=  GAME_STATE.PLAYING

function Game:init()
    self.entities = {}
    self.projectiles = {}
    self.lanes = {}
    self.player_controller = PlayerController()
    self.enemy_controller = EnemyController()
    self.timer = 0

    self:load_bases()
    self:load_lanes()
end

function Game:draw()
    -- Draw background.
    local background_sprite = SPRITES["background"]

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background_sprite.image, 0, love.graphics:getHeight() - background_sprite.height)

    -- Draw entities/shadows.
    love.graphics.setColor(1, 1, 1)

    for i = 1, #self.lanes do
        local lane = self.lanes[i]

        -- Draw each entity.
        for entity_id in pairs(lane.entities_ids) do
            local entity = self.entities[entity_id]

            -- Draw shadow.
            if entity.lane_index ~= -1 then
                love.graphics.draw(
                    SPRITES.shadow.image,
                    entity.x + entity.sprite.width / 2 - SPRITES.shadow.width / 2,
                    entity.y + entity.sprite.height * 0.8 - SPRITES.shadow.height / 2
                )
            end

            -- Draw entity.
            if entity.tag == CONTROLLER_TAG.PLAYER then
                love.graphics.draw(entity.sprite.image, entity.x, entity.y)
            else
                love.graphics.draw(entity.sprite.image, entity.x, entity.y, 0, -1, 1, entity.sprite.width)
            end
        end
    end

    -- Draw bases.
    love.graphics.draw(self.player_base.sprite.image, self.player_base.x, self.player_base.y)
    love.graphics.draw(self.enemy_base.sprite.image, self.enemy_base.x, self.enemy_base.y, 0, -1, 1, self.enemy_base.sprite.width)

    -- Draw projectiles.
    for _, projectile in pairs(self.projectiles) do
        projectile:draw()
    end

    -- Draw health bars/texts.
    for _, entity in pairs(self.entities) do
        -- Draw health bar.
        local health_bar_margin_y = 5

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", entity.x, entity.y + health_bar_margin_y, entity.sprite.width, 4)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle(
            "fill",
            entity.x,
            entity.y + health_bar_margin_y,
            entity.sprite.width * (entity.hp / entity.max_hp),
            4
        )

        -- Draw health text.
        local health_text = entity.hp .. "/" .. entity.max_hp
        local health_text_width = SMALL_FONT:getWidth(health_text)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(SMALL_FONT)
        love.graphics.print(health_text, entity.x + entity.sprite.width / 2 - health_text_width / 2, entity.y - 10)
        love.graphics.setFont(FONT)
    end
end

function Game:update()
    self:update_game_state()

    if self.state == GAME_STATE.PLAYING then
        -- Update timer.
        self.timer = love.timer.getTime()

        -- Play background music.
        SOURCES.background_music:play()

        local dt = love.timer.getAverageDelta()

        -- Update entities (movement and collision information).
        for _, entity in pairs(self.entities) do
            entity:update(self)
        end

        -- Update projectiles.
        for _, projectile in pairs(self.projectiles) do
            projectile:update(self)
        end

        -- Check and do attacks.
        for _, entity in pairs(self.entities) do
            entity:combat(self, dt)
        end

        self:remove_dead_entities()

        self.player_controller:update()
        self.enemy_controller:update(self)
    end
end

function Game:update_game_state()
    if self.player_base.hp == 0 and self.enemy_base.hp == 0 then
        self.state = GAME_STATE.DRAW
    elseif self.player_base.hp == 0 then
        self.state = GAME_STATE.DEFEAT
    elseif self.enemy_base.hp == 0 then
        self.state = GAME_STATE.VICTORY
    else
        self.state = GAME_STATE.PLAYING
    end
end

function Game:remove_dead_entities()
    local entities_ids_to_remove = {}

    for i = 1, #self.lanes do
        local lane = self.lanes[i]

        for entity_id in pairs(lane.entities_ids) do
            local entity = self.entities[entity_id]

            if entity.hp == 0 then
                -- Adds gold if the entity destroyed was an enemy.
                if entity.tag == CONTROLLER_TAG.ENEMY then
                    self.player_controller.gold = self.player_controller.gold + entity.cost
                else
                    self.enemy_controller.gold = self.enemy_controller.gold + entity.cost
                end

                entities_ids_to_remove[#entities_ids_to_remove + 1] = entity_id
            end
        end
    end

    for i = 1, #entities_ids_to_remove do
        self:remove_entity(entities_ids_to_remove[i])
    end
end

function Game:load_bases()
    local base_hp = 2000
    local base_margin_x = 10
    local base_margin_y = 175

    -- Spawn player base.
    self.player_base = self:add_entity(Entity(
        SPRITES.base,
        nil,

        0,
        base_hp,
        0,
        0,
        nil,
        0,
        0,

        base_margin_x,
        base_margin_y,
        -1,
        CONTROLLER_TAG.PLAYER
    ))

    -- Spawn enemy base.
    self.enemy_base = self:add_entity(Entity(
        SPRITES.base,
        nil,

        0,
        base_hp,
        0,
        0,
        nil,
        0,
        0,

        love.graphics.getWidth() - SPRITES.base.width - base_margin_x,
        base_margin_y,
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

    -- Play death sound.
    SOURCES.die:play()
end

function Game:add_projectile(projectile)
    self.projectiles[projectile.id] = projectile
end

function Game:remove_projectile(projectile_id)
    self.projectiles[projectile_id] = nil
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