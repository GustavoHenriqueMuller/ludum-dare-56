require("class")

CONTROLLER_TAG = {PLAYER = "Player", ENEMY = "ENEMY"}
ENTITY_COSTS = {5}

Entity = class()
Entity.counter = 0

function Entity:init(sprite, x, y, speed, hp, damage, lane_index, controller_tag)
    self.sprite = sprite
    self.x = x
    self.y = y
    self.speed = speed
    self.hp = hp
    self.max_hp = hp
    self.damage = damage
    self.lane_index = lane_index
    self.tag = controller_tag
    self.is_colliding = false

    Entity.counter = Entity.counter + 1
    self.id = Entity.counter
end

function Entity:update(game)
    -- Moves the entity.
    if not self.is_colliding then
        if self.tag == CONTROLLER_TAG.PLAYER then
            self.x = self.x + self.speed
        else
            self.x = self.x - self.speed
        end
    end

    -- Destroy self on collision with base.
    if self.tag == CONTROLLER_TAG.PLAYER and self:check_collision(game.enemy_base) then
        game:remove_entity(self.id)
        game.enemy_base:takeDamage(self.damage)

    elseif self.tag == CONTROLLER_TAG.ENEMY and self:check_collision(game.player_base) then
        game:remove_entity(self.id)
        game.player_base:takeDamage(self.damage)
    end

    -- Stop if colliding with opposing entity in same lane.
    if self.lane_index ~= -1 then
        local lane = game.lanes[self.lane_index]

        for entity_id, _ in pairs(lane.entities_ids) do
            local entity = game.entities[entity_id]

            if entity_id ~= self.id and entity.tag ~= self.tag then
                local is_colliding = self:check_collision(entity)

                if is_colliding then
                    self.is_colliding = true
                    break
                end
            end
        end
    end
end


function Entity:takeDamage(amount)
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