Card = {}
Card.__index = Card

Card.Suit = {
    HEARTS = 1,
    SPADES = 2,
    DIAMONDS = 3,
    CLUBS = 4
}

function Card:new(tag, suit)
    local card = setmetatable({}, Card)
    card.tag = tag
    card.value = self:getValueFromTag(tag, suit)
    card.suit = suit
    card.image = self:loadCardImage(tag, suit)
    return card
end

function Card:loadCardImage(tag, suit)
    local suits = {"hearts", "spades", "diamonds", "clubs"}
    return love.graphics.newImage("images/card-" .. suits[suit] .. "-" .. tag .. ".png")
end

function Card:getValueFromTag(tag, suit)
    if tag == 1 then
        if suit == HEARTS or suit == SPADES or suit == DIAMONDS then
            return 1
        else
            return 11
        end
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