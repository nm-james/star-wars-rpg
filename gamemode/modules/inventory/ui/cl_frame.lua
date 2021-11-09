Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Inventory = Falcon.UI.Inventory or {}
local scrw, scrh = ScrW(), ScrH()

local color_black = Color( 0, 0, 0 )
local f = Falcon.UI.Inventory
f.OpenFrame = function()
    if f.Frame and f.Frame:IsValid() then return end
    local fr = vgui.Create("DFrame")
    fr:SetSize( scrw, scrh )
    fr:Center()
    fr:MakePopup()
    fr.Paint = nil

    local invStuff = vgui.Create("DPanel", fr)
    invStuff:SetSize( scrw * 0.6, scrh * 0.65 )
    invStuff:SetPos( scrw * 0.35, scrh * 0.175 )
    invStuff.Paint = nil
    
    Falcon.UI.Inventory.LoadInventoryUI( invStuff )

    f.Frame = fr
end