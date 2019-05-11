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
    self.x = self.parent.x
    self.y = self.parent.y + 20  
  
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
        if #tableaus[i] > 0 then 
            bottomCard = tableaus[i][#tableaus[i]]
            if posX >= bottomCard.x and posX <= bottomCard.x + CARD_WIDTH and
                posY >= bottomCard.y and posY <= bottomCard.y + CARD_HEIGHT then
                newTableau = tableaus[i]           
                break  
            end
        end
    end
    
    --final position is not within bounds of any tableau,  
    --move pickedUp cards to its old tableau/pile
    if newTableau == nil then
        newTableau = gameBoard.oldParent
        bottomCard = newTableau[#newTableau]
    end
    
    --placedown all the pickedup cards starting from the topmost card
    bottomCard.child = gameBoard.pickedUpCards[#gameBoard.pickedUpCards]
    bottomCard.child.parent = bottomCard  
    bottomCard.child:show("Picked up card top:")
    bottomCard.child:placeDown(newTableau, gameBoard.pickedUpCards)
    
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
    elseif love.mouse.wasButtonPressed(2) and self.hidden then
        local x, y = love.mouse.getPosition()

        if x >= self.x and x <= self.x + CARD_WIDTH and
            y >= self.y and y <= self.y + CARD_HEIGHT then
            self.hidden = false
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
