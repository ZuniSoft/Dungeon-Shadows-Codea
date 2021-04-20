
----------------------
-- Dungeon Shadows  --
----------------------

-- Keith Davis --
--  (c) 2021   --
--  ZuniSoft   --

-- Mark Sumner --
--  (c) 2019   --
-- SpacePiper  --


function setup()
    viewer.mode = FULLSCREEN_NO_BUTTONS
    
    -- global variables
    ver = 1.10
    playMusic = true
    playSFX = true
    resetGame = true
    isBattle = false
    monsterClose = false
    musicVol = 1
    blastRad = 0
    bombIsSet = false
    sheildNum = 0
    avatarNum = 1
    armor = 1
    gems = 0
    bombs = 0
    intro = false
    showDialog = false
    floorNum = 1
    
    -- character values
    ax = 0
    ay = 0
    cx = 5
    cy = 5
    cw = 64
    ch = 64
    keys = 0
    health = 5
    strength = 1
    weapon = 1
    exp = 0
    arrows = {}
    arrowCnt = 0
    arrowsShot = 0
    
    hitTint = color(255, 255, 255, 255)
    
    -- settings saved between sessions
    playMusic = readLocalData("MUSIC", true)
    playSFX = readLocalData("SFX", true)
    resetGame = readLocalData("RESET", false)
    if not playMusic then musicVol = 0 end
    
    -- gold is saved between sessions
    gold = 0
    if readLocalData("GOLD") then
        gold = math.floor(readLocalData("GOLD", 0))
    end
    
    -- gems are saved between sessions
    gems = 0
    if readLocalData("GEMS") then
        gems = math.floor(readLocalData("GEMS", 0))
    end
    
    -- bombs are saved between sessions
    bombs = 0
    if readLocalData("BOMBS") then
        bombs = math.floor(readLocalData("BOMBS", 0))
    end
    
    -- arrows are saved between sessions
    arrowCnt = 0
    if readLocalData("ARROWS") then
        arrowCnt = math.floor(readLocalData("ARROWS", 0))
    end
    
    -- purchased shields are also saved locally
    boughtShields = {false, false, false, false}
    if readLocalData("BOUGHT1") then
        boughtShields[1] = true
    end
    if readLocalData("BOUGHT2") then
        boughtShields[2] = true
    end
    if readLocalData("BOUGHT3") then
        boughtShields[3] = true
    end
    if readLocalData("BOUGHT4") then
        boughtShields[4] = true
    end
    
    -- currently selected shield
    if readLocalData("SHIELD") then
        sheildNum = readLocalData("SHIELD")
    end
    
    -- last selected avatar
    if readLocalData("AVATAR") then
        avatarNum = readLocalData("AVATAR")
    end
    
    -- screens
    introScreen = IntroScreen()
    
    -- controls
    musicButton = Button(120, HEIGHT / 2 + 50, asset.documents.Dungeon_Shadows_assets.Grey_Circle)
    musicButton.w = 200
    sfxButton = Button(120, HEIGHT / 2, asset.documents.Dungeon_Shadows_assets.Grey_Circle)
    sfxButton.w = 200
    resetGameButton = Button(120, HEIGHT / 2 - 50, asset.documents.Dungeon_Shadows_assets.Grey_Circle)
    resetGameButton.w = 200
    returnButton = Button(20, HEIGHT - 20, asset.documents.Dungeon_Shadows_assets.Grey_Slider_Left)
    dialog = Dialog(100, 400, "Try Again?")
    dialog.hasCancel = true
    rightBtn = Button(200, 150, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Right)
    leftBtn = Button(100, 150, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Left)
    upBtn = Button(150, 200, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Up)
    downBtn = Button(150, 100, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Down)
    gemButton = Button(68, 50, asset.documents.Dungeon_Shadows_assets.Gem_Orange)
    gemButton.imageWidth = 64
    gemButton.imageHeight = 64
    bombButton = Button(200, 50, asset.documents.Dungeon_Shadows_assets.Bomb_1)
    bombButton.imageWidth = 64
    bombButton.imageHeight = 64
    arrowButton = Button(WIDTH - 170, 50, asset.documents.Dungeon_Shadows_assets.Arrow_Up)
    arrowButton.imageWidth = 10
    arrowButton.imageHeight = 40
    arrowRightBtn = Button(WIDTH - 100, 150, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Right)
    arrowLeftBtn = Button(WIDTH - 200, 150, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Left)
    arrowUpBtn = Button(WIDTH - 150, 200, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Up)
    arrowDownBtn = Button(WIDTH - 150, 100, asset.documents.Dungeon_Shadows_assets.Blue_Slider_Down)
    -- arrays
    monsters = {}
    treasures = {}
    messages = {}  
    avatars = {asset.documents.Dungeon_Shadows_assets.Assassin_Guy, asset.documents.Dungeon_Shadows_assets.Mage,
    asset.documents.Dungeon_Shadows_assets.Warrior_Girl_1, asset.documents.Dungeon_Shadows_assets.Warrior_Girl_2}
    shields = {asset.documents.Dungeon_Shadows_assets.Wooden_Shield, asset.documents.Dungeon_Shadows_assets.Dog_Shield, asset.documents.Dungeon_Shadows_assets.Silver_Shield, asset.documents.Dungeon_Shadows_assets.Gold_Shield}
    tunes = {asset.documents.Dungeon_Shadows_assets.Smoothie, asset.documents.Dungeon_Shadows_assets.Zero, asset.documents.Dungeon_Shadows_assets.Pulsar, asset.documents.Dungeon_Shadows_assets.Runner_Blade}
    shieldPrices = {500, 2000, 3500, 6000}
    floor = Floor()
    
    -- place character
    placeCharacter()
    
    font("Optima-ExtraBlack")
    if playSFX then sound(asset.documents.Dungeon_Shadows_assets.Level_Up) end
