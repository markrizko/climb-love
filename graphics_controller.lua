-- graphics_controller.lua
GraphicsController = {}
GraphicsController.__index = GraphicsController

function GraphicsController:new()
    local self = setmetatable({}, GraphicsController)
    self.shakeDuration = 0.5
    self.shakeMagnitude = 5
    self.shakeTime = 0

    -- Load card images
    self.cardImages = {}
    for i = 1, 13 do
        self.cardImages[i] = love.graphics.newImage("images/card-hearts-" .. i .. ".png")
        if not self.cardImages[i] then
            print("Failed to load image: images/card-hearts-" .. i .. ".png")
        end
    end
    for i = 1, 13 do
        self.cardImages[i + 13] = love.graphics.newImage("images/card-spades-" .. i .. ".png")
        if not self.cardImages[i + 13] then
            print("Failed to load image: images/card-spades-" .. i .. ".png")
        end
    end

    self.cardBack = love.graphics.newImage("images/card-back1.png")
    if not self.cardBack then
        print("Failed to load image: images/card-back1.png")
    end
    self.blackKingImage = love.graphics.newImage("images/card-spades-13.png")
    if not self.blackKingImage then
        print("Failed to load image: images/card-spades-13.png")
    end

    -- Calculate screen dimensions and positions
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    self.BUTTON_X = self.screenWidth * 0.7
    self.BUTTON_Y = self.screenHeight * 0.8
    self.BUTTON_WIDTH = 100
    self.BUTTON_HEIGHT = 50

    self.redCardX = self.screenWidth * 0.1
    self.redCardY = self.screenHeight * 0.8
    self.blackCardX = self.screenWidth * 0.1
    self.blackCardY = self.screenHeight * 0.4
    self.blackKingX = self.screenWidth * 0.5
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

function GraphicsController:drawPlayButton(button)
    local buttonX, buttonY = button.x, button.y

    if self.shakeTime > 0 then
        local shakeOffsetX = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        local shakeOffsetY = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        buttonX = buttonX + shakeOffsetX
        buttonY = buttonY + shakeOffsetY
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", buttonX, buttonY, button.width, button.height)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf(button.text, buttonX, buttonY + button.height / 2 - 6, button.width, "center")
    love.graphics.setColor(1, 1, 1)
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
    for i, card in ipairs(redInPlay) do
        if card then
            local cardX = self.redCardX + (i - 1) * 120
            local cardY = self.redCardY
            love.graphics.draw(self.cardImages[card.tag], cardX, cardY)
            if selectedCards.red[i] then
                love.graphics.setColor(1, 0, 0)
                love.graphics.setLineWidth(3)
                love.graphics.rectangle("line", cardX, cardY, self.cardImages[card.tag]:getWidth(), self.cardImages[card.tag]:getHeight())
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(1)
            end
        end
    end

    -- Draw the black cards in play
    for i, card in ipairs(blackInPlay) do
        if card then
            local cardX = self.blackCardX + (i - 1) * 120
            local cardY = self.blackCardY
            love.graphics.draw(self.cardImages[card.tag + 13], cardX, cardY)
            if selectedCards.black[i] then
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

return GraphicsController