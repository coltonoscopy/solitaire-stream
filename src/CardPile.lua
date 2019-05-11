--[[
    CardPile Class
    Contains the open and closed pile of the remaining cards
    Cards can be drawn one by one from closed pile
]]

CardPile = Class{}

function CardPile:init()
    self.openStock = {}
    self.closedStock = {}
    self.numDraws = 1
end

--insert the card into closed Pile
function CardPile:addCard(newCard)
    table.insert(self.closedStock, newCard)   
    newCard.x = 490
    newCard.y = 50
end

function CardPile:openCard()
--Checks if cards are present in closed pile & moves the bottommost card of closed pile to open pile
--If not, resets the closed pile with all the cards in open pile
    
    if #self.closedStock > 0 then
        --remove card from close pile 
        local card = table.remove(self.closedStock)
        
        --move card to open pile
        table.insert(self.openStock, 1, card)
        card.hidden = false
        card.x = 410
        card.y = 50
    else
       --check if number of draws have not exceeded 3 draws 
       if self.numDraws < 3 then 
           self.numDraws = self.numDraws + 1
           
           --this should not work but let us see
           local tempPile = self.closedStock
           self.closedStock = self.openStock
           self.openStock = tempPile
       else
           love.window.showMessageBox("Alert", "No more draws allowed!", "info", true)
       end 
    end
end

function CardPile:update(dt) 
     --check if the mouseposition is within bounds of the closed stack 
     local closedcard
     if #self.closedStock > 0 then
        closedcard = self.closedStock[#self.closedStock]
     end
     
     local x, y = love.mouse.getPosition()
     if love.mouse.wasButtonPressed(1) and 
        x >= 490 and x <= 490 + CARD_WIDTH and
        y >= 50  and y <= 50 + CARD_HEIGHT then
        self:openCard()
     end
     
end 

function CardPile:render()
     --if closedStock contains atleast 1 card, display the card-back
     if #self.closedStock > 0 then
       love.graphics.draw(gTextures['card-back'], 490, 50)
     end
     
     --if closedStock contains atleast 1 card
     if #self.openStock > 0 then
       local bottomCard = self.openStock[1]
       bottomCard:render()
     end    
end

