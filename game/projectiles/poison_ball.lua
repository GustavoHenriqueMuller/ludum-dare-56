require("projectiles.projectile")

PoisonBall = Projectile:extend()

function PoisonBall:init(x, y, lane_index, controller_tag)
    self:base_init(
        x,
        y,
        SPRITES.poison_ball,
        Scorpion.database.damage,
        15,
        lane_index,
        controller_tag
    )
end