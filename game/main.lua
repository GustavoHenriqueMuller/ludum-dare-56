require("sprite")
require("lane")
require("button")
require("game")
require("ui")

function love.load()
    FONT:setFilter("nearest", "nearest")

    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setFont(FONT)
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())

    -- Load sprites.
    Sprite("ant")
    Sprite("snail")

    Sprite("ant_portrait")
    Sprite("snail_portrait")
    Sprite("execute")

    Sprite("lane_spawn")

    Sprite("base")
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