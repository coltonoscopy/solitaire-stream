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

function WinPile:addCard(newCard)
    --if the card is an Ace, then add it to a new Pile
    local position
    if newCard.face == ACE then
       for i = 1, 4 do
           if #self.pile[i] == 0 then
              position = i
              break
       end
       table.insert(self.pile[position], newCard)
       newCard:removeParentLink()
    
    else
     --check if any of the winning piles are
    end
end
