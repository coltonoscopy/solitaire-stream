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
function Card:pickUp(tableau, gameBoard)
    self.pickedUp = true

    if tableau == nil then
        return
    end

    table.insert(gameBoard.pickedUpCards, table.remove(tableau, #tableau))

    if self.child then
        self.child:pickUp()
    end
end

function Card:placeDown(gameBoard)

    -- card by itself
    if self.child == nil and self.parent == nil then
        
        -- check to see if placing in tableau OR winning pile
    
    -- otherwise, only worry about placing a top-level card
    -- place ONLY in tableaus, not winning piles
    elseif self.child ~= nil and self.parent == nil then
        
    end
end

function Card:update(dt, gameBoard, tableau)

    -- update card based on its parent
    if self.pickedUp then
        if self.parent == nil then
            self.x, self.y = love.mouse.getPosition()
            self.x = self.x - CARD_WIDTH / 2
            self.y = self.y - CARD_HEIGHT / 2
        else
            self.x = parent.x
            self.y = parent.y + 30
        end
    end

    if love.mouse.wasButtonPressed(1) and not self.hidden then
        local x, y = love.mouse.getPosition()

        -- confine Y bounds checking based on parenting; smaller hit box
        -- for when cards are behind other cards
        local yBounds = CARD_HEIGHT
        if self.child ~= nil then
            yBounds = 30
        end

        if x >= self.x and x <= self.x + CARD_WIDTH and
           y >= self.y and y <= self.y + yBounds then

            -- ensure we're not already picking up a card
            if not gameBoard.cardPickedUp then
                
                if self.parent == nil then
                    self:pickUp(tableau, gameBoard)
                    gameBoard.cardPickedUp = true
                end

            elseif self.pickedUp then

                self.pickedUp = false
                gameBoard.cardPickedUp = false

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