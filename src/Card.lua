--[[
    Card Class
]]

Card = Class{}

function Card:init(face, suit, x, y)
    self.face = face
    self.suit = suit
    self.hidden = true
    self.pickedUp = false
    self.x = x
    self.y = y
end

function Card:update(dt)
    if love.mouse.wasButtonPressed(1) then
        local x, y = love.mouse.getPosition()

        if x >= self.x and x <= self.x + CARD_WIDTH and
           y >= self.y and y <= self.y + CARD_HEIGHT then
           self.pickedUp = not self.pickedUp
        end
    end

    if self.pickedUp then
        self.x, self.y = love.mouse.getPosition()
        self.x = self.x - CARD_WIDTH / 2
        self.y = self.y - CARD_HEIGHT / 2
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