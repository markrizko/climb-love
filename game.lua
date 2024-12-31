Game = {}
Game.__index = Game

function Game:new()
    local game = setmetatable({}, Game)
    game.redDeck = Deck:new()
    game.blackDeck = Deck:new()
    game.redDeck:fillRed()
    game.blackDeck:fillBlack()
    game.redInPlay = {{tag = 0, value = 0}, {tag = 0, value = 0}, {tag = 0, value = 0}}
    game.blackInPlay = {{tag = 0, value = 0}, {tag = 0, value = 0}, {tag = 0, value = 0}}
    game.selectedCards = {red = {false, false, false}, black = {false, false, false}}
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
    self:status()
end

function Game:status()
    -- Check game status -- if we have won or lost
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
        -- print("x: " .. tostring(x) .. ", y: " .. tostring(y))
        -- print("BUTTON_X: " .. tostring(self.graphicsController.BUTTON_X) .. ", BUTTON_Y: " .. tostring(self.graphicsController.BUTTON_Y))
        -- print("BUTTON_WIDTH: " .. tostring(self.graphicsController.BUTTON_WIDTH) .. ", BUTTON_HEIGHT: " .. tostring(self.graphicsController.BUTTON_HEIGHT))

        -- Check if the play move button is pressed
        if x >= self.graphicsController.BUTTON_X and x <= self.graphicsController.BUTTON_X + self.graphicsController.BUTTON_WIDTH and y >= self.graphicsController.BUTTON_Y and y <= self.graphicsController.BUTTON_Y + self.graphicsController.BUTTON_HEIGHT then
            -- print("x: " .. x .. ", y: " .. y)
            self:playMove()
        end

        -- Check red cards
        for i = 1, 3 do
            local card = self.redInPlay[i]
            if card and card.tag ~= 0 then
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
        for i = 1, 3 do
            local card = self.blackInPlay[i]
            if card and card.tag ~= 0 then
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
    for i, card in ipairs(self.redInPlay) do
        if card.tag == 0 then
            self.redInPlay[i] = self.redDeck:getCard()
        end
    end

    for i, card in ipairs(self.blackInPlay) do
        if card.tag == 0 then
            self.blackInPlay[i] = self.blackDeck:getCard()
        end
    end
end

function Game:redTotal()
    local total = 0
    for i, selected in ipairs(self.selectedCards.red) do
        if selected then
            local card = self.redInPlay[i]
            total = total + card.value
        end
    end
    print("Red total: " .. total)
    return total
end

function Game:blackTotal()
    local total = 0
    for i, selected in ipairs(self.selectedCards.black) do
        if selected then
            local card = self.blackInPlay[i]
            total = total + card.value
        end
    end
    print("Black total: " .. total)
    return total
end

function Game:getTags()
    local redTag = 0
    local blackTag = 0
    for i, selected in ipairs(self.selectedCards.red) do
        if selected then
            local card = self.redInPlay[i]
            if card.tag > redTag then
                redTag = card.tag
            end
        end
    end

    for i, selected in ipairs(self.selectedCards.black) do
        if selected then
            local card = self.blackInPlay[i]
            if card.tag > blackTag then
                blackTag = card.tag
            end
        end
    end
    return redTag, blackTag
end

function Game:compare()
    -- TODO ace wipe
    -- TODO king tie
    local redTotal = self:redTotal(self)
    local blackTotal = self:blackTotal(self)

    if redTotal < blackTotal then
        return 0 -- Invalid move
    end

    if redTotal == blackTotal then
        local redTag, blackTag = self:getTags()
        print("Red tag: " .. redTag)
        print("Black tag: " .. blackTag)
        if redTag > 10 or blackTag > 10 then
            if redTag == blackTag then
                if redTag == 13 and blackTag == 13 then
                    return 1 -- King tie
                else
                    return 2 -- Tie
                end
            elseif redTag > blackTag then
                return 1 -- Red wins
            else
                return 0 -- Invalid move
            end
        else
            return 2 -- Tie
        end
    end

    if redTotal > blackTotal then
        return 1 -- Red wins
    end

    return 0 -- Invalid move

end

function Game:endTurn()
    for i, selected in ipairs(self.selectedCards.red) do
        if selected then
            self.redInPlay[i] = {tag = 0, value = 0}
        end
    end

    for i, selected in ipairs(self.selectedCards.black) do
        if selected then
            self.blackInPlay[i] = {tag = 0, value = 0}
        end
    end

    self.selectedCards.red = {false, false, false}
    self.selectedCards.black = {false, false, false}

    self:drawCards()
end

function Game:playMove()
    local result = self:compare()

    if result == 0 then
        print("Invalid move")
        self.graphicsController:shakePlayButton()
        return
    elseif result == 1 then
        print("Valid move, you win")
        self:endTurn()
        -- Handle win logic
    elseif result == 2 then
        print("Tie")
        -- Handle tie logic
    end
end

function Game:endGame()
    -- TODO
end

