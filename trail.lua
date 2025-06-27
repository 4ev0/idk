_G.trail = Class:extend()

function trail:new(type, x, y, opts)
    self.dead = false
    local xOffset,yOffset = 2.5, 2.5
    self.x, self.y = x + randomf(-xOffset, xOffset), y + randomf(-yOffset, yOffset)
    self.type = type
    self:initOpts(opts)

    timer:tween(0.3, self, {r = 0}, "linear", function ()
        self.dead = true
    end)
    timer:tween(0.3, self, {y = y - math.random(5,15)}, "linear")
    self.r = self.r + randomf(-2.5, 2.5)
end

function trail:update(dt)
    
end

function trail:draw()
    -- love.graphics.setColor(0,0,0)
    pushRotate(self.x, self.y, self.angle)
    love.graphics.ellipse("fill", self.x, self.y, self.xm * self.r, self.ym * self.r)
    love.graphics.pop()
end

return trail