--[[
    Card Class
]]

Card = Class{}

function Card:init(face, suit, x, y)
    self.face = face
    self.suit = suit
    self.hidden = false
    self.pickedUp = false
    self.x = x
    self.y = y

    self.parent = nil
    self.child = nil
end

--[[
    Pick up the card, flagging it as such, then remove it from the tableau
    in which it is. Make a copy of this card and add it to the game board's
    staging hand.
]]
function Card:pickUp(tableau, newTableau)
    self.pickedUp = true
    self:show("Picked up...") 
    if tableau == nil then
        return
    end
    
    --weird insert behavior --@note to self:investigation needed!
    table.insert(newTableau, table.remove(tableau))
    
    if self.child then
        self.child:pickUp(tableau, newTableau)
    end
end

function Card:placeDown(tableau, oldTableau)
    self:show("Placed down...") 
    
    --insert card into tableau & update position to below the parent
    table.insert(tableau, table.remove(oldTableau))
    if self.parent then
        self.x = self.parent.x
        self.y = self.parent.y + 20  
    end
    
    if self.child then
        self.child:placeDown(tableau, oldTableau)
    end         
    self.pickedUp = false
end

function Card:show(text)
   print(text.."::"..self.face..self.suit)
end

function Card:removeParentLink()
   
   if self.parent then
       self.parent.child = nil
       self.parent = nil
   end
end  

--Checks if the final position of the pickedUpCard is within a tableau/not & Returns the tableau/ old position
function Card:checkBounds(posX, posY, tableaus, gameBoard)
    local bottomCard, newTableau = nil
    
    --check if the final position is within bounds of a tableau
    for i = 1, #tableaus do
        --in case the tableau has cards, check bounds of the lowermost card
        if #tableaus[i] > 0 then 
            bottomCard = tableaus[i][#tableaus[i]]
            if posX >= bottomCard.x and posX <= bottomCard.x + CARD_WIDTH and
                posY >= bottomCard.y and posY <= bottomCard.y + CARD_HEIGHT then
                newTableau = tableaus[i]           
                break  
            end
        else
        --if tableau has no cards, check bounds of tableau itself
             if posX >= (10 + (i - 1) * 80) and posX <= (10 + (i - 1) * 80 + CARD_WIDTH) and
                posY >= 160 and posY <= (160 +  CARD_HEIGHT) then
                newTableau = tableaus[i]           
                break  
             end
        end
    end
    
    --final position is not within bounds of any tableau,  
    --move pickedUp cards to its old tableau/pile
    if newTableau == nil then
        newTableau = gameBoard.oldParent
    end
    
    --placedown all the pickedup cards starting from the topmost card
    --separate treatment if the moved tableau
    if #newTableau > 0 then
        bottomCard = newTableau[#newTableau]
        bottomCard.child = gameBoard.pickedUpCards[#gameBoard.pickedUpCards]
        bottomCard.child.parent = bottomCard  
        bottomCard.child:placeDown(newTableau, gameBoard.pickedUpCards)
    else
    -- parent/new tableau is an empty tableau
        local tempCard = gameBoard.pickedUpCards[#gameBoard.pickedUpCards]
        for i = 1, #tableaus do
            if newTableau == tableaus[i] then
               tempCard.x = (10 + (i - 1) * 80)
               tempCard.y = 160
               tempCard:placeDown(newTableau, gameBoard.pickedUpCards)
               bottomCard = tempCard
               break
            end
        end                  
    end
    --set mouse Pointer to the left & out of bounds of the bottomCard to prevent "picking up" bottomCard recursively
    love.mouse.setPosition(bottomCard.x - 5, posY)         
    return newTableau
end  

function Card:update(dt, gameBoard, tableau)

    -- update card based on its parent, provided it is in PickedUpcards
    if self.pickedUp and tableau == gameBoard.pickedUpCards then
        if self.parent == nil then
            self.x, self.y = love.mouse.getPosition()
            self.x = self.x - CARD_WIDTH / 2
            self.y = self.y - CARD_HEIGHT / 2
        else
            self.x = self.parent.x
            self.y = self.parent.y + 20
        end
    end

    if love.mouse.wasButtonPressed(1) and not self.hidden then
        local x, y = love.mouse.getPosition()

        -- confine Y bounds checking based on parent; smaller hit box
        -- for when cards are behind other cards
        local yBounds = CARD_HEIGHT
        if self.child ~= nil then
            yBounds = 20
        end

        if x >= self.x and x <= self.x + CARD_WIDTH and
           y >= self.y and y <= self.y + yBounds then

            -- ensure we're not already picking up a card
            if not gameBoard.cardPickedUp then
                 -- remove the old parent relationship of topmost picked up card 
                 -- move pickedup card & children from tableau and place in pickedupcards pile
                 gameBoard.cardPickedUp = true
                 self:removeParentLink()
                 self:pickUp(tableau, gameBoard.pickedUpCards)
                 gameBoard.oldParent = tableau
                 
            elseif self.pickedUp then
                --check if picked cards are within bounds of another tableau and store the final tableau  
                local tempTableau = self:checkBounds(x, y, gameBoard.tableaus, gameBoard)
                
                -- If pickedUp cards have moved from one tableau to another, then reveal the bottomcard of old tableau 
                if tempTableau ~= gameBoard.oldParent and #gameBoard.oldParent > 0 then 
                    gameBoard.oldParent[#gameBoard.oldParent].hidden = false
                end
                gameBoard.cardPickedUp = false
                gameBoard.oldParent = nil
            end
        end
        
    --right click for movement to win Pile    
    elseif love.mouse.wasButtonPressed(2) then
        local x, y = love.mouse.getPosition()
        
        --checkbounds AND if picked up card has no children     
        if x >= self.x and x <= self.x + CARD_WIDTH and
           y >= self.y and y <= self.y + CARD_HEIGHT and 
           self.child == nil then
           if gameBoard.winPile:addCard(self) then
                table.remove(tableau, #tableau)       
           end
        end
    end
end

function Card:render(x, y)
    if self.hidden then
        love.graphics.draw(gTextures['card-back'], 
            self.x, self.y)
    else
        love.graphics.draw(gTextures['cards'], gCardQuads[self.suit][self.face], 
            self.x, self.y)
    end
end

--[[check if the current card and check card are in the order given by faceOrder & suitOrder
    faceOrder can be "ascending" or "descending"; suitOrder can be "same" or "opposite"  
    used while moving cards between tableaus and to win Pile
  ]] 
function Card:isOrdered(checkCard, faceOrder, suitOrder) 
    local faceCompared, suitCompared
    faceCompared = (faceOrder == "ascending") and (checkCard.face == self.face + 1) or (checkCard.face == self.face - 1)
    
    if suitOrder == "same" then
       suitCompared = (checkCard.suit == self.suit)
    else
        if self.suit == CLUBS or self.suit == SPADES then
            suitCompared = (checkCard.suit == HEARTS or checkCard.suit == DIAMONDS)
        else
            suitCompared = (checkCard.suit == CLUBS or checkCard.suit == SPADES)
        end
    end
    
    return (faceCompared and suitCompared)
end  
