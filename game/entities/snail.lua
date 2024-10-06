require("entity")
require("sprite")

Snail = Entity:extend()
Snail.database = {}
Snail.database.speed = 0.85
Snail.database.hp = 21
Snail.database.damage = 1
Snail.database.base_damage = 6
Snail.database.cost = 22
Snail.database.description = string.format(
    "Snail" ..
    "\n\nThe snail is a slow, tanky creature that deals low combat damage but high damage against the enemy base." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f",

    Snail.database.damage,
    Snail.database.base_damage,
    Snail.database.hp,
    Snail.database.speed
)

function Snail:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.snail,
        x,
        y,
        Snail.database.speed,
        Snail.database.hp,
        Snail.database.damage,
        Snail.database.base_damage,
        lane_index,
        controller_tag,
        Snail.database.cost
    )
end

function Snail:get_portrait_sprite()
    return SPRITES.snail_portrait
end