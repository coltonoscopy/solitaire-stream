--[[
    Game Board Class
]]

GameBoard = Class{}

function GameBoard:init()
    self.deck = Deck()
    self.tableaus = {}
    self.tablePool = {}
    self.cardPickedUp = false
    self.pickedUpCards = {}
    self.oldParent = nil
    
    self:generateTableaus()
end

function GameBoard:generateTableaus()
    
    -- populate all tableaus with starting cards
    for i = 1, NUM_TABLEAUS do
        table.insert(self.tableaus, {})

        local yPos = 160
        local xPos = 10 + 80 * (i - 1)
        local padding = 0

        for j = 1, i do
            
            local newCard = self.deck:draw()
            newCard.x = xPos
            newCard.y = yPos

            table.insert(self.tableaus[i], newCard)
            
            -- ensure topmost card is set to visible
            self.tableaus[i][j].hidden = j ~= i

            --initialize parent & child 
            if j > 1 then
                newCard.parent = self.tableaus[i][j-1] 
                self.tableaus[i][j-1].child = newCard
            end
              
            local padding = self.tableaus[i][j].hidden and 10 or 20
            yPos = yPos + padding
        end
    end
    self.tableaus[3][2].hidden = false
end

function GameBoard:update(dt)
    -- update all cards in hand first
    for i = 1, #self.pickedUpCards do
        if self.pickedUpCards[i] then 
           self.pickedUpCards[i]:update(dt, self, self.pickedUpCards)
        end 
    end
    
    -- iterate through all visible cards, allowing mouse input
    for i = 1, NUM_TABLEAUS do

        local foundCardNotHidden = false

        for j = #self.tableaus[i], 1, -1 do
            
            -- check if we found a visible card; abort checking for hidden
            -- cards later in the loop
            if not self.tableaus[i][j].hidden then
                foundCardNotHidden = true
            elseif foundCardNotHidden then
                break
            end
            ---self.tableaus[i][j]:show("Updating..")
            self.tableaus[i][j]:update(dt, self, self.tableaus[i])
        end
    end
    
end

function GameBoard:render()
    self:drawBackground()

    -- render tableaus
    self:renderTableaus()

    self:renderPickedUpCards()
end

function GameBoard:renderPickedUpCards()
    for i = #self.pickedUpCards, 1, -1 do
        self.pickedUpCards[i]:render()
    end
end

function GameBoard:renderTableaus()
    
    -- iterate over and draw cards in tableaus
    for i = 1, NUM_TABLEAUS do
        for j = 1, #self.tableaus[i] do
            self.tableaus[i][j]:render()
        end
    end
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
    love.graphics.draw(gTextures['card-back'], 490, 50)

    -- tableau grid markers
    love.graphics.rectangle('line', 10, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 90, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 170, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 250, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 330, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 410, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 490, 160, CARD_WIDTH, CARD_HEIGHT, 3)
end
