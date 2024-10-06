require("entity")
require("sprite")

Ant = Entity:extend()
Ant.database = {}
Ant.database.speed = 1.5
Ant.database.hp = 3
Ant.database.damage = 1
Ant.database.cost = 10

function Ant:init(x, y, lane_index, controller_tag)
    self:initialize(
        SPRITES.ant,
        x,
        y,
        Ant.database.speed,
        Ant.database.hp,
        Ant.database.damage,
        lane_index,
        controller_tag
    )
end

function Ant:get_portrait_sprite()
    return SPRITES.ant_portrait
end