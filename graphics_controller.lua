-- graphics_controller.lua
GraphicsController = {}
GraphicsController.__index = GraphicsController

function GraphicsController:new()
    local self = setmetatable({}, GraphicsController)
    self.shakeDuration = 0.5
    self.shakeMagnitude = 5
    self.shakeTime = 0

    -- -- Load card images
    -- self.cardImages = {}
    -- for i = 1, 13 do
    --     self.cardImages[i] = love.graphics.newImage("images/card-hearts-" .. i .. ".png")
    --     if not self.cardImages[i] then
    --         print("Failed to load image: images/card-hearts-" .. i .. ".png")
    --     end
    -- end
    -- for i = 1, 13 do
    --     self.cardImages[i + 13] = love.graphics.newImage("images/card-spades-" .. i .. ".png")
    --     if not self.cardImages[i + 13] then
    --         print("Failed to load image: images/card-spades-" .. i .. ".png")
    --     end
    -- end

    self.cardBack = love.graphics.newImage("images/card-back1.png")
    if not self.cardBack then
        print("Failed to load image: images/card-back1.png")
    end
    self.blackKingImage = love.graphics.newImage("images/evil-king.png")
    if not self.blackKingImage then
        print("Failed to load image: images/evil-king.png")
    end

    -- Calculate screen dimensions and positions
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    self.PLAY_BUTTON_X = self.screenWidth * 0.7
    self.PLAY_BUTTON_Y = self.screenHeight * 0.5
    self.PLAY_BUTTON_WIDTH = 100
    self.PLAY_BUTTON_HEIGHT = 50

    self.RST_BUTTON_X = self.screenWidth * 0.8
    self.RST_BUTTON_Y = self.screenHeight * 0.1
    self.RST_BUTTON_WIDTH = 100
    self.RST_BUTTON_HEIGHT = 50

    self.redCardX = self.screenWidth * 0.1
    self.redCardY = self.screenHeight * 0.7
    self.blackCardX = self.screenWidth * 0.1
    self.blackCardY = self.screenHeight * 0.4
    self.blackKingX = self.screenWidth * 0.25
    self.blackKingY = self.screenHeight * 0.1
    return self
end

function GraphicsController:shakePlayButton()
    self.shakeTime = self.shakeDuration
end

function GraphicsController:update(dt)
    if self.shakeTime > 0 then
        self.shakeTime = self.shakeTime - dt
        if self.shakeTime <= 0 then
            self.shakeTime = 0
        end
    end
end

function GraphicsController:displayWinScreen()
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(32)) -- Set font size to 32
    love.graphics.print("You Win!", self.screenWidth / 2 - 100, self.screenHeight / 2 - 50)
    love.graphics.present()
end

function GraphicsController:displayLoseScreen()
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(32)) -- Set font size to 32
    love.graphics.print("You Lose!", self.screenWidth / 2 - 50, self.screenHeight / 2 - 50)
    love.graphics.present()
end

-- TODO consolidate button drawing
function GraphicsController:drawResetButton(button)
    local buttonX, buttonY = button.x, button.y
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", buttonX, buttonY, button.width, button.height)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf(button.text, buttonX, buttonY + button.height / 2 - 6, button.width, "center")
    love.graphics.setColor(1, 1, 1)
end

function GraphicsController:drawPlayButton(button)
    local buttonX, buttonY = button.x, button.y

    if self.shakeTime > 0 then
        local shakeOffsetX = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        local shakeOffsetY = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        buttonX = buttonX + shakeOffsetX
        buttonY = buttonY + shakeOffsetY
        self.shakeTime = self.shakeTime - love.timer.getDelta()
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", buttonX, buttonY, button.width, button.height)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf(button.text, buttonX, buttonY + button.height / 2 - 6, button.width, "center")
    love.graphics.setColor(1, 1, 1)
end

function GraphicsController:displayTieCards(redCard, blackCard)
    local blackCardX = self.PLAY_BUTTON_X
    local blackCardY = self.PLAY_BUTTON_Y - 175
    love.graphics.draw(blackCard.image, blackCardX, blackCardY)

    local redCardX = self.PLAY_BUTTON_X
    local redCardY = self.PLAY_BUTTON_Y + 75
    love.graphics.draw(redCard.image, redCardX, redCardY)

    love.graphics.present()
end

function GraphicsController:drawCardsToScreen(redInPlay, blackInPlay, selectedCards)
    -- Clear the screen
    love.graphics.clear()

    -- Draw the red deck
    love.graphics.draw(self.cardBack, self.redCardX, self.redCardY)

    -- Draw the black deck
    love.graphics.draw(self.cardBack, self.blackCardX, self.blackCardY)

    -- Draw the black king
    love.graphics.draw(self.blackKingImage, self.blackKingX, self.blackKingY)

    -- Draw the red cards in play
    for i = 1, 3 do
        local card = redInPlay[i]
        local cardX = self.redCardX + (i - 1) * 120
        local cardY = self.redCardY
        if card and card.tag ~= 0 then
            love.graphics.draw(card.image, cardX, cardY)
        else
            love.graphics.draw(self.cardBack, cardX, cardY)
        end
        if selectedCards.red[i] then
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", cardX, cardY, card.image:getWidth(), card.image:getHeight())
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
        end
    end

    -- Draw the black cards in play
    for i = 1, 3 do
        local card = blackInPlay[i]
        local cardX = self.blackCardX + (i - 1) * 120
        local cardY = self.blackCardY
        if card and card.tag ~= 0 then
            love.graphics.draw(card.image, cardX, cardY)
        else
            love.graphics.draw(self.cardBack, cardX, cardY)
        end
        if selectedCards.black[i] then
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", cardX, cardY, card.image:getWidth(), card.image:getHeight())
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
        end
    end

    -- Draw the play move button
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.PLAY_BUTTON_X, self.PLAY_BUTTON_Y, self.PLAY_BUTTON_WIDTH, self.PLAY_BUTTON_HEIGHT)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.print("Play Move", self.PLAY_BUTTON_X + 10, self.PLAY_BUTTON_Y + 20)
    love.graphics.setColor(1, 1, 1)
end

return GraphicsController