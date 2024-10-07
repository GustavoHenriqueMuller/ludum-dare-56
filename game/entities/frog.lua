require("entity")
require("sprite")

Frog = Entity:extend()
Frog.database = {}
Frog.database.speed = 0.6
Frog.database.hp = 380
Frog.database.damage = 60
Frog.database.base_damage = 150
Frog.database.cost = 500
Frog.database.attack_type = ATTACK_TYPE.MELEE
Frog.database.attack_range = 0
Frog.database.description = string.format(
    "Frog" ..
    "\n\nThe frog is a true behemoth in both strength and size." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f" ..
    "\nAttack type: %s",

    Frog.database.damage,
    Frog.database.base_damage,
    Frog.database.hp,
    Frog.database.speed,
    Frog.database.attack_type
)

function Frog:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.frog,
        nil,

        Frog.database.speed,
        Frog.database.hp,
        Frog.database.damage,
        Frog.database.base_damage,
        Frog.database.attack_type,
        Frog.database.attack_range,
        Frog.database.cost,

        x,
        y,
        lane_index,
        controller_tag
    )
end

function Frog:get_portrait_sprite()
    return SPRITES.frog_portrait
end