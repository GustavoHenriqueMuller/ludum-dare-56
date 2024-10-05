require("sprite")
require("lane")
require("button")
require("game")
require("ui")

function love.load()
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setFont(FONT)
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())

    -- Load sprites.
    Sprite("ant")
    Sprite("ant_portrait")

    Sprite("ant_enemy")
    Sprite("lane_spawn")

    Sprite("player_base")
    Sprite("enemy_base")

    -- Load UI.
    UI = UI()

    -- Load game.
    GAME = Game()
end

function love.draw()
    UI:draw(GAME)
    GAME:draw()
end

function love.update()
    GAME:update()
end

function love.mousepressed(x, y, button, istouch)
    if UI.mode == UI_MODE.NORMAL then
        for i = 1, #UI.button_entities do
            if UI.button_entities[i]:contains_mouse() then
                UI:select_entity(i)
            end
        end

    elseif UI.mode == UI_MODE.SPAWNING then
        for i = 1, #UI.button_spawn_lanes do
            if UI.button_spawn_lanes[i]:contains_mouse() then
                GAME:add_entity(Entity(
                    SPRITES.ant,
                    GAME.lanes[i].start_player_x,
                    GAME.lanes[i].start_player_y,
                    20,
                    3,
                    1,
                    i,
                    CONTROLLER_TAG.PLAYER
                ))
            end
        end

        UI:deselect_entity()
    end
end

function love.keypressed(key, scancode)
    if key == "escape" then
        love.event.quit()
    elseif key == '1' then
        UI:select_entity(1)
    end
end