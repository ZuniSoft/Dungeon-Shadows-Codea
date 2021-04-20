Floor = class()

function Floor:init()
    -- params
    self.dialog = Dialog(100, 400, "Go down a level?")
    self.dialog.hasCancel = true
    self.showDialog = false
    self.tiles = {}
    self.roomCoords = {}
    self.ox = 0
    self.oy = 0
    self.stairsX = 0
    self.stairsY = 0
    self.arrowDist = 0
    
    for y = 1, 50 do 
        self.tiles[y] = {}
        for x = 1, 50 do
            self.tiles[y][x] = "0"
        end
    end
    -- add some rooms, tunnels, floor grids, and walls
    numRooms = math.random(floorNum) + 5
    for i= 1, numRooms do
        self:addRoom(i)
    end
    for i= 1, numRooms do
        self:carveTunnel(i)
    end
    self:addWalls()
    -- floor grid
    cnt = 0
    while cnt < 5 + floorNum do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" then
            self.tiles[y][x] = "g"
            cnt = cnt + 1
        end
    end
    -- floor skeleton
    cnt = 0
    while cnt < 3 + floorNum do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" then
            s = math.random(2)
            self.tiles[y][x] = "b" .. s
            cnt = cnt + 1
        end
    end
    -- keys
    cnt = 0
    while cnt < 2 do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" then
            self.tiles[y][x] = "x"
            cnt = cnt + 1
        end
    end
    -- potions
    cnt = 0
    while cnt < 2 + floorNum do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" then
            local potype = math.random(22)
            if potype == 1 then self.tiles[y][x] = "h" end -- health
            if potype == 11 then self.tiles[y][x] = "s" end -- strength
            if potype == 22 then self.tiles[y][x] = "e" end -- experience
            cnt = cnt + 1
        end
    end
    -- trap door
    found = false
    while not found do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" and
        self.tiles[y + 1][x + 1] == "-" and self.tiles[y - 1][x - 1] == "-" then
            self.tiles[y][x] = "X"
            found = true
        end
    end
    -- chest
    found = false
    while not found do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" and
        self.tiles[y + 1][x + 1] == "-" and self.tiles[y - 1][x - 1] == "-" then
            self.tiles[y][x] = "c"
            found = true
        end
    end
    -- dragon eggs
    found = false
    while not found do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" and
        self.tiles[y + 1][x + 1] == "-" and self.tiles[y - 1][x - 1] == "-" then
            self.tiles[y][x] = "E"
            found = true
        end
    end
    -- jar
    found = false
    while not found do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" and
        self.tiles[y + 1][x + 1] == "-" and self.tiles[y - 1][x - 1] == "-" then
            self.tiles[y][x] = "J"
            found = true
        end
    end
    -- rocks
    found = false
    while not found do
        x = math.random(50)
        y = math.random(50)
        if self.tiles[y][x] == "-" and self.tiles[y - 1][x] == "-" and
        self.tiles[y + 1][x + 1] == "-" and self.tiles[y - 1][x - 1] == "-" then
            self.tiles[y][x] = "R"
            found = true
        end
    end
    -- monsters
    monsters = nil
    monsters = {}
    for i = 1, 1 + floorNum do
        m = Monster(floorNum, self)
        table.insert(monsters, m)
    end
end

