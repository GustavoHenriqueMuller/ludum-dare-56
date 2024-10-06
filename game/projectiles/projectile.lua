require("class")

Projectile = class()
Projectile.counter = 0

function Projectile:init(x, y, sprite, damage, speed, lane_index, controller_tag)
    self:base_init(x, y, sprite, damage, speed, lane_index, controller_tag)
end

function Projectile:base_init(x, y, sprite, damage, speed, lane_index, controller_tag)
    self.x = x
    self.y = y
    self.sprite = sprite
    self.damage = damage
    self.speed = speed
    self.lane_index = lane_index
    self.tag = controller_tag

    Projectile.counter = Projectile.counter + 1
    self.id = Projectile.counter
end

function Projectile:update(game)
    -- Move.
    if self.tag == CONTROLLER_TAG.PLAYER then
        self.x = self.x + self.speed
    else
        self.x = self.x - self.speed
    end

    -- Check for collision.
    local lane = game.lanes[self.lane_index]

    for entity_id, _ in pairs(lane.entities_ids) do
        local entity = game.entities[entity_id]

        if entity_id ~= self.id and entity:check_collision(self) and entity.tag ~= self.tag then
            entity:take_damage(self.damage)
            game:remove_projectile(self.id)
        end
    end

    -- Check if out of bounds.
    local is_out_of_bounds = (self.tag == CONTROLLER_TAG.PLAYER and self.x > lane.start_enemy_x) or
                             (self.tag == CONTROLLER_TAG.ENEMY and self.x < lane.start_player_x)

    if is_out_of_bounds then
        game:remove_projectile(self.id)
    end
end

function Projectile:draw()
    love.graphics.draw(self.sprite.image, self.x, self.y)
end