require("entity")
require("sprite")

Ant = Entity:extend()
Ant.database = {}
Ant.database.speed = 1.1
Ant.database.hp = 90
Ant.database.damage = 30
Ant.database.base_damage = 30
Ant.database.attack_type = ATTACK_TYPE.MELEE
Ant.database.attack_range = 0
Ant.database.cost = 120
Ant.database.description = string.format(
    "Ant" ..
    "\n\nThe ant is a cheap all-rounder, ideal for tanking the frontlines." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f" ..
    "\nAttack type: %s",

    Ant.database.damage,
    Ant.database.base_damage,
    Ant.database.hp,
    Ant.database.speed,
    Ant.database.attack_type
)

function Ant:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.ant,
        nil,

        Ant.database.speed,
        Ant.database.hp,
        Ant.database.damage,
        Ant.database.base_damage,
        Ant.database.attack_type,
        Ant.database.attack_range,
        Ant.database.cost,

        x,
        y,
        lane_index,
        controller_tag
    )
end

function Ant:get_portrait_sprite()
    return SPRITES.ant_portrait
end