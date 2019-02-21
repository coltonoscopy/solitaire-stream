--[[
    Solitaire

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'src/Dependencies'

local queenOfHearts = Card(QUEEN, HEARTS)

function love.load()
    love.window.setTitle('Solitaire')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

end

function love.draw()
    queenOfHearts:render(0, 0)
end