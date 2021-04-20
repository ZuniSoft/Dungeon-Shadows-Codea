FloatingMessage = class()

function FloatingMessage:init(t, x, y)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.tint = color(201, 201, 201, 255)
    self.text = t
    self.timer = 60
end

function FloatingMessage:draw()
    pushStyle()
    self.y = self.y + 2
    fill(self.tint)
    self.tint.a = self.tint.a - 3
    fontSize(24)
    text(self.text, self.x, self.y) 
    popStyle()
end
