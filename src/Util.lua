--[[
    Utility Functions
]]

function GenerateQuads(texture, textureWidth, textureHeight)
    local quadTable = {}

    for x = 0, CARD_WIDTH * (CARD_SHEET_WIDE - 1), CARD_WIDTH do
        for y = 0, CARD_HEIGHT * (CARD_SHEET_TALL - 1), CARD_HEIGHT do
            table.insert(quadTable, love.graphics.newQuad(x, y, 
                CARD_WIDTH, CARD_HEIGHT, texture:getDimensions()))
        end 
    end

    return quadTable
end

--[[
    Given a "newTable", allocate to it from startIndex to endIndex the elements
    located in "mainTable".
]]
function AllocateSubtable(newTable, mainTable, startIndex, endIndex)
    for index = startIndex, endIndex do
        table.insert(newTable, mainTable[index])
    end
end

--[[
    Recursive table-printing function.
]]
function Dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. Dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

--[[
    Resort the quads of a suited table.
]]
function ResortCards(oldCards)
    local newCards = {}

    table.insert(newCards, oldCards[POS_A])
    table.insert(newCards, oldCards[POS_2])
    table.insert(newCards, oldCards[POS_3])
    table.insert(newCards, oldCards[POS_4])
    table.insert(newCards, oldCards[POS_5])
    table.insert(newCards, oldCards[POS_6])
    table.insert(newCards, oldCards[POS_7])
    table.insert(newCards, oldCards[POS_8])
    table.insert(newCards, oldCards[POS_9])
    table.insert(newCards, oldCards[POS_10])
    table.insert(newCards, oldCards[POS_J])
    table.insert(newCards, oldCards[POS_Q])
    table.insert(newCards, oldCards[POS_K])

    return newCards
end