end

function start()
    showDialog = false
    if resetGame then
        boughtShields = {false, false, false, false}
        saveLocalData("BOUGHT1", false)
        saveLocalData("BOUGHT2", false)
        saveLocalData("BOUGHT3", false)
        saveLocalData("BOUGHT4", false)
        saveLocalData("SHIELD", 0)
        saveLocalData("GOLD", 0)
        saveLocalData("GEMS", 0)
        saveLocalData("BOMBS", 0)
        saveLocalData("ARROWS", 0)
    else
        saveLocalData("SHIELD", shieldNum)
        saveLocalData("GOLD", gold)
        saveLocalData("GEMS", gems)
        saveLocalData("BOMBS", bombs)
        saveLocalData("ARROWS", arrowCnt)
    end
    monsters = {}
    cx = 5
    cy = 5
    keys = 0
    gold = 0
    if readLocalData("GOLD") then
        gold = math.floor(readLocalData("GOLD", 0))
    end
    gems = 0
    if readLocalData("GEMS") then
        gems = math.floor(readLocalData("GEMS", 0))
    end
    bombs = 0
    if readLocalData("BOMBS") then
        bombs = math.floor(readLocalData("BOMBS", 0))
    end
    if readLocalData("ARROWS") then
        arrowCnt = math.floor(readLocalData("ARROWS", 0))
    end
    health = 3
    strength = 1
    weapon = 1
    exp = 0
    floorNum = 1
    floor = Floor(100, 100)
    placeCharacter()
end

function screenMap(x, y)
    local dx = 0
    local dy = 200
    local bx = dx + x * 48 - floor.ox * 48 - 24
    local by = dy + y * 48 + 32 - floor.oy * 48
    return bx, by
end

function placeCharacter()
    local found = false
    while not found do
        local x = math.random(50)
        local y = math.random(50)
        if floor.tiles[y][x] == "-" then
            cx = x
            cy = y
            found = true
        end
    end
end

function draw()
    if not intro then
        introScreen:draw()
        return
    end
    returnButton.y = HEIGHT - 20
    background(40, 40, 50)
    floor:draw(cx, cy)
    stroke(0, 0, 0, 255)
    fill(0, 0, 0, 255)
    rectMode(CORNER)
    rect(0, 0, WIDTH, 270)
    tint(127, 127, 127, 255)
    rightBtn:draw()
    leftBtn:draw()
    upBtn:draw()
    downBtn:draw()
    if gems > 0 then
        gemButton:draw()
        fill(177, 178, 198, 255)
        text("x " .. gems, 128, 41)
    end
    if bombs > 0 then
        bombButton:draw()
        fill(177, 178, 198, 255)
        text("x " .. bombs, 250, 41)
    end
    if arrowCnt > 0 then
        arrowButton:draw()
        fill(177, 178, 198, 255)
        text("x " .. arrowCnt, WIDTH - 135, 50)
    end
    arrowRightBtn:draw()
    arrowLeftBtn:draw()
    arrowUpBtn:draw()
    arrowDownBtn:draw()
    noTint()
    local i
    for i, a in ipairs(arrows) do
        a:move()
    end
    monsterClose = false
    for i, m in ipairs(monsters) do
        m:move()
        m:drawCard()
    end
    if monsterClose and not isBattle then
        music(asset.documents.Dungeon_Shadows_assets.Battle,true,musicVol)
        isBattle = true
    elseif not monsterClose and isBattle then
        if floorNum < 5 then 
            music(tunes[floorNum],true,0.5 * musicVol)
        else
            music(tunes[4],true,0.5 * musicVol)
        end
        isBattle = false
    end
    for i, m in ipairs(messages) do
        m:draw()
        if m.tint.a < 1 then table.remove(messages, i) end
    end
    fill(163, 163, 163, 255)
    textMode(CORNER)
    textAlign(LEFT)
    
    for i = 1, keys do
        sprite(asset.documents.Dungeon_Shadows_assets.Key,370 + i * 22,100,32,28)
    end
    fill(127, 128, 153, 255)
    text(floorNum, 385, 60)
    fill(83, 158, 109, 255)
    text(exp, 385, 30)
    fill(177, 178, 198, 255)
    text("Health", 300, 120)
    text("Strength", 300, 150)
    text("Floor ", 300, 60)
    text("Exp ", 300, 30)
    text("Keys", 300, 90)
    text("Gold", 300, 180)
    fontSize(12)
    text("Move", 134, 145)
    text("Bow", WIDTH - 163, 145)
    fontSize(16)

    if WIDTH > 700 then
        for i = 1, health do
            sprite(asset.documents.Dungeon_Shadows_assets.Heart,370 + i * 28,130,28,30)
        end
    else
        fill(220, 112, 101, 255)
        text(health, 385, 120)
    end
    
    if WIDTH > 700 then
        for i = 1, strength do
            sprite(asset.documents.Dungeon_Shadows_assets.Sword,370 + i * 22,160,12,28)
        end
    else
        fill(171, 198, 208, 255)
        text(strength, 385, 150)
    end

    tint(100, 100, 100, 255)
    returnButton:draw()
    noTint()
    fill(206, 161, 39, 255)
    text(gold, 385, 180)
    if showDialog then dialog:draw() end
    if health < 1 then showDialog = true end
