--[[ Winning Pile Class
     Contains the 4 winning piles, one for each suit of cards
  ]]--
  
WinPile = Class{}

function WinPile:init()
    --initialize the 4 winning piles with empty list
    self.pile = {}
    for i = 1, 4 do
        table.insert(self.pile, {})
    end     
end

--Returns true if the card can be added to a winning pile; false if card can't be moved
function WinPile:addCard(newCard)
    --if the card is an Ace, then add it to a new Pile
    local position = 0
    if newCard.face == ACE then
       for i = 1, 4 do
           if #self.pile[i] == 0 then
              position = i
              break
           end
       end
    else
    --check if any of the winning piles are of same suit and exactly 1 lower in face to selected card
        for i = 1, 4 do
            if #self.pile[i] > 0 and newCard:isOrdered(self.pile[i][#self.pile[i]], "descending", "same") then
               position = i       
               break
            end
        end
    end
    if position > 0 then
        table.insert(self.pile[position], newCard)
        if newCard.parent then
            newCard.parent.hidden = false
        end
        newCard:removeParentLink()
        newCard.x = 10 + 80 * (position - 1)
        newCard.y = 50
        return true
    else
        return false
    end
end

function WinPile:render()
    for i = 1, 4 do
        if #self.pile[i] > 0 then
           self.pile[i][#self.pile[i]]:render()
        end
    end
end
