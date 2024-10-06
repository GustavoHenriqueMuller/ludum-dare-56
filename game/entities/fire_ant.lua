require("entity")
require("sprite")

FireAnt = Entity:extend()
FireAnt.database = {}
FireAnt.database.speed = 1
FireAnt.database.hp = 6
FireAnt.database.damage = 1
FireAnt.database.cost = 20

function FireAnt:init(x, y, lane_index, controller_tag)
    self:initialize(
        SPRITES.fire_ant,
        x,
        y,
        FireAnt.database.speed,
        FireAnt.database.hp,
        FireAnt.database.damage,
        lane_index,
        controller_tag
    )
end

function FireAnt:get_portrait_sprite()
    return SPRITES.ant_portrait
end