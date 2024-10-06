require("entity")
require("sprite")

Scorpion = Entity:extend()
Scorpion.database = {}
Scorpion.database.speed = 2
Scorpion.database.hp = 6
Scorpion.database.damage = 2
Scorpion.database.base_damage = 2
Scorpion.database.attack_type = ATTACK_TYPE.RANGED
Scorpion.database.attack_range = 100
Scorpion.database.cost = 18
Scorpion.database.description = string.format(
    "Scorpion" ..
    "\n\nThe Scorpion is a fragile fast-moving creature that attacks with poison from a distance." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f" ..
    "\nAttack type: %s (range: %d)",

    Scorpion.database.damage,
    Scorpion.database.base_damage,
    Scorpion.database.hp,
    Scorpion.database.speed,
    Scorpion.database.attack_type,
    Scorpion.database.attack_range
)

function Scorpion:init(x, y, lane_index, controller_tag)
    self:base_init(
        SPRITES.scorpion,
        nil,

        Scorpion.database.speed,
        Scorpion.database.hp,
        Scorpion.database.damage,
        Scorpion.database.base_damage,
        Scorpion.database.attack_type,
        Scorpion.database.attack_range,
        Scorpion.database.cost,

        x,
        y,
        lane_index,
        controller_tag
    )
end

function Scorpion:get_portrait_sprite()
    return SPRITES.scorpion_portrait
end