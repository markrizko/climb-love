Game = {}
Game.__index = Game

-- local RED_X = 100
-- local RED_Y = 500
-- local BLACK_X = 100
-- local BLACK_Y = 300
-- local RED_DECK_X = 500
-- local RED_DECK_Y = 500
-- local BLACK_DECK_X = 500
-- local BLACK_DECK_Y = 300
-- local KING_Y = 50
-- local KING_X = 100

function Game:new()
    local game = setmetatable({}, Game)
    game.redDeck = Deck:new()
    game.blackDeck = Deck:new()
    game.redDeck:fillRed()
    game.blackDeck:fillBlack()
    game.redInPlay = {}
    game.blackInPlay = {}
    game.score = 0
    game.gameOver = false

    -- Load card images
    game.cardImages = {}
    for i = 1, 13 do
        game.cardImages[i] = love.graphics.newImage("images/card-hearts-" .. i .. ".png")
    end
    for i = 1, 13 do
        game.cardImages[i + 13] = love.graphics.newImage("images/card-spades-" .. i .. ".png")
    end

    game.cardBack = love.graphics.newImage("images/card-back1.png")
    return game
end

function Game:update(dt)
    -- TODO
end

function Game:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local redCardX = screenWidth * 0.1
    local redCardY = screenHeight * 0.7
    local blackCardX = screenWidth * 0.1
    local blackCardY = screenHeight * 0.4
    local deckX = screenWidth * 0.6
    local blackDeckY = screenHeight * 0.4
    local redDeckY = screenHeight * 0.7
    local blackKingX = screenWidth * 0.25
    local blackKingY = screenHeight * 0.1

    for i, card in ipairs(self.redInPlay) do
        if card then
            love.graphics.draw(self.cardImages[card.tag], redCardX + (i - 1) * 120, redCardY)
        end
    end

    for i, card in ipairs(self.blackInPlay) do
        if card then
            love.graphics.draw(self.cardImages[card.tag + 13], blackCardX + (i - 1) * 120, blackCardY)
        end
    end

    love.graphics.draw(self.cardBack, deckX, redDeckY)
    love.graphics.draw(self.cardBack, deckX, blackDeckY)

    love.graphics.draw(self.cardImages[26], blackKingX, blackKingY)
end

function Game:keypressed(key)
    -- TODO
end

function Game:drawCards()
    for i = 1, 3 do
        table.insert(self.redInPlay, self.redDeck:getCard())
        table.insert(self.blackInPlay, self.blackDeck:getCard())
    end
end

function Game:compare()
    -- TODO
end

function Game:endGame()
    -- TODO
end

