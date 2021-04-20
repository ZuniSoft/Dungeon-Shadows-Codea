IntroScreen = class()

function IntroScreen:init()
    self.startBtn = Button(WIDTH / 2, 150, asset.documents.Dungeon_Shadows_assets.Yellow_Button_13, "Start", "Optima-ExtraBlack", 24)
    self.startBtn.w = 100
    self.okBtn = Button(WIDTH / 2, 150, asset.documents.Dungeon_Shadows_assets.Yellow_Button_13, "OK", "Optima-ExtraBlack", 24)
    self.okBtn.w = 100
    self.infoBtn = Button(WIDTH / 2 - 100, 80, asset.documents.Dungeon_Shadows_assets.Grey_Button_01, "About", "Optima-ExtraBlack", 24)
    self.infoBtn.w = 100
    self.settingsBtn = Button(WIDTH / 2 + 100, 80, asset.documents.Dungeon_Shadows_assets.Grey_Button_01, "Settings", "Optima-ExtraBlack", 24)
    self.settingsBtn.w = 100
    self.mode = 1
end

function IntroScreen:draw()
    pushStyle()
    background(99, 99, 113, 255)
    tint(125, 125, 125, 115)
    sprite(asset.documents.Dungeon_Shadows_assets.Bricks,WIDTH / 2,HEIGHT / 2,WIDTH,HEIGHT)
    noTint()
    local i
    if self.mode == 1 then
        sprite(asset.documents.Dungeon_Shadows_assets.Logo,WIDTH // 2,HEIGHT - 60, 230,75)
        textMode(CENTER)
        font("Optima-ExtraBlack")
        fill(214, 214, 214, 255)
        fontSize(80)
        text("Dungeon Shadows", WIDTH // 2, HEIGHT - 150)
        fill(174, 167, 167)
        fontSize(79)
        text("Dungeon Shadows", WIDTH // 2, HEIGHT - 150)
        local x
        for i = 1, #avatars do
            x = WIDTH / #avatars + 1
            sprite(avatars[i], x * i - x / 2, HEIGHT - HEIGHT // 3, 128, 128)
        end
        stroke(184, 223, 161, 255)
        fill(255, 0, 0, 0)
        strokeWidth(4)
        rectMode(CENTER)
        self.startBtn:draw()
        self.infoBtn:draw()
        self.settingsBtn:draw()
        rect(x * avatarNum - x / 2, HEIGHT - HEIGHT // 3 + 2, 
        96, 96)
        fontSize(24)
        fill(186, 192, 183, 255)
        text("Select an Avatar", WIDTH // 2, HEIGHT - HEIGHT // 3 - 90)
        for i = 1, #shields do
            x = WIDTH / #shields + 1
            local sx, sy
            sx = x * i - x / 2
            sy = HEIGHT - HEIGHT // 2
            pushStyle()
            fontSize(16)
            fill(226, 219, 225, 255)
            if not boughtShields[i] then
                text(shieldPrices[i], sx, sy - 60)
            end
            popStyle()
            pushMatrix()
            translate(sx, sy)
            sprite(shields[i], 0, 0, 64, 54)
            popMatrix()
        end
        stroke(184, 223, 161, 255)
        fill(255, 180, 0, 0)
        strokeWidth(4)
        rectMode(CENTER)
        self.startBtn:draw()
        if sheildNum > 0 then
            rect(x * sheildNum - x / 2, HEIGHT - HEIGHT // 2 , 90, 90 )
        end
        fontSize(24)
        fill(186, 192, 183, 255)
        text("Shield", WIDTH // 2, HEIGHT - HEIGHT // 2 - 90)
        fontSize(36)
        fill(233, 169, 75, 255)
        text(gold, WIDTH / 2, HEIGHT / 2 - 160)
        fontSize(20)
        fill(172, 171, 171, 255)
        text("Available Gold", WIDTH / 2, HEIGHT / 2 - 190)
        fontSize(24)
        font("HelveticaNeue")
    end
    if self.mode == 2 then
        self.okBtn:draw()
        sprite(asset.documents.Dungeon_Shadows_assets.Logo,WIDTH / 2,HEIGHT - 100)        
        fill(171, 195, 188, 255)
        font("HelveticaNeue")
        fontSize(48)
        text("Dungeon Shadows", WIDTH / 2, HEIGHT - 350)
        if WIDTH < 700 then fontSize(18) else fontSize(24) end
        textMode(CENTER)
        text("A dungeon crawler with random level creation.", WIDTH / 2, HEIGHT - 400)
        text("Copyright © Keith R. Davis 2021", WIDTH / 2, HEIGHT - 500)
        text("Copyright © Mark Sumner 2019", WIDTH / 2, HEIGHT - 540)
        text("All rights reserved.", WIDTH / 2, HEIGHT - 580)
        text("Version " .. ver, WIDTH / 2, 75)
    end
    if self.mode == 3 then
        self.okBtn:draw()
        sprite(asset.documents.Dungeon_Shadows_assets.Logo,WIDTH // 2,HEIGHT - 100)
        musicButton:draw()
        sfxButton:draw()
        resetGameButton:draw()
        local x
        if playMusic then
            sprite(asset.documents.Dungeon_Shadows_assets.Blue_Check,musicButton.x,musicButton.y)
        end
        if playSFX then
            sprite(asset.documents.Dungeon_Shadows_assets.Blue_Check,sfxButton.x,sfxButton.y)
        end
        if resetGame then
            sprite(asset.documents.Dungeon_Shadows_assets.Blue_Check,resetGameButton.x,resetGameButton.y)
        end
        font("HelveticaNeue")
        fontSize(24)
        if WIDTH < 700 then fontSize(20) end
        fill(171, 195, 188, 255)
        textMode(CENTER)
        text("Version " .. ver, WIDTH / 2, 45)
        textMode(CORNER)
        fill(217, 220, 231, 255)
        text("Play dungeon mood music", musicButton.x + 50, musicButton.y - 10)
        text("Boom! Bang! Whack! SFX!", sfxButton.x + 50, sfxButton.y - 10)
        text("Reset game when player dies", resetGameButton.x + 50, resetGameButton.y - 10)
    end
    popStyle()
end

function IntroScreen:touched(touch)
    if self.startBtn:touched(touch) then
        if self.mode == 1 then
            intro = true
            if avatarNum == 1 then
                SFX(asset.documents.Dungeon_Shadows_assets.Male_Cheer_2)
            elseif avatarNum == 2 then
                SFX(asset.documents.Dungeon_Shadows_assets.Male_Cheer_2)
            elseif avatarNum == 3 then
                SFX(asset.documents.Dungeon_Shadows_assets.Female_Cheer_1)
            else
                SFX(asset.documents.Dungeon_Shadows_assets.Female_Cheer_2)
            end
            saveLocalData("AVATAR", avatarNum)
            music(asset.documents.Dungeon_Shadows_assets.Dungeon,true,0.5 * musicVol)
        else
            self.mode = 1
        end
        return
    end
    if musicButton:touched(touch) and self.mode == 3 then
        playMusic = not playMusic
        if playMusic then musicVol = 1 else musicVol = 0 end
        saveLocalData("MUSIC", playMusic)
        return
    end
    if sfxButton:touched(touch) and self.mode == 3 then
        playSFX = not playSFX
        saveLocalData("SFX", playSFX)
        return
    end
    if resetGameButton:touched(touch) and self.mode == 3 then
        resetGame = not resetGame
        saveLocalData("RESET", resetGame)
        return
    end
    if self.infoBtn:touched(touch) then
        if self.mode == 3 then return end
        self.mode = 2
        return
    end
    if self.settingsBtn:touched(touch) then
        if self.mode == 2 then return end
        self.mode = 3
        return
    end
    if touch.state == BEGAN and touch.y > HEIGHT - HEIGHT / 3 - 90 then
        avatarNum = touch.x // (WIDTH / #avatars) + 1
        SFX(asset.documents.Dungeon_Shadows_assets.Pop_1)
    end
    if touch.state == BEGAN and touch.y > HEIGHT - HEIGHT / 2 - 60 and
    touch.y < HEIGHT - HEIGHT / 4 - 60 then
        local i = math.floor(touch.x // (WIDTH / #shields) + 1)
        if boughtShields[i] then
            SFX(asset.documents.Dungeon_Shadows_assets.Pop_1)
            sheildNum = i
        else
            if gold >= shieldPrices[i] then
                boughtShields[i] = true
                sheildNum = i // 1
                local s = "BOUGHT" .. sheildNum
                saveLocalData(s, "true")
                gold = gold - shieldPrices[i]
                saveLocalData("GOLD", gold)
            end
        end
    end
end
