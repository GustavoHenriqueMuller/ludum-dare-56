require("class")
require("entities.ant")
require("entities.snail")
require("entities.scorpion")

FONT_HEIGHT = 22
FONT = love.graphics.newFont("assets/04B_03__.ttf", FONT_HEIGHT)

UI_MODE = {NORMAL = "Normal", SPAWNING = "Spawning"}
UI_BUTTON_ENTITIES = {Ant, Snail, Scorpion}
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
    local button_buy_entity_x = 150
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
                local button_width, button_height = self.sprite.image:getDimensions()

                local description_box_width, description_box_height = 400, 300
                local description_box_x, description_box_y = self.x + button_width / 2, self.y + button_height / 2
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

    -- Create lane buttons.
    self.spawn_buttons = {}

    for i = 1, #game.lanes do
        local lane = game.lanes[i]
        local spawn_button = Button(SPRITES.lane_spawn, lane.start_player_x, lane.start_player_y, 0.4)

        spawn_button.update = function(self, game)
            self.is_enabled = true

            -- Check for collision of the button with the entities in the same lane to disable the button.
            for entity_id, _ in pairs(lane.entities_ids) do
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
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), UI_HEIGHT)

    love.graphics.setColor(1, 1, 1)

    -- Draw lane buttons, if on spawning mode.
    love.graphics.setColor(1, 1, 1, 0.5)

    if self.mode == UI_MODE.SPAWNING then
        for i = 1, #self.spawn_buttons do
            local spawn_button = self.spawn_buttons[i]
            spawn_button:draw()
        end
    end

    -- Draw "Tiny Creatures" text.
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Tiny creatures", 4, UI_HEIGHT / 2 - FONT_HEIGHT, 150, "center")

    -- Draw time text.
    love.graphics.setColor(0.5, 0.5, 0.5)

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
    love.graphics.print(gold_text, love.graphics.getWidth() - gold_text_width - 6 - 200, 8)

    -- Draw gold text per each button entity.
    for i = 1, #self.button_entities do
        local button_entity = self.button_entities[i]
        local button_entity_width, button_entity_height = button_entity.sprite.image:getDimensions()

        local entity_cost_text = "$" .. UI_BUTTON_ENTITIES[i].database.cost
        local entity_cost_text_width = FONT:getWidth(entity_cost_text)

        love.graphics.print(entity_cost_text, button_entity.x + button_entity_width / 2 - entity_cost_text_width / 2, button_entity.y + button_entity_height)
    end

    -- Draw buttons in reverse order.
    for i = #UI.button_entities, 1, -1 do
        UI.button_entities[i]:draw()
    end
end

function UI:update(game)
    for i = 1, #self.button_entities do
        self.button_entities[i]:update(game)
    end

    for i = 1, #self.spawn_buttons do
        self.spawn_buttons[i]:update(game)
    end
end

function UI:select_entity(game, button_entity_index)
    local entity = UI_BUTTON_ENTITIES[button_entity_index]

    if game.player_controller:can_buy_entity(entity) then
        UI.entity_index_being_spawned = button_entity_index
        UI.mode = UI_MODE.SPAWNING

        UI.button_entities[button_entity_index]:set_pressed(true)
    end
end

function UI:deselect_entity()
    UI.button_entities[UI.entity_index_being_spawned]:set_pressed(false)

    UI.entity_index_being_spawned = -1
    UI.mode = UI_MODE.NORMAL
end

function UI:mouse_pressed(game)
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

function UI:key_pressed(game, key)
    if key == "escape" then
        love.event.quit()
    elseif key == '1' then
        UI:select_entity(game, 1)
    elseif key == '2' then
        UI:select_entity(game, 2)
    end
end