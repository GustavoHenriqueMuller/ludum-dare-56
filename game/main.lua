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
    Sprite("fire_ant")

    Sprite("ant_portrait")

    Sprite("lane_spawn")

    Sprite("player_base")
    Sprite("enemy_base")
    Sprite("background")
    Sprite("shadow")

    -- Load game.
    GAME = Game()

    -- Load UI.
    UI = UI(GAME)
end

function love.draw()
    GAME:draw()
    UI:draw(GAME)
end

function love.update()
    GAME:update()
    UI:update(GAME)
end

function love.mousepressed(_, _, _, _)
    UI:mouse_pressed(GAME)
end

function love.keypressed(key, _)
    UI:key_pressed(GAME, key)
end