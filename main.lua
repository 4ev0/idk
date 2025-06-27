_G.Class = require "lib.classic"
_G.Timer = require "lib.timer"
_G.Vector = require "lib.vector"
require "gameObject"
require "trail"

function love.load()
    math.randomseed(os.time())
    love.window.setMode(1280,720)
    love.graphics.setBackgroundColor(0,0.5,0)
    _G.aaa = 0 
    _G.extraLinesToDraw = {}
    _G.gameObjects = {}
    _G.mainCanvas = love.graphics.newCanvas(360, 180)
    _G.gameObjectCanvas = love.graphics.newCanvas(360, 180)
    _G.trailCanvas = love.graphics.newCanvas(360, 180)
    _G.timer = Timer.new()
    _G.object = createGameObject("gameObject",160,90, {state = "idle",})
    
    love.graphics.setLineStyle("rough")
    mainCanvas:setFilter("nearest", "nearest")
    gameObjectCanvas:setFilter("nearest", "nearest")
    trailCanvas:setFilter("nearest", "nearest")
    randomLines()
end

function love.update(dt)
    timer:update(dt)

    for i = #gameObjects, 1, -1 
    do
        local object = gameObjects[i]
        object:update(dt)
        removeDeadObjects(object, i)
    end
end

function love.draw()
    love.graphics.setCanvas(trailCanvas)
    love.graphics.clear()
    -- love.graphics.setColor(1,0.5,0.2, randomf(0.5, 1))
    -- love.graphics.setBlendMode("multiply", "premultiplied")

    drawObject("trail")
    

    drawLines()
    love.graphics.setBlendMode("alpha")
    
    -- love.graphics.setColor(1,0,1)
    love.graphics.setCanvas(gameObjectCanvas)
    love.graphics.clear()
    drawObject("gameObject")

    love.graphics.setCanvas(mainCanvas)
    love.graphics.clear()
    love.graphics.draw(trailCanvas, 0, 0)
    love.graphics.draw(gameObjectCanvas, 0, 0)
    love.graphics.setCanvas()
    love.graphics.draw(mainCanvas, 0, 0, 0, 4, 4)

end

function createGameObject(type, x, y, opts)
    local object = _G[type](type, x, y, opts)
    table.insert(gameObjects, object)
    return object
end

function love.mousepressed(x, y, button)
    
    if button == 1
    then
        local switch = {
            ["idle"] = function ()
                object.t = 0
                object.state = "follow"
            end,
            ["follow"] = function ()
                object.xIdlePosition, object.yIdlePosition = object.x, object.y
                object.state = "idle"                
            end
        }
        local switchState = switch[object.state]
        
        if switchState 
        then
            switchState()
            love.mouse.setVisible(not love.mouse.isVisible())
        end

    end
end

function randomLines()
    timer:every(0.01, function ()

    for i = -10, 370, 2
    do

        if math.random(10) >= 2
        then
            extraLinesToDraw[i] = true
        else
            extraLinesToDraw[i] = false
        end

    end

    end)

end

function removeDeadObjects(object, pos)

    if object.dead == true
    then
        table.remove(gameObjects, pos)
    end

end

function drawObject(name)
    
    for _, object in ipairs(gameObjects)
    do

        if object.type == name
        then
            object:draw()    
        end
        
    end


end

function drawLines()
    pushRotate(180, 90, object:snapAngle() + math.pi / 2)
    
    -- love.graphics.setBlendMode("subtract")
    

    for i = -10, 370, 2
    do
    
        if extraLinesToDraw[i]
        then
            love.graphics.line(i, -100, i, 300)            
        else
            love.graphics.line(i+1, -100, i+1, 300)
        end

    end

    love.graphics.pop()
end

function randomf(min, max)

    if min > max
    then
        min, max = max, min
    end
    
    return (love.math.random() * (max - min) + min)
end

function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function map(oldValue, oldMin, oldMax, newMin, newMax)
    local newMin = newMin or 0
    local newMax = newMax or 1
    local newValue = 0
    local oldRange = oldMax - oldMin
    
    if oldRange == 0
    then
        newValue = newMin
    else
        local newRange = newMax - newMin
        newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin
    end
    return newValue
end

function Class:initOpts(opts)
    local opts = opts or {}
    
    for k, v in pairs(opts)
    do
        self[k] = v        
    end

end