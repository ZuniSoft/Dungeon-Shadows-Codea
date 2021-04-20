Monster = class()

montypes = {}
montypes[1] = {"Green Meanie", 1, 1, true,
asset.documents.Dungeon_Shadows_assets.Green_Fluff_1, asset.documents.Dungeon_Shadows_assets.Green_Fluff_2}
montypes[2] = {"Flying Blob", 2, 1, true,
asset.documents.Dungeon_Shadows_assets.Blob_Bat_1, asset.documents.Dungeon_Shadows_assets.Blob_Bat_2}
montypes[3] = {"Green Grump", 2, 2, true,
asset.documents.Dungeon_Shadows_assets.Green_Grump_1, asset.documents.Dungeon_Shadows_assets.Green_Grump_2}
montypes[4] = {"Yellow Meanie", 2, 3, true,
asset.documents.Dungeon_Shadows_assets.Yellow_Fluff_1, asset.documents.Dungeon_Shadows_assets.Yellow_Fluff_2}
montypes[5] = {"Blue Rhino", 3, 3, true,
asset.documents.Dungeon_Shadows_assets.Blue_Rhino_1, asset.documents.Dungeon_Shadows_assets.Blue_Rhino_2}
montypes[6] = {"Gray Rhino", 3, 3, true,
asset.documents.Dungeon_Shadows_assets.Gray_Rhino_1, asset.documents.Dungeon_Shadows_assets.Gray_Rhino_2}
montypes[7] = {"Purple Demon", 3, 4, true,
asset.documents.Dungeon_Shadows_assets.Purple_Demon_1, asset.documents.Dungeon_Shadows_assets.Purple_Demon_2}
montypes[8] = {"Green Dragon", 4, 4, true,
asset.documents.Dungeon_Shadows_assets.Green_Dragon_1, asset.documents.Dungeon_Shadows_assets.Green_Dragon_2}

function Monster:init(n, f)
    local m = montypes[math.random(n)]
    self.name = m[1]
    self.health = m[2] + 1
    self.strength = m[3]
    self.aggressive = m[4]
    self.clock = ElapsedTime
    self.x = 0
    self.y = 0
    self.dx = 0
    self.dy = 0
    self.image1 = m[5]
    self.image2 = m[6]
    sprite()
    found = false
    while not found do
        x = math.random(50)
        y = math.random(50)
        if f.tiles[y][x] == "-" then
            self.x = x
            self.y = y
            found = true
        end
    end
end

function Monster:move()
    if self.health < 1 then return end
    local d
    if ElapsedTime - self.clock < 0.5 then return end
    self.clock = ElapsedTime
    -- a second has passed, monster can move
    dist = math.sqrt((self.x - cx) * (self.x- cx) + (self.y - cy) * (self.y - cy))
    if self.aggressive and dist < 10 then
        d = math.random(100)
        if d > 50 then
            -- try to advance on player vertically
            if cy > self.y then self.dy = 1 end
            if cy < self.y then self.dy = -1 end
            if self:check(self.x, self.y + self.dy) then
                self.y = self.y + self.dy 
            end
        else
            -- try to advance horizontally
            if cx > self.x then self.dx = 1 end
            if cx < self.x then self.dx = -1 end
            if self:check(self.x + self.dx, self.y) then
                self.x = self.x + self.dx
            end
        end
    end
end

function Monster:draw(ox, oy)
    local width = 48
    local height = 48
    dist = math.sqrt((self.x - cx) * (self.x- cx) + (self.y - cy) * (self.y - cy))
    if dist > 7 then return end
    local x, y = screenMap(self.x, self.y)
    y = y + 32
    if self.health < 1 then
        sprite()
        return
    end
    -- flip sprite if going in a neg dir
    if self.dx == -1 then
        width = width * -1
    end   
    if ElapsedTime - self.clock > .2 then
        sprite(self.image1, x, y, width, height)
    else
        sprite(self.image2, x, y, width, height)
    end
    noTint()
end

function Monster:drawCard()
    if self.health > 0 then
        if WIDTH < 700 then return end
        pushStyle()
        dist = math.sqrt((self.x - cx) * (self.x- cx) + (self.y - cy) * (self.y - cy))
        if dist > 3 then return end
        if self.health > 0 then
            monsterClose = true
        end
        fill(195, 192, 192, 255)
        rect(WIDTH - 460, 20, 200, 200)
        noFill()
        strokeWidth(2)
        stroke(0, 0, 0, 255)
        rect(WIDTH - 450, 30, 180, 180)
        fill(32, 31, 114, 255)
        textMode(CENTER)
        text(self.name, WIDTH - 360, 190)
        textMode(CORNER)
        sprite(self.image1, WIDTH - 360, 145, 64, 64)
        noTint()
        fill(0, 0, 0, 255)
        text("Health", WIDTH - 440, 40)
        text("Strength", WIDTH - 440, 70)
        for i = 1, self.health do
            sprite(asset.documents.Dungeon_Shadows_assets.Heart,WIDTH - 380 + i * 20,50,22,28)
        end
        for i = 1, strength do
            sprite(asset.documents.Dungeon_Shadows_assets.Sword,WIDTH - 380 + i * 22,85,12,32)
        end
    end
end

function Monster:health()
    return self.health
end

function Monster:check(x, y)
    if x == cx and y == cy and health > 0 then
        -- hit character
        --if playSFX then sound(SOUND_EXPLODE, 10272) end
        if math.random(6) <= sheildNum then
            SFX(asset.documents.Dungeon_Shadows_assets.Sword_Hit_2)
            fm = FloatingMessage("Blocked", screenMap(cx, cy))
            fm.tint = color(0, 138, 255, 255)
            table.insert(messages, fm)
            return false
        end
        local s = math.random(m.strength)
        fm = FloatingMessage(s, screenMap(cx, cy))
        fm.tint = color(255, 0, 18, 255)
        table.insert(messages, fm)
        health = health - s
        hitTint = color(255, 0, 0, 255)
        return false
    end
    if floor.tiles[y][x] == "-" then return true end
    return false
end
