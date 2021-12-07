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
    invStuff:SetSize( scrw * 0.535, scrh * 0.425 )
    invStuff:SetPos( scrw * 0.415, scrh * 0.4 )
    invStuff.Paint = nil
    Falcon.UI.Inventory.LoadInventoryUI( invStuff )

    local plyStuff = vgui.Create("DPanel", fr)
    plyStuff:SetSize( scrw * 0.3, scrh * 0.65 )
    plyStuff:SetPos( scrw * 0.025, scrh * 0.175 )
    plyStuff.Paint = nil
    Falcon.UI.Inventory.LoadPlayerUI( plyStuff )

    local weaponStuff = vgui.Create("DPanel", fr)
    weaponStuff:SetSize( scrw * 0.535, scrh * 0.145 )
    weaponStuff:SetPos( scrw * 0.415, scrh * 0.175 )


    local scrapStuff = vgui.Create("DPanel", fr)
    scrapStuff:SetSize( scrw * 0.535, scrh * 0.07 )
    scrapStuff:SetPos( scrw * 0.415, scrh * 0.325 )

    f.Frame = fr
end