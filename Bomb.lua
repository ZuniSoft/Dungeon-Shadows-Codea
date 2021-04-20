Bomb = class()

function Bomb:init(x, y)
    -- you can accept and set parameters here
    self.clock = ElapsedTime
    self.x = x
    self.y = y
    self.bombRad = 0
end

function Bomb:draw(ox, oy)
    local x, y = screenMap(self.x, self.y)
    if ElapsedTime - self.clock < 3.0 then
        sprite(asset.documents.Dungeon_Shadows_assets.Bomb_1,x,y + 16,32,32)
    else
        self.bombRad = self.bombRad + 1
        noStroke()
        fill(125, 125, 125, 255 - self.bombRad * 10)
        ellipse(x, y, self.bombRad * 15)
        if self.bombRad > 60 then
            self.bombRad = 0
            bombIsSet = false
        end
    end
end