end

function checkLevelUp(o, n)
    if o < 10 and n >= 10 then return true end
    if o < 50 and n >= 50 then return true end
    if o < 150 and n >= 150 then return true end
    if o < 400 and n >= 400 then return true end
    if o < 1000 and n >= 1000 then return true end
end

function SFX(name)
    if playSFX then sound(name) end
end

function touched(touch)
    if returnButton:touched(touch) then
        intro = false
        music.paused = true
        SFX(asset.documents.Dungeon_Shadows_assets.Throw)
        start()
        return
    end
    if not intro then 
        introScreen:touched(touch)
        return
    end
    if musicButton:touched(touch) and not floor then -- test to see if floor fixes music btn bug
        playMusic = not playMusic
        if playMusic then musicVol = 1 else musicVol = 0 end
        music.volume = 0.5 * musicVol
        return
    end
    if showDialog then
        if dialog:touched(touch) == 1 then
            start()
        end
        if dialog:touched(touch) == 2 then
            intro = false
            music.paused = true
            start()
        end
        return
    end
    if floor.showDialog then
        if floor:touched(touch) then
            floor:init(cx, cy)
            floorNum = floorNum + 1  
            found = false
            while not found do
                x = math.random(50)
                y = math.random(50)
                if floor.tiles[y][x] == "-" then
                    cx = x
                    cy = y
                    found = true
                end
            end
            if floorNum < 5 then 
                music(tunes[floorNum],true,0.5 * musicVol)
            else
                music(tunes[4],true,0.5 * musicVol)
            end
        end
        return
    end
    local dx = 0
    local dy = 0
    ax = 0
    ay = 0
    -- player direction
    if rightBtn:touched(touch) then
        dx = 1
    elseif leftBtn:touched(touch) then
        dx = -1
    elseif upBtn:touched(touch) then
        dy = 1
    elseif downBtn:touched(touch) then
        dy = -1
    -- arrow direction
    elseif arrowRightBtn:touched(touch) then
        ax = 1
    elseif arrowLeftBtn:touched(touch) then
        ax = -1
    elseif arrowUpBtn:touched(touch) then
        ay = 1
    elseif arrowDownBtn:touched(touch) then
        ay = -1
    elseif gemButton:touched(touch) and gems > 0 then
        SFX(asset.documents.Dungeon_Shadows_assets.FireBall_Woosh) 
        blastRad = 1
        for i, m in ipairs(monsters) do
            dist = math.sqrt(((cx - m.x) * (cx - m.x)) + ((cy - m.y) * (cy - m.y)))
            if dist < 4 then
                fm = FloatingMessage(m.health, screenMap(m.x, m.y))
                fm.tint = color(244, 255, 0, 255)
                table.insert(messages, fm)
                m.health = 0
                oldExp = exp
                exp = exp + m.strength * 2
                if checkLevelUp(oldExp, exp) then
                    SFX(asset.documents.Dungeon_Shadows_assets.Level_Up)
                    strength = strength + 1
                    fm = FloatingMessage("Level Up!", screenMap(cx, cy))
                    fm.tint = color(223, 173, 216, 255)
                    table.insert(messages, fm)
                end
            end
        end
        gems = gems - 1 
    elseif bombButton:touched(touch) and bombs > 0 then
        if not bombIsSet then
            SFX(asset.documents.Dungeon_Shadows_assets.Fuse2)
            b = Bomb(cx, cy)
            bombIsSet = true
            tween.delay(3, function()
                -- check if monsters killed
                SFX(asset.documents.Dungeon_Shadows_assets.FireBall_Blast_2)
                for i, m in ipairs(monsters) do
                    dist = math.sqrt(((cx - m.x) * (cx - m.x)) + ((cy - m.y) * (cy - m.y)))
                    if dist < 4 then
                        fm = FloatingMessage(m.health, screenMap(m.x, m.y))
                        fm.tint = color(244, 255, 0, 255)
                        table.insert(messages, fm)
                        m.health = 0
                        oldExp = exp
                        exp = exp + m.strength * 2
                        if checkLevelUp(oldExp, exp) then
                            SFX(asset.documents.Dungeon_Shadows_assets.Level_Up)
                            strength = strength + 1
                            fm = FloatingMessage("Level Up!", screenMap(cx, cy))
                            fm.tint = color(223, 173, 216, 255)
                            table.insert(messages, fm)
                        end
                    end
                end
                -- check if rocks or dragon eggs blasted 
                local my = 50
                local mx = 50
                for y = my, floor.oy + 1, -1 do
                    for x = 1 + floor.ox, mx do
                        dist = math.sqrt(((b.x - x) * (b.x - x)) + ((b.y - y) * (b.y - y)))
                        if dist < 2 then
                            if floor.tiles[y][x] == "R" or floor.tiles[y][x] == "E" then
                                floor.tiles[y][x] = "-"
                            end
                        end
                    end
                end
                -- check if player blasted
                dist = math.sqrt(((cx - b.x) * (cx - b.x)) + ((cy - b.y) * (cy - b.y)))
                if dist < 3 then
                    health = 0
                end
            end)
            bombs = bombs - 1
        end
    end
    for i, m in ipairs(monsters) do
        if cx + dx == m.x and cy + dy == m.y and m.health > 0 then
            -- Hit monster
            SFX(asset.documents.Dungeon_Shadows_assets.Swing_2)
            if math.random(10) > 3 then
                m.health = m.health - (strength * weapon)
                SFX(asset.documents.Dungeon_Shadows_assets.Hit_Monster_3)
                fm = FloatingMessage(strength * weapon, screenMap(m.x, m.y))
                fm.tint = color(0, 255, 3, 255)
                table.insert(messages, fm)
                oldExp = exp
                if m.health < 1 then
                    exp = exp + m.strength * 2
                end
                if checkLevelUp(oldExp, exp) then
                    SFX(asset.documents.Dungeon_Shadows_assets.Level_Up)
                    strength = strength + 1
                    fm = FloatingMessage("Level Up!", screenMap(cx, cy))
                    fm.tint = color(223, 173, 216, 255)
                    table.insert(messages, fm)
                end
            else
                if math.random(6) <= sheildNum then
                    SFX(asset.documents.Dungeon_Shadows_assets.Sword_Hit_2)
                    fm = FloatingMessage("Blocked", screenMap(cx, cy))
                    fm.tint = color(0, 138, 255, 255)
                    table.insert(messages, fm)
                    return
                end
                local s = math.random(m.strength)
                fm = FloatingMessage(s, screenMap(m.x, m.y))
                fm.tint = color(255, 0, 18, 255)
                table.insert(messages, fm)
                health = health - s
                hitTint = color(255, 0, 0, 255)
            end
            return
        end
    end
    -- shoot arrows
    if (math.abs(ax) == 1 or math.abs(ay) == 1) and arrowCnt > 0 then
        arrowCnt = arrowCnt - 1
        arrowsShot = arrowsShot + 1
        if arrowsShot < 3 then
            SFX(asset.documents.Dungeon_Shadows_assets.Arrow_Shoot_1)
            local a = Arrow(ax, ay, cx, cy)
            table.insert(arrows, a)
            arrowsShot = 0
        end
    end
    -- check player & set player position
    if floor:check(cx + dx, cy + dy) then 
        cx = cx + dx
        cy = cy + dy
        -- sprite flip based on x direction
        if dx == -1 then cw = math.abs(cw) * -1 end
        if dx == 1 then cw = math.abs(cw) end
    else
        SFX(asset.documents.Dungeon_Shadows_assets.Hit_2)
    end
end

function processArrows()
    -- check if arrows hit anything
    for i, a in ipairs(arrows) do
        if a:hitMonster() or a:hitWall() then
            table.remove(arrows, i)
        end
    end
end
