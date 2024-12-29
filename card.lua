Card = {}
Card.__index = Card

function Card:new(tag)
    local card = setmetatable({}, Card)
    card.tag = tag
    card.value = self:getValueFromTag(tag)
    return card
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