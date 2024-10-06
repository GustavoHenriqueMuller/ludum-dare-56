require("entity")
require("sprite")

Scorpion = Entity:extend()
Scorpion.database = {}
Scorpion.database.speed = 2
Scorpion.database.hp = 6
Scorpion.database.damage = 2
Scorpion.database.base_damage = 2
Scorpion.database.cost = 18
Scorpion.database.description = string.format(
    "Scorpion" ..
    "\n\nThe Scorpion is a fragile fast-moving creature that attacks with poison from a distance." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f",

    Scorpion.database.damage,
    Scorpion.database.base_damage,
    Scorpion.database.hp,
    Scorpion.database.speed
)

function Scorpion:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.scorpion,
        x,
        y,
        Scorpion.database.speed,
        Scorpion.database.hp,
        Scorpion.database.damage,
        Scorpion.database.base_damage,
        lane_index,
        controller_tag,
        Scorpion.database.cost
    )
end

function Scorpion:get_portrait_sprite()
    return SPRITES.scorpion_portrait
end