function Floor:addRoom(n)
    -- attempt to create a random room
    tries = 0
    while tries < 50 do
        w = math.random(6) + 1
        h = math.random(6) + 1
        x = math.random(49 - w)
        y = math.random(49 - h)
        if self.tiles[y][x] == "0" and self.tiles[y][x + w] == "0" and
            self.tiles[y + h][x] == "0" and self.tiles[y + h][x + w] == "0" and
            self.tiles[y + (h // 2) ][x + (w // 2)] == "0" 
            then
            for rx = x, x + w do
                for ry = y, y + h do
                    if rx > 2 and rx < 49 and ry > 2 and ry < 49 then 
                        self.tiles[ry][rx] = "-"
                    end
                end
            end 
            self.roomCoords[n] = {x + math.random(w), y + math.random(h)}
            return
        end
        tries = tries + 1
    end
end

function Floor:carveTunnel(n)
    for i, r in ipairs(self.roomCoords) do
        r2 = nil
        if i < #self.roomCoords then 
            r2 = self.roomCoords[i + 1]
        else
            r2 = self.roomCoords[1]
        end
        sx = r[1]
        sy = r[2]
        ex = r2[1]
        ey = r2[2]
        
        -- draw a horizontal tunnel
        if ex < sx then
            for x = ex, sx do 
                self.tiles[sy][x] = "-"
            end
        else
            for x = sx, ex do 
                self.tiles[sy][x] = "-"
            end
        end
        
        -- draw a vertical tunnel
        if ey < sy then
            for y = ey, sy do 
                self.tiles[y][ex] = "-"
            end
        else
            for y = sy, ey do 
                self.tiles[y][ex] = "-"
            end
        end
        
    end
end

function Floor:addWalls()
    -- add some walls
    for y = 2, 49 do
        for x = 2, 49 do
            if self.tiles[y][x] == "0" and (self.tiles[y][x + 1] == "-" or
            self.tiles[y + 1][x] == "-" or self.tiles[y + 1][x + 1] == "-" or
            self.tiles[y][x - 1] == "-" or self.tiles[y - 1][x] == "-" or
            self.tiles[y - 1][x - 1] == "-") then
                self.tiles[y][x] = "w"
            end
        end
    end
end

function Floor:draw(cx, cy)
    -- move to keep character more centered
    cols = WIDTH // 48
    rows = (HEIGHT - 200) // 48
    
    ox = cx - cols // 2
    oy = cy - rows // 2
    
    if ox < 0 then ox = 0 elseif ox > 50 - cols then ox = 50 - cols end
    if oy < 0 then oy = 0 elseif oy > 51 - rows then oy = 51 - rows end
    
    self.ox = ox
    self.oy = oy
    
    -- draw the section of floor around the cx, cy localtion
    my = 50
    mx = 50
    dx = 0
    dy = 200
    
    while self.ox + cols > 50 do
        self.ox = self.ox - 1
    end
    for y= my, self.oy + 1, -1 do 
        for x = 1 + self.ox, mx do 
            noTint()
            dist = math.sqrt((x - cx) * (x- cx) + (y - cy) * (y - cy))
            t = 255 - dist * 40
            tint(t,t,t,255)
            c = self.tiles[y][x]
            local bx, by = screenMap(x, y)
            local cnt = (x // 2) + (y)
            -- empty space
            if c == "-" then
                if math.fmod(cnt, 2) == 0 then
                    tint(t + 15, t + 15, t + 15, 255)
                end
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
            end
            -- floor grid
            if c == "g" then
                if math.fmod(cnt, 2) == 0 then
                    tint(t + 15, t + 15, t + 15, 255)
                end
                sprite(asset.documents.Dungeon_Shadows_assets.Floor_Grid,bx,by + 14,48,48)
            end
            -- floor skeleton
            if c == "b1" or c == "b2"then
                if math.fmod(cnt, 2) == 0 then
                    tint(t + 15, t + 15, t + 15, 255)
                end
                if c == "b1" then
                    sprite(asset.documents.Dungeon_Shadows_assets.Skeleton_1,bx,by + 14,48,48)
                else
                    sprite(asset.documents.Dungeon_Shadows_assets.Skeleton_2,bx,by + 14,48,48)
                end
            end
            -- key
            if c == "x" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Key,bx,by + 16,48,48)
            end
            -- health potion
            if c == "h" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Potion_1,bx,by + 16,32,32)
            end
            -- strength potion
            if c == "s" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Potion_2,bx,by + 16,32,32)
            end
            -- experience potion
            if c == "e" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Potion_3,bx,by + 16,32,32)
            end
            -- trap door
            if c == "X" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Trap_Door_1,bx,by + 16,48,48)
            end
            -- stairs
            if c == "S" then
                tint(0, 0, 0, 255)
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                noTint()
                tint(127, 127, 127, 255)
                sprite(asset.documents.Dungeon_Shadows_assets.Crate_Blue_1,bx,by + 16,48,64)
                noTint()
            end
            -- stone block
            if c == "0" then
                local adj=1
                if math.fmod(x,2)==math.fmod(y,2) then adj=-1 end
                sprite(asset.documents.Dungeon_Shadows_assets.Stone_Block,bx,by + 32,adj*48,96)
            end
            -- wall block
            if c == "w" then
                local adj=1
                if math.fmod(x,2)==math.fmod(y,2) then adj=-1 end
                sprite(asset.documents.Dungeon_Shadows_assets.Wall_Block,bx,by + 32,adj*48,96)
            end
            -- chest closed
            if c == "c" then
                sprite(asset.documents.Dungeon_Shadows_assets.Chest_Closed,bx,by + 16,48,48)
            end
            -- chest open
            if c == "C" then
                sprite(asset.documents.Dungeon_Shadows_assets.Chest_Open,bx,by + 16,48,48)
            end
            -- dragon eggs
            if c == "E" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Dragon_Eggs_1,bx,by + 16,48,48)
            end
            -- jar intact
            if c == "J" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Jar_1,bx,by + 16,48,48)
            end
            -- jar broken
            if c == "j" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
            end
            -- rocks
            if c == "R" then
                sprite(asset.documents.Dungeon_Shadows_assets.Greysand,bx,by,48,80)
                sprite(asset.documents.Dungeon_Shadows_assets.Rocks_1,bx,by + 24,36,36)
            end
        end
    end
    noTint()
    bx, by = screenMap(cx, cy)
    -- spell
    if blastRad > 0 then
        blastRad = blastRad + 1
        noStroke()
        fill(255, 222, 0, 255 - blastRad * 10)
        ellipse(bx, by, blastRad * 15)
        if blastRad > 60 then blastRad = 0 end
    end
    -- bombs
    if bombIsSet then
        b:draw(self.ox, self.oy)
    end
    -- monsters
    for i, m in ipairs(monsters) do
        m:draw(self.ox, self.oy)
    end
    -- treasures
    for i, t in ipairs(treasures) do
        t:draw(self.ox, self.oy)
    end
    -- arrows
    processArrows()
    for i,a in ipairs(arrows) do
        a:draw(self.ox, self.oy)
    end
    -- player health
    if health < 1 then 
        sprite()
    else
        tint(hitTint)
        sprite(avatars[avatarNum],bx,by + 26,cw,ch)
        if weapon > 1 then
            local adjx
            local adjy
            if cw < 0 then
                adjx = 8
                adjy = 26
            else
                adjx = 9
                adjy = 28
            end
            sprite(asset.documents.Dungeon_Shadows_assets.Sword,bx + adjx,by + adjy,9,32)
        end
        if sheildNum > 0 then
            pushMatrix()
            translate(bx - 14, by + 16)
            sprite(shields[sheildNum], 1, 2, 24, 24)
            popMatrix()
        end
    end
    noTint()
    hitTint = color(255, 255, 255, 255)
    if self.showDialog then self.dialog:draw() end
