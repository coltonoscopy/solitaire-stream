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

-- return a card from the deck and remove it
function Deck:draw()
    if #self.cards <= 0 then
        return nil
    end
    local cardIndex = math.random(#self.cards)
    local cardFromDeck = self.cards[cardIndex]
    local cardToReturn = Card(cardFromDeck.face, cardFromDeck.suit)

    table.remove(self.cards, cardIndex)

    return cardToReturn
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
    -- pass
end
