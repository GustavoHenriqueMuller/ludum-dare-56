require("class")

Lane = class()

function Lane:init(start_player_x, start_player_y, start_enemy_x, start_enemy_y)
    self.start_player_x = start_player_x
    self.start_player_y = start_player_y

    self.start_enemy_x = start_enemy_x
    self.start_enemy_y = start_enemy_y

    self.entities_ids = {}
end