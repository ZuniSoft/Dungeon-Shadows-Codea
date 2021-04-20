Dialog = class()

function Dialog:init(x, y, text)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.hasCancel = true
    self.text = text
    self.yesBtn = Button(x + 200, y + 20, asset.documents.Dungeon_Shadows_assets.Green_Box_Check)
    self.noBtn = Button(x + 250, y + 20, asset.documents.Dungeon_Shadows_assets.Red_Box_Cross)
end

function Dialog:draw()
    strokeWidth(2)
    stroke(126, 126, 126, 255)
    fill(231, 231, 231, 255)
    rect(WIDTH / 2 - 150, HEIGHT / 2 - 50, 300, 100)
    fill(25, 25, 25, 255)
    textMode(CENTER)
    text(self.text, WIDTH / 2, HEIGHT / 2 + 20)
    self.yesBtn.x = WIDTH / 2 + 100
    self.yesBtn.y = HEIGHT / 2 - 10
    self.noBtn.x = WIDTH / 2 - 100
    self.noBtn.y = HEIGHT / 2 - 10
    self.yesBtn:draw()
    if self.hasCancel then self.noBtn:draw() end
end

function Dialog:touched(touch)
    if self.yesBtn:touched(touch) then return 1 end
    if self.noBtn:touched(touch) then return 2 end
    return 0
end
