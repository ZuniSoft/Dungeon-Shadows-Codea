Arrow = class()

function Arrow:init(ax, ay, cx, cy)
    -- you can accept and set parameters here
    self.x, self.y = screenMap(cx, cy)
    self.ax = ax
    self.ay = ay
    self.cx = cx
    self.cy = cy
end

function Arrow:draw(ox, oy)
    if self.ax == 1 then
        sprite(asset.documents.Dungeon_Shadows_assets.Arrow_Right, self.x + 20, self.y + 20, 40, 10)
    end
    if self.ax == -1 then
        sprite(asset.documents.Dungeon_Shadows_assets.Arrow_Left, self.x - 20, self.y + 20, 40, 10)
    end
    if self.ay == 1 then
        sprite(asset.documents.Dungeon_Shadows_assets.Arrow_Up, self.x, self.y + 50, 10, 40)
    end
    if self.ay == -1 then
        sprite(asset.documents.Dungeon_Shadows_assets.Arrow_Down, self.x, self.y + 5, 10, 40)
    end
end

function Arrow:move()
    if self.ax == 1 then
        self.x = self.x + 4
    end
    if self.ax == -1 then
        self.x = self.x - 4
    end
    if self.ay == 1 then
        self.y = self.y + 4
    end
    if self.ay == -1 then
        self.y = self.y - 4
    end
end

function Arrow:hitWall()
    -- find first wall in arrow line of sight
    found = false
    local x = self.cx
    local y = self.cy
    while not found do
        x = x + self.ax
        y = y + self.ay
        if floor.tiles[y][x] == "w" then
            found = true
        end
    end
    -- check if wall hit
    local mx, my = screenMap(x, y)
    local rectWall = Frame(mx, my, mx + 48, my + 48)
    local rectArrow = Frame(self.x, self.y, self.x + 48, self.y + 48)
    if rectArrow:overlaps(rectWall) then
        return true
    end
    return false
end

function Arrow:hitMonster()
    local rectArrow
    local rectMonster
    -- check if monster hit
    for i, m in ipairs(monsters) do
        local mx, my = screenMap(m.x, m.y)
        rectMonster = Frame(mx, my, mx + 48, my + 48)
        rectArrow = Frame(self.x, self.y, self.x + 48, self.y + 48)
        if rectArrow:overlaps(rectMonster) and m.health > 0 then
            m.health = m.health - (strength * weapon)
            fm = FloatingMessage(strength * weapon, screenMap(m.x, m.y))
            fm.tint = color(0, 255, 3, 255)
            table.insert(messages, fm)
            oldExp = exp
            if m.health < 1 then
                exp = exp + m.strength * 2
                table.remove(monsters, i)
            end
            if checkLevelUp(oldExp, exp) then
                strength = strength + 1
                fm = FloatingMessage("Level Up!", screenMap(self.cx, self.cy))
                fm.tint = color(223, 173, 216, 255)
                table.insert(messages, fm)
            end
            return true
        end
    end
    return false
end
