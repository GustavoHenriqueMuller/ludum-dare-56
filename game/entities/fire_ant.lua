require("entity")
require("sprite")

FireAnt = Entity:extend()
FireAnt.database = {}
FireAnt.database.speed = 1
FireAnt.database.hp = 15
FireAnt.database.damage = 4
FireAnt.database.base_damage = 4
FireAnt.database.cost = 17

function FireAnt:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.fire_ant,
        x,
        y,
        FireAnt.database.speed,
        FireAnt.database.hp,
        FireAnt.database.damage,
        FireAnt.database.base_damage,
        lane_index,
        controller_tag,
        FireAnt.database.cost
    )
end

function FireAnt:get_portrait_sprite()
    return SPRITES.ant_portrait
end