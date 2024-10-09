require("class")

CONTROLLER_TAG = {PLAYER = "Player", ENEMY = "Enemy"}
ATTACK_TYPE = {MELEE = "Melee", RANGED = "Ranged"}

Entity = class()
Entity.counter = 0

function Entity:init(sprite, projectile, speed, hp, damage, base_damage, attack_type, attack_range, cost, x, y, lane_index, controller_tag)
    self:base_init(sprite, projectile, speed, hp, damage, base_damage, attack_type, attack_range, cost, x, y, lane_index, controller_tag)
end

function Entity:base_init(sprite, projectile, speed, hp, damage, base_damage, attack_type, attack_range, cost, x, y, lane_index, controller_tag)
    self.sprite = sprite
    self.projectile = projectile

    self.speed = speed
    self.hp = hp
    self.max_hp = hp
    self.damage = damage
    self.base_damage = base_damage
    self.attack_type = attack_type
    self.attack_range = attack_range

    self.cost = cost
    self.x = x
    self.y = y
    self.lane_index = lane_index
    self.tag = controller_tag

    self.attacking_entity_id = -1
    self.attack_timer = 0

    Entity.counter = Entity.counter + 1
    self.id = Entity.counter
end

function Entity:update(game)
    -- Destroy self on collision with base.
    if self.tag == CONTROLLER_TAG.PLAYER and self:check_collision(game.enemy_base) then
        game.player_controller.gold = game.player_controller.gold + math.floor(self.hp / self.max_hp * self.cost / 4)

        game:remove_entity(self.id)
        game.enemy_base:take_damage(self.base_damage)

    elseif self.tag == CONTROLLER_TAG.ENEMY and self:check_collision(game.player_base) then
        game.enemy_controller.gold = game.enemy_controller.gold + math.floor(self.hp / self.max_hp * self.cost / 4)

        game:remove_entity(self.id)
        game.player_base:take_damage(self.base_damage)
    end

    -- Stop if attacking an entity.
    local is_colliding = self:calculate_colliding_entity_id(game) ~= -1
    local is_attacking = self:calculate_attacking_entity_id(game) ~= -1

    -- Moves the entity if not colliding and not attacking.
    if not is_colliding and not is_attacking then
        self.attack_timer = 0

        if self.tag == CONTROLLER_TAG.PLAYER then
            self.x = self.x + self.speed
        else
            self.x = self.x - self.speed
        end
    end
end

function Entity:calculate_colliding_entity_id(game)
    if self.lane_index ~= -1 then
        local lane = game.lanes[self.lane_index]

        for entity_id in pairs(lane.entities_ids) do
            local entity = game.entities[entity_id]
            local entity_comes_after = (self.tag == CONTROLLER_TAG.PLAYER and entity.x > self.x) or
                                       (self.tag == CONTROLLER_TAG.ENEMY and entity.x < self.x)

            if entity_id ~= self.id and entity_comes_after then
                if self:check_collision(entity) then
                    return entity.id
                end
            end
        end
    end

    return -1
end

function Entity:calculate_attacking_entity_id(game)
    local colliding_entity_id = self:calculate_colliding_entity_id(game)

    -- If we are colliding with an entity that is an enemy, that is our attack target.
    if colliding_entity_id ~= -1 then
        local colliding_entity = game.entities[colliding_entity_id]

        if colliding_entity.tag ~= self.tag then
            return colliding_entity_id
        end
    end

    -- If we are not colliding with an entity, check if we are ranged and there is an enemy in range.
    if self.attack_type == ATTACK_TYPE.RANGED then
        local lane = game.lanes[self.lane_index]

        for entity_id in pairs(lane.entities_ids) do
            local entity = game.entities[entity_id]
            local entity_comes_after = (self.tag == CONTROLLER_TAG.PLAYER and entity.x > self.x) or
                                       (self.tag == CONTROLLER_TAG.ENEMY and entity.x < self.x)

            if entity_id ~= self.id and entity_comes_after and entity.tag ~= self.tag then
                local distance_to_entity = math.abs(self.x - entity.x)

                if distance_to_entity <= self.attack_range then
                    return entity_id
                end
            end
        end
    end

    return -1
end

function Entity:combat(game, dt)
    -- Attacks if has an available opponent to attack.
    local attacking_entity_id = self:calculate_attacking_entity_id(game)

    if attacking_entity_id ~= -1 then
        local attacking_entity = game.entities[attacking_entity_id]

        if attacking_entity.tag ~= self.tag then
            self.attack_timer = self.attack_timer + dt

            if self.attack_timer >= 1 then
                -- If we are melee, attack directly.
                if self.attack_type == ATTACK_TYPE.MELEE then
                    attacking_entity:take_damage(self.damage)
                else
                    -- If we are ranged, spawn projectile.
                    local new_projectile = self.projectile(
                        self.x + self.sprite.width / 2,
                        self.y + self.sprite.height / 2,
                        self.lane_index,
                        self.tag
                    )

                    game:add_projectile(new_projectile)
                end

                self.attack_timer = 0
            end
        end
    end
end

function Entity:take_damage(amount)
    SOURCES.hit:play()
    self.hp = math.max(0, self.hp - amount)
end

function Entity:check_collision(other_entity)
    local is_colliding = self.x < other_entity.x + other_entity.sprite.width and
                         self.x + self.sprite.width > other_entity.x and
                         self.y < other_entity.y + other_entity.sprite.height and
                         self.y + self.sprite.height > other_entity.y

    return is_colliding
end