_G.gameObject = Class:extend()

function gameObject:new(type, x, y, opts)
    self.x, self.y = x, y
    self.xPrevious, self.yPrevious = x, y
    self.dead = false
    self.type = type
    self.t = 10
    self.xIdlePosition, self.yIdlePosition = x, y
    self:initOpts(opts)

    timer:every(0.01, function ()
        createGameObject("trail", self.x, self.y, {r = 7, xm = self.xm, ym = self.ym, angle = self.angle})
    end)
end

function gameObject:update(dt)
    local x, y = self.xIdlePosition, self.yIdlePosition
    
    if self.state == "follow"
    then
         x, y = love.mouse.getPosition()
         self.x, self.y = x/4, y/4
    elseif self.state == "idle"
    then
        self.x, self.y = x, self:idleFloating(dt)
    end

    self.vmag = Vector(self.x - self.xPrevious, self.y - self.yPrevious):len()
    self.xm = map(self.vmag, 0, 20, 1, 2)
    self.ym = map(self.vmag, 0, 15, 1, 0.25)

    if self.xPrevious ~= self.x or self.yPrevious ~= self.y
    then
        self.angle = math.atan2(self.y - self.yPrevious, self.x - self.xPrevious)    
    end
    
    self.xPrevious, self.yPrevious = self.x, self.y
    
end

function gameObject:draw()
    love.graphics.setColor(1,0,1)
    pushRotate(self.x, self.y, self.angle)
    love.graphics.ellipse("fill", self.x, self.y, self.xm * 8, self.ym * 8)
    love.graphics.pop()
end

function gameObject:snapAngle(angle, stepRad)
    local angle = angle or self.angle
    local stepRad = stepRad or math.pi / 4
    local steps = math.floor((angle + stepRad / 2) / stepRad)
    return steps * stepRad
end

function gameObject:idleFloating(dt)
    self.t = self.t + dt * 2.5 
    return self.yIdlePosition + (math.sin(self.t) * 10)
end

return gameObject

