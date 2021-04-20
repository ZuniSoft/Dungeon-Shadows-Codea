Treasure = class()

function Treasure:init(x, y)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.t = math.random(6)
end

function Treasure:draw(ox, oy)
    dist = math.sqrt((self.x - cx) * (self.x- cx) + (self.y - cy) * (self.y - cy))
    if dist > 7 then return end
    local x, y = screenMap(self.x, self.y)
    noTint()
    if self.t == 1 then
        sprite(asset.documents.Dungeon_Shadows_assets.Treasure,x,y + 24)
    end
    if self.t == 2 then
        if floorNum < 1 then
            tint(127, 127, 127, 255)
        end
        sprite(asset.documents.Dungeon_Shadows_assets.Sword,x,y + 22)
    end
    if self.t == 3 then
        sprite(asset.documents.Dungeon_Shadows_assets.Heart_Glow,x,y + 28)
    end
    if self.t == 4 then
        sprite(asset.documents.Dungeon_Shadows_assets.Gem_Orange,x,y + 28,24,28)
    end
    if self.t == 5 then
        sprite(asset.documents.Dungeon_Shadows_assets.Bomb_1,x,y + 28,32,32)
    end
    if self.t == 6 then
        sprite(asset.documents.Dungeon_Shadows_assets.Arrow_Up,x,y + 20,10,40)
    end
end

function Treasure:collect()
    if self.t == 1 then
        -- coins
        local g = math.random(59 * floorNum) 
        gold = gold + g
        SFX(asset.documents.Dungeon_Shadows_assets.Bottle_Break_1)
        fm = FloatingMessage("+" .. g .. " gold", screenMap(self.x, self.y))
        saveLocalData("GOLD", gold)
        fm.y = fm.y + 25 
        fm.tint = color(224, 192, 132, 255)
        table.insert(messages, fm)
    end
    if self.t == 2 then
        -- weapon
        weapon = 1 + math.random(floorNum) 
        SFX(asset.documents.Dungeon_Shadows_assets.Sword_Hit_4)
        fm = FloatingMessage("+" .. weapon .. " sword",
            screenMap(self.x, self.y))
        fm.y = fm.y + 25 
        fm.x = fm.x - 25 
        fm.tint = color(131, 203, 224, 255)
        table.insert(messages, fm)
    end
    if self.t == 3 then
        -- heart
        health = health + 1 
        SFX(asset.documents.Dungeon_Shadows_assets.Defensive_Cast_1)
        fm = FloatingMessage("+ 1 health", screenMap(self.x, self.y))
        fm.y = fm.y + 25 
        fm.tint = color(223, 170, 186, 255)
        table.insert(messages, fm)
    end
    if self.t == 4 then
        -- gem
        gems = gems + 1 
        SFX(asset.documents.Dungeon_Shadows_assets.Defensive_Cast_4)
        fm = FloatingMessage("+ 1 gem", screenMap(self.x, self.y))
        saveLocalData("GEMS", gems)
        fm.y = fm.y + 25 
        fm.tint = color(223, 170, 186, 255)
        table.insert(messages, fm)
    end
    if self.t == 5 then
        -- bomb
        bombs = bombs + 1
        SFX(asset.documents.Dungeon_Shadows_assets.Pick_Up)
        fm = FloatingMessage("+ 1 bomb", screenMap(self.x, self.y))
        saveLocalData("BOMBS", bombs)
        fm.y = fm.y + 25
        fm.tint = color(75, 75, 75, 255)
        table.insert(messages, fm)
    end
    if self.t == 6 then
        -- arrows
        arrowCnt = arrowCnt + 10
        SFX(asset.documents.Dungeon_Shadows_assets.Pick_Up)
        fm = FloatingMessage("+ 10 arrrows", screenMap(self.x, self.y))
        saveLocalData("ARROWS", arrowCnt)
        fm.y = fm.y + 25
        fm.tint = color(100, 70, 36, 255)
        table.insert(messages, fm)
    end
end
