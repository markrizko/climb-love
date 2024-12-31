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
    game.graphicsController = GraphicsController:new()

    game.playButton = {
        x = game.graphicsController.BUTTON_X,
        y = game.graphicsController.BUTTON_Y,
        width = game.graphicsController.BUTTON_WIDTH,
        height = game.graphicsController.BUTTON_HEIGHT,
        text = "Play Move"
    }
    return game
end

function Game:update(dt)
    -- TODO
end

function Game:draw()
    self.graphicsController:drawCardsToScreen(self.redInPlay, self.blackInPlay, self.selectedCards)
    self.graphicsController:drawPlayButton(self.playButton)
end

function Game:keypressed(key)
    -- TODO
end

function Game:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        -- Debug prints to check values
        print("x: " .. tostring(x) .. ", y: " .. tostring(y))
        print("BUTTON_X: " .. tostring(self.graphicsController.BUTTON_X) .. ", BUTTON_Y: " .. tostring(self.graphicsController.BUTTON_Y))
        print("BUTTON_WIDTH: " .. tostring(self.graphicsController.BUTTON_WIDTH) .. ", BUTTON_HEIGHT: " .. tostring(self.graphicsController.BUTTON_HEIGHT))

        -- Check if the play move button is pressed
        if x >= self.graphicsController.BUTTON_X and x <= self.graphicsController.BUTTON_X + self.graphicsController.BUTTON_WIDTH and y >= self.graphicsController.BUTTON_Y and y <= self.graphicsController.BUTTON_Y + self.graphicsController.BUTTON_HEIGHT then
            print("x: " .. x .. ", y: " .. y)
            self:playMove()
        end

        -- Check red cards
        for i, card in ipairs(self.redInPlay) do
            if card then
                local cardX = self.graphicsController.redCardX + (i - 1) * 120
                local cardY = self.graphicsController.redCardY
                local cardWidth = self.graphicsController.cardImages[card.tag]:getWidth()
                local cardHeight = self.graphicsController.cardImages[card.tag]:getHeight()
                if x >= cardX and x <= cardX + cardWidth and y >= cardY and y <= cardY + cardHeight then
                    self.selectedCards.red[i] = not self.selectedCards.red[i]
                end
            end
        end

        -- Check black cards
        for i, card in ipairs(self.blackInPlay) do
            if card then
                local cardX = self.graphicsController.blackCardX + (i - 1) * 120
                local cardY = self.graphicsController.blackCardY
                local cardWidth = self.graphicsController.cardImages[card.tag + 13]:getWidth()
                local cardHeight = self.graphicsController.cardImages[card.tag + 13]:getHeight()
                if x >= cardX and x <= cardX + cardWidth and y >= cardY and y <= cardY + cardHeight then
                    self.selectedCards.black[i] = not self.selectedCards.black[i]
                end
            end
        end
    end
end

function Game:startGame()
    self:drawCards()
    self:draw()
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

