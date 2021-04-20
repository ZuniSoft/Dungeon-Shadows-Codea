Frame = class()

function Frame:init(left, bottom, right, top)
    -- you can accept and set parameters here
    self.left = left
    self.right = right
    self.bottom = bottom
    self.top = top
end

function Frame:overlaps(f)
    if self.left > f.right or self.right < f.left or
    self.bottom > f.top or self.top < f.bottom then
        return false
    else
        return true
    end
end