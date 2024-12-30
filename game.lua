Game = {}
Game.__index = Game

function Game:new()
    local game = setmetatable({}, Game)
    game.redDeck = Deck:new()
    game.blackDeck = Deck:new()
    game.redDeck:fillRed()
    game.blackDeck:fillBlack()
    game.redInPlay = {}
    game.blackInPlay = {}
    game.selectedCards = {red = {}, black = {}}
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
    game.blackKingImage = love.graphics.newImage("images/card-spades-13.png")

    -- Calculate screen dimensions and positions
    game.screenWidth = love.graphics.getWidth()
    game.screenHeight = love.graphics.getHeight()

    game.BUTTON_X = game.screenWidth * 0.7
    game.BUTTON_Y = game.screenHeight * 0.8
    game.BUTTON_WIDTH = 100
    game.BUTTON_HEIGHT = 50

    game.redCardX = game.screenWidth * 0.1
    game.redCardY = game.screenHeight * 0.8
    game.blackCardX = game.screenWidth * 0.1
    game.blackCardY = game.screenHeight * 0.4
    game.blackKingX = game.screenWidth * 0.5
    game.blackKingY = game.screenHeight * 0.1

    return game
end

function Game:update(dt)
    -- TODO
end

function Game:draw()
    -- Clear the screen
    love.graphics.clear()

    -- Draw the red deck
    love.graphics.draw(self.cardBack, self.redCardX, self.redCardY)

    -- Draw the black deck
    love.graphics.draw(self.cardBack, self.blackCardX, self.blackCardY)

    -- Draw the black king
    love.graphics.draw(self.blackKingImage, self.blackKingX, self.blackKingY)

    -- Draw the red cards in play
    for i, card in ipairs(self.redInPlay) do
        if card then
            local cardX = self.redCardX + (i - 1) * 120
            local cardY = self.redCardY
            love.graphics.draw(self.cardImages[card.tag], cardX, cardY)
            if self.selectedCards.red[i] then
                love.graphics.setColor(1, 0, 0)
                love.graphics.setLineWidth(3)
                love.graphics.rectangle("line", cardX, cardY, self.cardImages[card.tag]:getWidth(), self.cardImages[card.tag]:getHeight())
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(1)
            end
        end
    end

    -- Draw the black cards in play
    for i, card in ipairs(self.blackInPlay) do
        if card then
            local cardX = self.blackCardX + (i - 1) * 120
            local cardY = self.blackCardY
            love.graphics.draw(self.cardImages[card.tag + 13], cardX, cardY)
            if self.selectedCards.black[i] then
                love.graphics.setColor(1, 0, 0)
                love.graphics.setLineWidth(3)
                love.graphics.rectangle("line", cardX, cardY, self.cardImages[card.tag + 13]:getWidth(), self.cardImages[card.tag + 13]:getHeight())
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(1)
            end
        end
    end

    -- Draw the play move button
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.BUTTON_X, self.BUTTON_Y, self.BUTTON_WIDTH, self.BUTTON_HEIGHT)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.print("Play Move", self.BUTTON_X + 10, self.BUTTON_Y + 20)
    love.graphics.setColor(1, 1, 1)
end

function Game:keypressed(key)
    -- TODO
end

function Game:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        -- Debug prints to check values
        print("x: " .. tostring(x) .. ", y: " .. tostring(y))
        print("BUTTON_X: " .. tostring(self.BUTTON_X) .. ", BUTTON_Y: " .. tostring(self.BUTTON_Y))
        print("BUTTON_WIDTH: " .. tostring(self.BUTTON_WIDTH) .. ", BUTTON_HEIGHT: " .. tostring(self.BUTTON_HEIGHT))

        -- Check if the play move button is pressed
        if x >= self.BUTTON_X and x <= self.BUTTON_X + self.BUTTON_WIDTH and y >= self.BUTTON_Y and y <= self.BUTTON_Y + self.BUTTON_HEIGHT then
            print("x: " .. x .. ", y: " .. y)
            self:playMove()
        end

        -- Check red cards
        for i, card in ipairs(self.redInPlay) do
            if card then
                local cardX = self.redCardX + (i - 1) * 120
                local cardY = self.redCardY
                local cardWidth = self.cardImages[card.tag]:getWidth()
                local cardHeight = self.cardImages[card.tag]:getHeight()
                if x >= cardX and x <= cardX + cardWidth and y >= cardY and y <= cardY + cardHeight then
                    self.selectedCards.red[i] = not self.selectedCards.red[i]
                end
            end
        end

        -- Check black cards
        for i, card in ipairs(self.blackInPlay) do
            if card then
                local cardX = self.blackCardX + (i - 1) * 120
                local cardY = self.blackCardY
                local cardWidth = self.cardImages[card.tag + 13]:getWidth()
                local cardHeight = self.cardImages[card.tag + 13]:getHeight()
                if x >= cardX and x <= cardX + cardWidth and y >= cardY and y <= cardY + cardHeight then
                    self.selectedCards.black[i] = not self.selectedCards.black[i]
                end
            end
        end
    end
end

function Game:drawCards()
    for i = 1, 3 do
        table.insert(self.redInPlay, self.redDeck:getCard())
        table.insert(self.blackInPlay, self.blackDeck:getCard())
    end
end

function Game:compare()
    local redTotal = 0
    local blackTotal = 0
    local redTag = 0
    local blackTag = 0

    for i, selected in ipairs(self.selectedCards.red) do
        if selected then
            local card = self.redInPlay[i]
            redTotal = redTotal + card.value
            if card.tag > redTag then
                redTag = card.tag
            end
        end
    end

    for i, selected in ipairs(self.selectedCards.black) do
        if selected then
            local card = self.blackInPlay[i]
            blackTotal = blackTotal + card.value
            if card.tag > blackTag then
                blackTag = card.tag
            end
        end
    end

    if redTotal < blackTotal then
        return 0 -- Invalid move
    elseif redTotal == blackTotal then
        if redTag > blackTag then
            return 1 -- Win by seniority
        elseif redTag < blackTag then
            return 2 -- Loss by seniority
        else
            return 2 -- Tie
        end
    else
        return 1 -- Win
    end
end

function Game:playMove()
    local result = self:compare()

    if result == 0 then
        print("Invalid move")
        return
    elseif result == 1 then
        print("Valid move, you win")
        -- Handle win logic
    elseif result == 2 then
        print("Tie")
        -- Handle tie logic
    end

    -- Clear selected cards
    self.selectedCards.red = {}
    self.selectedCards.black = {}
end

function Game:endGame()
    -- TODO
end

