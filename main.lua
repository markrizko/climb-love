local aspectRatio
local minWidth = 800
local minHeight = 600

function love.load()
    -- Initialize random seed
    math.randomseed(os.time())

    love.window.setMode(800, 600, {resizable = true, minwidth = minWidth, minheight = minHeight})

    aspectRatio = love.graphics.getWidth() / love.graphics.getHeight()

    -- Load necessary modules
    require "card"
    require "deck"
    require "game"

    -- Initialize game
    game = Game:new()
    game:drawCards()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.resize(w, h)
    -- Maintain aspect ratio and ensure minimum dimensions
    local newWidth = math.max(w, minWidth)
    local newHeight = newWidth / aspectRatio

    if newHeight < minHeight then
        newHeight = minHeight
        newWidth = newHeight * aspectRatio
    end

    -- Set the new window size
    love.window.setMode(newWidth, newHeight, {resizable = true, minwidth = minWidth, minheight = minHeight})
end
