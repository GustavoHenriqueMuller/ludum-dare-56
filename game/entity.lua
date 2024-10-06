require("class")

CONTROLLER_TAG = {PLAYER = "Player", ENEMY = "ENEMY"}

Entity = class()
Entity.counter = 0

function Entity:init(sprite, x, y, speed, hp, damage, base_damage, lane_index, controller_tag, cost)
    self:base_init(sprite, x, y, speed, hp, damage, base_damage, lane_index, controller_tag, cost)
end

function Entity:base_init(sprite, x, y, speed, hp, damage, base_damage, lane_index, controller_tag, cost)
    self.sprite = sprite
    self.x = x
    self.y = y
    self.speed = speed
    self.hp = hp
    self.max_hp = hp
    self.damage = damage
    self.base_damage = base_damage
    self.lane_index = lane_index
    self.tag = controller_tag
    self.colliding_entity_id = -1
    self.attack_timer = 0
    self.cost = cost

    Entity.counter = Entity.counter + 1
    self.id = Entity.counter
end

function Entity:update(game)
    -- Destroy self on collision with base.
    if self.tag == CONTROLLER_TAG.PLAYER and self:check_collision(game.enemy_base) then
        game:remove_entity(self.id)
        game.enemy_base:take_damage(self.base_damage)

    elseif self.tag == CONTROLLER_TAG.ENEMY and self:check_collision(game.player_base) then
        game:remove_entity(self.id)
        game.player_base:take_damage(self.base_damage)
    end

    -- Stop if colliding with entity in same lane.
    self.colliding_entity_id = -1

    if self.lane_index ~= -1 then
        local lane = game.lanes[self.lane_index]

        for entity_id, _ in pairs(lane.entities_ids) do
            local entity = game.entities[entity_id]
            local entity_comes_after = (self.tag == CONTROLLER_TAG.PLAYER and entity.x > self.x) or
                                       (self.tag == CONTROLLER_TAG.ENEMY and entity.x < self.x)

            if entity_id ~= self.id and entity_comes_after then
                local is_colliding = self:check_collision(entity)

                if is_colliding then
                    self.colliding_entity_id = entity.id
                    break
                end
            end
        end
    end

    -- Moves the entity if not colliding.
    if self.colliding_entity_id == -1 then
        self.attack_timer = 0

        if self.tag == CONTROLLER_TAG.PLAYER then
            self.x = self.x + self.speed
        else
            self.x = self.x - self.speed
        end
    else
        -- Attacks entity if colliding.
        local colliding_entity = game.entities[self.colliding_entity_id]

        if colliding_entity.tag ~= self.tag then
            self.attack_timer = self.attack_timer + love.timer.getAverageDelta()

            if self.attack_timer > 1 then
                colliding_entity:take_damage(self.damage)
                self.attack_timer = 0
            end
        end
    end
end

function Entity:take_damage(amount)
    self.hp = math.max(0, self.hp - amount)
end

function Entity:check_collision(other)
    local self_width, self_height = self.sprite.image:getDimensions()
    local other_width, other_height = other.sprite.image:getDimensions()

    local is_colliding = self.x < other.x + other_width and
                         self.x + self_width > other.x and
                         self.y < other.y + other_height and
                         self.y + self_height > other.y

    return is_colliding
end