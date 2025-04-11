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
    game.winner = false
    game.finalBoss = false

    game.playButton = {
        x = game.graphicsController.PLAY_BUTTON_X,
        y = game.graphicsController.PLAY_BUTTON_Y,
        width = game.graphicsController.PLAY_BUTTON_WIDTH,
        height = game.graphicsController.PLAY_BUTTON_HEIGHT,
        text = "Play Move"
    }

    game.restartButton = {
        x = game.graphicsController.RST_BUTTON_X,
        y = game.graphicsController.RST_BUTTON_Y,
        width = game.graphicsController.RST_BUTTON_WIDTH,
        height = game.graphicsController.RST_BUTTON_HEIGHT,
        text = "Restart"
    }
    return game
end

function Game:update(dt)
    self:status()
    if self.gameOver then
        self:endGame()
    end
end

-- Check game status -- if we have won or lost
function Game:status()
    if self:allBlackCardsDefeated() and self.finalBoss == true then
        self.winner = true
        self.gameOver = true
    elseif self:blackWin() then
        self.gameOver = true
    end
end

function Game:blackWin()
    if self.redDeck:deckSize() > 0 then
        return false
    end

    local redTotal = 0
    local blackTotal = 0

    for i, card in ipairs(self.redInPlay) do
        redTotal = redTotal + card.value
    end

    for i, card in ipairs(self.blackInPlay) do
        blackTotal = blackTotal + card.value
    end

    if redTotal < blackTotal then
        return true
    elseif redTotal == blackTotal then
        local redTag, blackTag = self:getTags()
        if redTag < blackTag then
            return true
        end
    else
        return false
    end

end

function Game:draw()
    self.graphicsController:drawCardsToScreen(self.redInPlay, self.blackInPlay, self.selectedCards)
    self.graphicsController:drawPlayButton(self.playButton)
    self.graphicsController:drawResetButton(self.restartButton)
end

function Game:keypressed(key)
    -- TODO
end

function Game:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        -- Debug prints to check values
        -- print("x: " .. tostring(x) .. ", y: " .. tostring(y))
        -- print("PLAY_BUTTON_X: " .. tostring(self.graphicsController.PLAY_BUTTON_X) .. ", PLAY_BUTTON_Y: " .. tostring(self.graphicsController.PLAY_BUTTON_Y))
        -- print("PLAY_BUTTON_WIDTH: " .. tostring(self.graphicsController.PLAY_BUTTON_WIDTH) .. ", PLAY_BUTTON_HEIGHT: " .. tostring(self.graphicsController.PLAY_BUTTON_HEIGHT))

        -- Check if the play move button is pressed
        if x >= self.graphicsController.PLAY_BUTTON_X and x <= self.graphicsController.PLAY_BUTTON_X + self.graphicsController.PLAY_BUTTON_WIDTH and y >= self.graphicsController.PLAY_BUTTON_Y and y <= self.graphicsController.PLAY_BUTTON_Y + self.graphicsController.PLAY_BUTTON_HEIGHT then
            -- print("x: " .. x .. ", y: " .. y)
            self:playMove()
        end

        -- Check if the restart button is pressed
        if x >= self.graphicsController.RST_BUTTON_X and x <= self.graphicsController.RST_BUTTON_X + self.graphicsController.RST_BUTTON_WIDTH and y >= self.graphicsController.RST_BUTTON_Y and y <= self.graphicsController.RST_BUTTON_Y + self.graphicsController.RST_BUTTON_HEIGHT then
            self:restart()
        end

        -- Check red cards
        for i = 1, 3 do
            local card = self.redInPlay[i]
            if card and card.tag ~= 0 then
                local cardX = self.graphicsController.redCardX + (i - 1) * 120
                local cardY = self.graphicsController.redCardY
                local cardWidth = card.image:getWidth()
                local cardHeight = card.image:getHeight()
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
                local cardWidth = card.image:getWidth()
                local cardHeight = card.image:getHeight()
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

function Game:checkSelected()
    local redSelected = false
    local blackSelected = false

    for _, selected in ipairs(self.selectedCards.red) do
        if selected then
            redSelected = true
            break
        end
    end

    for _, selected in ipairs(self.selectedCards.black) do
        if selected then
            blackSelected = true
            break
        end
    end

    return redSelected and blackSelected
end

function Game:compare()
    local aceEffect = self:checkAceEffect()
    if aceEffect == 3 then
        return 1 -- Assassination
    elseif aceEffect == 4 then
        return 4 -- Ace wipe
    end

    if not self:checkSelected() then
        return 0 -- Invalid move
    end

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

function Game:checkAceEffect()
    local redAce = nil
    local blackRoyal = nil

    for i, selected in ipairs(self.selectedCards.red) do
        if selected then
            local card = self.redInPlay[i]
            if card.tag == 1 then
                redAce = card
            end
        end
    end

    for i, selected in ipairs(self.selectedCards.black) do
        if selected then
            local card = self.blackInPlay[i]
            if card.tag >= 11 then
                blackRoyal = card
            end
        end
    end

    if redAce and redAce.suit == DIAMONDS and blackRoyal then
        return 3 -- Assassination
    elseif redAce and redAce.suit == HEARTS then
        return 4 -- Ace wipe
    end

    return 0 -- No special effect
end

function Game:Tie()
    while true do
        if self.redDeck:deckSize() == 0 or self.blackDeck:deckSize() == 0 then
            return 1 -- red wins
        end

        local redCard = self.redDeck:getCard()
        local blackCard = self.blackDeck:getCard()

        self.graphicsController:displayTieCards(redCard, blackCard)
        love.timer.sleep(1.5)

        if redCard.value == blackCard.value then
            if redCard.tag > blackCard.tag then
                self.redDeck:putCardOnTop(redCard)
                return 1 -- red wins
            elseif redCard.tag < blackCard.tag then
                self.blackDeck:putCardOnTop(blackCard)
                return 2 -- black wins
            end
        elseif redCard.value > blackCard.value then
            self.redDeck:putCardOnTop(redCard)
            return 1 -- red wins
        else
            self.blackDeck:putCardOnTop(blackCard)
            return 2 -- black wins
        end
    end
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

    if self.blackDeck:deckSize() == 0 and self:allBlackCardsDefeated() and self.finalBoss == false then
        self:finalEncounter()
    end
end

function Game:allBlackCardsDefeated()
    for i, card in pairs(self.blackInPlay) do
        if card.tag ~= 0 then
            return false
        end
    end
    return true
end

function Game:finalEncounter()
    self.blackInPlay[2] = {tag = 13, value = 10, image = love.graphics.newImage("images/evil-king.png")}
    self:draw()
    self.finalBoss = true
end

function Game:restart()
    love.event.quit("restart")
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
        self:Tie()
        self:endTurn()
        -- Handle tie logic
    end
end

function Game:endGame()
    if self.winner then
        self.graphicsController:displayWinScreen()
    else
        self.graphicsController:displayLoseScreen()
    end
end

