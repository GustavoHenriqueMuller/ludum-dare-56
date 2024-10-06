require("class")
require("entity")
require("player_controller")
require("enemy_controller")
require("utils")

Game = class()

function Game:init()
    self.entities = {}
    self.projectiles = {}
    self.lanes = {}
    self.player_controller = PlayerController()
    self.enemy_controller = EnemyController()

    self:load_bases()
    self:load_lanes()
end

function Game:draw()
    -- Draw background.
    local background_sprite = SPRITES["background"]

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background_sprite.image, 0, love.graphics:getHeight() - background_sprite.height)

    -- Draw entities/shadows.
    for _, entity in pairs(self.entities) do
        love.graphics.setColor(1, 1, 1)

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
        local health_text_width = FONT:getWidth(health_text)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(health_text, entity.x + entity.sprite.width / 2 - health_text_width / 2, entity.y - 15)
    end
end

function Game:update()
    local dt = love.timer.getAverageDelta()

    -- Update entities (movement and collision information).
    for _, entity in pairs(self.entities) do
        entity:update(self)
        Utils.log(entity)
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
    local base_hp = 35
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