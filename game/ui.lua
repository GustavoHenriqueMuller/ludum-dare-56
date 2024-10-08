require("class")
require("entities.ant")
require("entities.snail")
require("entities.scorpion")
require("entities.frog")

FONT_HEIGHT = 22
FONT = love.graphics.newFont("assets/04B_03__.ttf", FONT_HEIGHT)

SMALL_FONT_HEIGHT = 16
SMALL_FONT = love.graphics.newFont("assets/04B_03__.ttf", SMALL_FONT_HEIGHT)

BIG_FONT_HEIGHT = 26
BIG_FONT = love.graphics.newFont("assets/04B_03__.ttf", BIG_FONT_HEIGHT)

HUGE_FONT_HEIGHT = 125
HUGE_FONT = love.graphics.newFont("assets/04B_03__.ttf", HUGE_FONT_HEIGHT)

UI_MODE = {NORMAL = "Normal", SPAWNING = "Spawning"}
UI_BUTTON_ENTITIES = {Ant, Scorpion, Snail, Frog}
UI_HEIGHT = 75

UI = class()

function UI:init(game)
    self.mode = UI_MODE.NORMAL
    self.entity_index_being_spawned = -1

    self:load_buttons(game)
end

function UI:load_buttons(game)
    self.button_entities = {}

    -- Create entity buy buttons.
    local button_buy_entity_x = 6
    local button_buy_entity_y = 4

    for i = 1, #UI_BUTTON_ENTITIES do
        local entity = UI_BUTTON_ENTITIES[i]
        local button_buy_entity = Button(entity:get_portrait_sprite(), button_buy_entity_x, button_buy_entity_y)

        button_buy_entity.update = function(self, game)
            self.is_enabled = game.player_controller:can_buy_entity(entity)
        end

        button_buy_entity.draw = function(self)
            self:base_draw()

            -- Draw the description box/text.
            if self:contains_mouse() then
                local description_box_width, description_box_height = 400, 300
                local description_box_x, description_box_y = self.x + self.sprite.width / 2, self.y + self.sprite.height / 2
                local margin = 8

                -- Draw box underneath.
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("fill", description_box_x, description_box_y, description_box_width, description_box_height)

                -- Draw border.
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line", description_box_x, description_box_y, description_box_width, description_box_height)

                -- Draw text on top with margin.
                love.graphics.setColor(1, 1, 1)
                love.graphics.printf(UI_BUTTON_ENTITIES[i].database.description, description_box_x + margin, description_box_y + margin, description_box_width - margin * 2)
            end
        end

        button_buy_entity.on_click = function(self, game)
            game.player_controller:buy_entity(entity)
        end

        self.button_entities[#self.button_entities + 1] = button_buy_entity

        button_buy_entity_x = button_buy_entity_x + 64
    end

    -- Create spawn buttons.
    self.spawn_buttons = {}

    for i = 1, #game.lanes do
        local lane = game.lanes[i]
        local spawn_button = Button(SPRITES.lane_spawn, lane.start_player_x, lane.start_player_y, 0.4)

        spawn_button.update = function(self, game)
            self.is_enabled = true

            -- Check for collision of the button with the entities in the same lane to disable the button.
            for entity_id in pairs(lane.entities_ids) do
                local entity = game.entities[entity_id]

                if entity:check_collision(self) then
                    self.is_enabled = false
                end
            end
        end

        local UI = self

        spawn_button.on_click = function(self, game)
            local entity_to_spawn = UI_BUTTON_ENTITIES[UI.entity_index_being_spawned]
            game.player_controller:buy_entity(game, entity_to_spawn, i, CONTROLLER_TAG.PLAYER)
        end

        self.spawn_buttons[#self.spawn_buttons + 1] = spawn_button
    end
end

function UI:draw(game)
    -- Draw menu background.
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), UI_HEIGHT)

    -- Draw menu outline.
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), UI_HEIGHT)

    love.graphics.setColor(1, 1, 1)

    -- Draw lane buttons, if on spawning mode.
    love.graphics.setColor(1, 1, 1, 0.5)

    if self.mode == UI_MODE.SPAWNING then
        for i = 1, #self.spawn_buttons do
            local spawn_button = self.spawn_buttons[i]
            spawn_button:draw()
        end
    end

    -- Draw title text.
    love.graphics.setColor(1, 1, 1)

    local title_text = "Age of Tiny Creatures  -  Ludum Dare 56"
    local title_text_width = BIG_FONT:getWidth(title_text)

    love.graphics.setFont(BIG_FONT)
    love.graphics.print(title_text, love.graphics:getWidth() / 2 - title_text_width / 2, UI_HEIGHT / 2 - BIG_FONT_HEIGHT / 2)
    love.graphics.setFont(FONT)

    -- Draw time text.
    love.graphics.setColor(0.5, 0.5, 0.5)

    local time_text = "Time: " .. string.format("%.1f", game.timer) .. "s"
    local time_text_width = FONT:getWidth(time_text)
    love.graphics.print(time_text, love.graphics.getWidth() - time_text_width - 6, 16)

    -- Draw UI mode text.
    local ui_mode_text_width = FONT:getWidth(self.mode)
    love.graphics.print(self.mode, love.graphics.getWidth() - ui_mode_text_width - 6, 16 + FONT_HEIGHT)

    -- Draw gold text.
    love.graphics.setColor(0.929, 0.71, 0.169)

    local gold_text = "Gold: $" .. game.player_controller.gold
    local gold_text_width = FONT:getWidth(gold_text)
    love.graphics.print(gold_text, love.graphics.getWidth() - gold_text_width - 6 - 160, 16)

    -- Draw gold text per each button entity.
    for i = 1, #self.button_entities do
        local button_entity = self.button_entities[i]

        local entity_cost_text = "$" .. UI_BUTTON_ENTITIES[i].database.cost
        local entity_cost_text_width = FONT:getWidth(entity_cost_text)

        love.graphics.print(
            entity_cost_text,
            button_entity.x + button_entity.sprite.width / 2 - entity_cost_text_width / 2,
            button_entity.y + button_entity.sprite.height
        )
    end

    -- Draw buttons in reverse order.
    for i = #self.button_entities, 1, -1 do
        self.button_entities[i]:draw()
    end

    -- Draw victory/defeat/draw screen.
    if game.state ~= GAME_STATE.PLAYING then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, UI_HEIGHT, love.graphics:getWidth(), love.graphics:getHeight() - UI_HEIGHT)

        local state_text = game.state .. "!"
        local state_text_width = HUGE_FONT:getWidth(state_text)

        -- Determine color.
        if game.state == GAME_STATE.VICTORY then
            love.graphics.setColor(0.514, 1, 0.353)
        end

        if game.state == GAME_STATE.DEFEAT then
            love.graphics.setColor(1, 0.353, 0.353)
        end

        if game.state == GAME_STATE.DRAW then
            love.graphics.setColor(1, 0.902, 0.353)
        end

        -- Print text.
        love.graphics.setFont(HUGE_FONT)
        love.graphics.print(
            state_text,
            love.graphics:getWidth() / 2 - state_text_width / 2,
            love.graphics:getHeight() / 2 - HUGE_FONT_HEIGHT / 2
        )
        love.graphics.setFont(FONT)
    end
