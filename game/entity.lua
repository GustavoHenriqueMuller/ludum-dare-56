require("class")

CONTROLLER_TAG = {PLAYER = "Player", ENEMY = "ENEMY"}

Entity = class()
Entity.counter = 0

function Entity:init(game, sprite, x, y, speed, hp, damage, lane_index, controller_tag)
    self.sprite = sprite
    self.x = x
    self.y = y
    self.speed = speed
    self.hp = hp / 2
    self.max_hp = hp
    self.damage = damage
    self.lane_index = lane_index
    self.tag = controller_tag

    Entity.counter = Entity.counter + 1
    self.id = Entity.counter

    game.entities[Entity.counter] = self
end

function Entity:update(game)
    if self.tag == CONTROLLER_TAG.PLAYER then
        self.x = self.x + self.speed
    else
        self.x = self.x - self.speed
    end

    -- Destroy self on collision with base.
    if self.tag == CONTROLLER_TAG.PLAYER and self:isColliding(game.enemy_base) then
        self:destroy(game)
        game.enemy_base:takeDamage(self.damage)

    elseif self.tag == CONTROLLER_TAG.ENEMY and self:isColliding(game.player_base) then
        self:destroy(game)
        game.player_base:takeDamage(self.damage)
    end
end

function Entity:destroy(game)
    game.entities[self.id] = nil
end

function Entity:takeDamage(amount)
    self.hp = math.max(0, self.hp - amount)
end

function Entity:isColliding(other)
    local self_width, self_height = self.sprite.image:getDimensions()
    local other_width, other_height = other.sprite.image:getDimensions()

    local is_colliding = self.x < other.x + other_width and
                         self.x + self_width > other.x and
                         self.y < other.y + other_height and
                         self.y + self_height > other.y

    return is_colliding
end