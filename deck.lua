Deck = {}
Deck.__index = Deck

function Deck:new()
    local deck = setmetatable({}, Deck)
    deck.cards = {}
    deck.cardsLeft = 0
    return deck
end

function Deck:fillRed()
    for i = 1, 13 do
        table.insert(self.cards, Card:new(i))
        table.insert(self.cards, Card:new(i))
    end
    self.cardsLeft = #self.cards
    self:shuffle()
end

function Deck:fillBlack()
    for i = 1, 13 do
        table.insert(self.cards, Card:new(i))
        if i ~= 13 then
            table.insert(self.cards, Card:new(i))
        end
    end
    self.cardsLeft = #self.cards
    self:shuffle()
end

function Deck:shuffle()
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

function Deck:getCard()
    if self.cardsLeft == 0 then
        return nil
    else
        local card = table.remove(self.cards)
        self.cardsLeft = self.cardsLeft - 1
        return card
    end
end

function Deck:deckSize()
    return self.cardsLeft
end
