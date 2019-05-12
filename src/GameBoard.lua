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
    self.oldParentType = nil 
    self.cardPile = CardPile() 
    self.winPile = WinPile()
    self.isWin = false
    
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
    
    --populate the closedPile of cardPile with the remaining cards
   local newCard = self.deck:draw()
   while newCard do
        self.cardPile:addCard(newCard)
        newCard = self.deck:draw()
   end
   
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
            self.tableaus[i][j]:update(dt, self, self.tableaus[i], "tableau")
        end
    end
    
    --allow mouse input on cardPile & winPile
        self.cardPile:update(dt, self)
        self.winPile:update(dt, self)
end

function GameBoard:render()
    
    self:drawBackground()
    if not self.isWin then
        self:renderTableaus()
        self.cardPile:render()
        self.winPile:render()
        self:renderPickedUpCards()
    end
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
    if not self.isWin then
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
       
        -- tableau grid markers
        love.graphics.rectangle('line', 10, 160, CARD_WIDTH, CARD_HEIGHT, 3)
        love.graphics.rectangle('line', 90, 160, CARD_WIDTH, CARD_HEIGHT, 3)
        love.graphics.rectangle('line', 170, 160, CARD_WIDTH, CARD_HEIGHT, 3)
        love.graphics.rectangle('line', 250, 160, CARD_WIDTH, CARD_HEIGHT, 3)
        love.graphics.rectangle('line', 330, 160, CARD_WIDTH, CARD_HEIGHT, 3)
        love.graphics.rectangle('line', 410, 160, CARD_WIDTH, CARD_HEIGHT, 3)
        love.graphics.rectangle('line', 490, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    else
        love.graphics.clear(1, 1, 1, 1)
        love.graphics.setColor(12/255, 10/255, 62/255, 1)
        love.graphics.rectangle('fill', 0, 300, 1240, 80, 3)
        love.graphics.setColor(249/255, 86/255, 79/255, 1)
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.printf("CONGRATULATIONS!!! YOU HAVE WON :)", 0, 320, 1240, "center")
    end
end

function GameBoard:checkWin()
    self.isWin = self.winPile:checkWin()
end

--Helper Function:: print Tableau
function GameBoard:printTableau()
    for i = 1, NUM_TABLEAUS do
        print("Tableau #"..i)
        for j = 1, #self.tableaus[i] do
            print(j.."-->"..self.tableaus[i][j].face..self.tableaus[i][j].suit)
        end
    end
    print("PickedUp Cards")
    for j = 1, #self.pickedUpCards do
            print(j.."-->"..self.pickedUpCards[j].face..self.pickedUpCards[j].suit)
    end
end
