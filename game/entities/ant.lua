require("entity")
require("sprite")

Ant = Entity:extend()
Ant.database = {}
Ant.database.speed = 1.5
Ant.database.hp = 9
Ant.database.damage = 3
Ant.database.base_damage = 2
Ant.database.cost = 12
Ant.database.description = string.format("" ..
    "Ant" ..
    "\n\nThe ant is a cheap all-rounder, ideal for tanking the frontlines." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f",

    Ant.database.damage,
    Ant.database.base_damage,
    Ant.database.hp,
    Ant.database.speed
)

function Ant:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.ant,
        x,
        y,
        Ant.database.speed,
        Ant.database.hp,
        Ant.database.damage,
        Ant.database.base_damage,
        lane_index,
        controller_tag,
        Ant.database.cost
    )
end

function Ant:get_portrait_sprite()
    return SPRITES.ant_portrait
end