require("entity")
require("sprite")
require("projectiles.poison_ball")

Scorpion = Entity:extend()
Scorpion.database = {}
Scorpion.database.speed = 0.4
Scorpion.database.hp = 6
Scorpion.database.damage = 2
Scorpion.database.base_damage = 2
Scorpion.database.attack_type = ATTACK_TYPE.RANGED
Scorpion.database.attack_range = 300
Scorpion.database.cost = 180
Scorpion.database.description = string.format(
    "Scorpion" ..
    "\n\nThe Scorpion is a very slow moving creature that attacks with poison from a distance." ..
    "\n\nDamage: %d" ..
    "\nBase Damage: %d" ..
    "\nHP: %d" ..
    "\nSpeed: %.2f" ..
    "\nAttack type: %s (%dpx)",

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
        PoisonBall,

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