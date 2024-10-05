require("class")
require("sprite")
require("entity")

Lane = Entity:extend()

function Lane:init(start_x, start_y)
    self.start_x = start_x;
    self.start_y = start_y;
    self.entities = {}
    self.sprite = SPRITES["lane_spawn"]
end