Card = {}
Card.__index = Card

function Card:new(tag, suit)
    local card = setmetatable({}, Card)
    card.tag = tag
    card.value = self:getValueFromTag(tag)
    card.suit = suit
    card.image = self:loadCardImage(tag, suit)
    return card
end

function Card:loadCardImage(tag, suit)
    local suits = {"hearts", "spades", "diamonds", "clubs"}
    return love.graphics.newImage("images/card-" .. suits[suit] .. "-" .. tag .. ".png")
end

function Card:getValueFromTag(tag)
    if tag == 1 then
        return 11
    elseif tag >= 2 and tag <= 10 then
        return tag
    elseif tag >= 11 and tag <= 13 then
        return 10
    else
        return -1
    end
end

function Card:isAce()
    return self.tag == 1
end