end

function UI:update(game)
    for i = 1, #self.button_entities do
        self.button_entities[i]:update(game)
    end

    for i = 1, #self.spawn_buttons do
        self.spawn_buttons[i]:update(game)
    end

    if game.state ~= GAME_STATE.PLAYING then
        self:deselect_entity()
    end
end

function UI:select_entity(game, button_entity_index)
    self:deselect_entity()

    local entity = UI_BUTTON_ENTITIES[button_entity_index]

    if game.player_controller:can_buy_entity(entity) then
        self.entity_index_being_spawned = button_entity_index
        self.mode = UI_MODE.SPAWNING

        self.button_entities[button_entity_index]:set_pressed(true)
    end
end

function UI:deselect_entity()
    if self.entity_index_being_spawned ~= -1 then
        self.button_entities[self.entity_index_being_spawned]:set_pressed(false)
    end

    self.entity_index_being_spawned = -1
    self.mode = UI_MODE.NORMAL
end

function UI:mouse_pressed(game)
    if game.state == GAME_STATE.PLAYING then
        if self.mode == UI_MODE.NORMAL then
            for i = 1, #self.button_entities do
                if self.button_entities[i]:contains_mouse() then
                    self:select_entity(game, i)
                end
            end

        elseif self.mode == UI_MODE.SPAWNING then
            for lane_index = 1, #self.spawn_buttons do
                local spawn_button = self.spawn_buttons[lane_index]

                if spawn_button:contains_mouse() then
                    if spawn_button.is_enabled then
                        spawn_button:on_click(game)
                    else
                        return
                    end
                end
            end

            self:deselect_entity()
        end
    end
end

function UI:key_pressed(game, key)
    if key == "escape" then
        love.event.quit()
    elseif key == '1' then
        self:select_entity(game, 1)
    elseif key == '2' then
        self:select_entity(game, 2)
    elseif key == '3' then
        self:select_entity(game, 3)
    elseif key == '4' then
        self:select_entity(game, 4)
    end
end