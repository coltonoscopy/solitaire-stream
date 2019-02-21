--[[
    Deck Class
]]

Deck = Class{}

function Deck:init()
    self.cards = {}

    for i = 1, CARDS_IN_SUIT do
        table.insert(self.cards, Card(i, HEARTS))
        table.insert(self.cards, Card(i, DIAMONDS))
        table.insert(self.cards, Card(i, CLUBS))
        table.insert(self.cards, Card(i, SPADES))
    end

    self:shuffle()
end

function Deck:shuffle()
    local newCards = {}

    for i = CARDS_IN_DECK, 1, -1 do
        local randomIndex = math.random(#self.cards)
        local card = self.cards[randomIndex]
        local newCard = Card(card.face, card.suit, 0, 0)

        table.insert(newCards, newCard)
        table.remove(self.cards, randomIndex)
    end

    self.cards = newCards
end

function Deck:render()
    for i = 1, 5 do
        love.graphics.draw(gTextures['cards'], 
            gCardQuads[self.cards[i].suit][self.cards[i].face], (i - 1) * 80, 50)
    end
end