end

function Floor:check(x, y)
    c = self.tiles[y][x]
    -- empty space
    if c == "-" then return true end
    -- floor grid
    if c == "g" then return true end
    -- floor skeleton
    if c == "b1" or c == "b2" then return true end
    -- keys
    if c == "x" then 
        SFX(asset.documents.Dungeon_Shadows_assets.Bell_2)
        keys = keys + 1
        self.tiles[y][x] = "-"
        return true 
    end
    -- health potion
    if c == "h" then
        SFX(asset.documents.Dungeon_Shadows_assets.Drink_2)
        fm = FloatingMessage("+ 1 health", screenMap(x, y))
        fm.y = fm.y + 25
        fm.tint = color(255, 0, 0, 255)
        table.insert(messages, fm)
        health = health + 1
        self.tiles[y][x] = "-"
        return true
    end
    -- strength potion
    if c == "s" then
        SFX(asset.documents.Dungeon_Shadows_assets.Drink_2)
        fm = FloatingMessage("+ 1 strength", screenMap(x, y))
        fm.y = fm.y + 25
        fm.tint = color(0, 0, 255, 255)
        table.insert(messages, fm)
        strength = strength + 1
        self.tiles[y][x] = "-"
        return true
    end
    -- experience potion
    if c == "e" then
        SFX(asset.documents.Dungeon_Shadows_assets.Drink_2)
        fm = FloatingMessage("+ 1 experience", screenMap(x, y))
        fm.y = fm.y + 25
        fm.tint = color(243, 173, 12, 255)
        table.insert(messages, fm)
        exp = exp + 1
        self.tiles[y][x] = "-"
        return true
    end
    -- trap door
    if c == "X" and keys > 0 then 
        SFX(asset.documents.Dungeon_Shadows_assets.Door_Close)
        keys = keys - 1
        self.tiles[y][x] = "S"
    end
    -- stairs
    if c == "S" then 
        self.showDialog = true
    end
    -- chest opening
    if c == "c" and keys > 0 then 
        SFX(asset.documents.Dungeon_Shadows_assets.Door_Open)
        keys = keys - 1
        self.tiles[y][x] = "C"
        t = Treasure(x, y)
        table.insert(treasures, t)
        -- reward routine
    end
    -- chest collect treasure
    if c == "C" then 
        for i, t in ipairs(treasures) do
            if t.x == x and t.y == y then
                t:collect()
                table.remove(treasures, i)
            end
        end
    end
    -- jar intact
    if c == "J" then
        SFX(asset.documents.Dungeon_Shadows_assets.Bottle_Break_2)
        self.tiles[y][x] = "j"
        t = Treasure(x, y)
        table.insert(treasures, t)
        -- reward routine
    end
    -- jar broken
    if c == "j" then
        for i, t in ipairs(treasures) do
            if t.x == x and t.y == y then
                self.tiles[y][x] = "-"
                t:collect()
                table.remove(treasures, i)
            end
        end
    end
    return false
end

function Floor:touched(touch)
    local i
    i = self.dialog:touched(touch)
    if i == 1 then
        return true
    end
    if i == 2 then
        self.showDialog = false
    end
    return false
end
