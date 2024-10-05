require("class")

FONT_HEIGHT = 20
FONT = love.graphics.newFont("assets/04B_03__.ttf", FONT_HEIGHT)

UI_MODE = {NORMAL = "Normal", SPAWNING = "Spawning"}
UI = class()

function UI:init()
    self.mode = UI_MODE.NORMAL
    self.index_entity_being_spawned = -1
    self.button_entities = {Button(SPRITES.ant_portrait, 4, 4)}
    self.button_spawn_lanes = {}
end

function UI:draw(game)
    local ui_height = 56
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), ui_height)

    love.graphics.setColor(1, 1, 1)

    -- Draw buttons.
    for i = 1, #UI.button_entities do
        UI.button_entities[i]:draw()
    end

    love.graphics.setColor(0.5, 0.5, 0.5)

    -- Draw time text.
    local time_text = "Time: " .. string.format("%.1f", love.timer.getTime()) .. "s"
    local time_text_width = FONT:getWidth(time_text)
    love.graphics.print(time_text, love.graphics.getWidth() - time_text_width - 6, 8)

    -- Draw UI mode text.
    local ui_mode_text_width = FONT:getWidth(UI.mode)
    love.graphics.print(UI.mode, love.graphics.getWidth() - ui_mode_text_width - 6, 8 + FONT_HEIGHT)

    -- Draw gold text.
    love.graphics.setColor(0.929, 0.71, 0.169)

    local gold_text = "Gold: $" .. game.player_controller.gold
    local gold_text_width = FONT:getWidth(gold_text)
    love.graphics.print(gold_text, love.graphics.getWidth() - gold_text_width - 6 - 150, 8)
end

function UI:select_entity(entity_index)
    UI.index_entity_being_spawned = entity_index
    UI.mode = UI_MODE.SPAWNING

    UI.button_entities[entity_index]:set_pressed(true)
end


function UI:deselect_entity()
    UI.button_entities[UI.index_entity_being_spawned]:set_pressed(false)

    UI.index_entity_being_spawned = -1
    UI.mode = UI_MODE.NORMAL
end