require("class")

PlayerController = class()

function PlayerController:init()
    self.gold = 0
    self.gold_timer = 0
end

function PlayerController:update()
    local new_timer = self.gold_timer + love.timer.getAverageDelta()

    if new_timer > 1 then
        self.gold = self.gold + 5
        self.gold_timer = new_timer - 1
    else
        self.gold_timer = new_timer
    end
end