require("entity")
require("sprite")

Snail = Entity:extend()
Snail.database = {}
Snail.database.speed = 0.8
Snail.database.hp = 270
Snail.database.damage = 10
Snail.database.base_damage = 100
Snail.database.cost = 220
Snail.database.attack_type = ATTACK_TYPE.MELEE
Snail.database.attack_range = 0
Snail.database.description = string.format(
    "Snail" ..
    "\n\nThe snail is a slow, tanky creature that deals low combat damage but high damage against the enemy base." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f" ..
    "\nAttack type: %s",

    Snail.database.damage,
    Snail.database.base_damage,
    Snail.database.hp,
    Snail.database.speed,
    Snail.database.attack_type
)

function Snail:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.snail,
        SPRITES.poison_ball,

        Snail.database.speed,
        Snail.database.hp,
        Snail.database.damage,
        Snail.database.base_damage,
        Snail.database.attack_type,
        Snail.database.attack_range,
        Snail.database.cost,

        x,
        y,
        lane_index,
        controller_tag
    )
end

function Snail:get_portrait_sprite()
    return SPRITES.snail_portrait
end