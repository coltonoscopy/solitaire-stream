--[[
    Solitaire

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'src/Dependencies'

math.randomseed(os.time())

local gameBoard = GameBoard()

function love.load()
    love.window.setTitle('Solitaire')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasButtonPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    gameBoard:update(dt)
    
    love.mouse.buttonsPressed = {}
end

function love.draw()
    gameBoard:render()
end