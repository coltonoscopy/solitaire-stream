--[[
    Game Board Class
]]

GameBoard = Class{}

function GameBoard:init()
    self.deck = Deck()
    self.tableaus = {}
end

function GameBoard:generateTableaus()

end

function GameBoard:render()
    self:drawBackground()
    self.deck:render()
end

function GameBoard:drawBackground()
    love.graphics.clear(0, 0.3, 0, 1)

    -- main stack placeholders
    love.graphics.rectangle('line', 10, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 90, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 170, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 250, 50, CARD_WIDTH, CARD_HEIGHT, 3)

    -- active stock card
    love.graphics.rectangle('line', 410, 50, CARD_WIDTH, CARD_HEIGHT, 3)

    -- stock itself
    love.graphics.rectangle('line', 490, 50, CARD_WIDTH, CARD_HEIGHT, 3)

    -- tableaus
    love.graphics.rectangle('line', 10, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 90, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 170, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 250, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 330, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 410, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 490, 160, CARD_WIDTH, CARD_HEIGHT, 3)
end