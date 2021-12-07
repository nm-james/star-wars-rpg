Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Inventory = Falcon.UI.Inventory or {}
local f = Falcon.UI.Inventory

f.OpenPlayerSlots = function( content )
    local w, h = content:GetWide(), content:GetTall()
    for i = 1, 4 do
        local btn = vgui.Create("DPanel", content) 
        btn:SetSize( w * 0.9, w * 0.9 )
        btn:SetPos( w * 0.05, h * (0.05 + ((i-1) * 0.225)) )

     end
end
f.LoadPlayerUI = function( fr )
    Falcon.UI.Presets.Models.CreateFullModel( fr, 0.975, 1, 0.025, 0, {} )

    local p = fr:GetParent()
    local w, h = p:GetWide(), p:GetTall()

    local armorSlots = vgui.Create("DPanel", p )
    armorSlots:SetSize( w * 0.085, fr:GetTall() )
    armorSlots:SetPos( w * 0.325, h * 0.175 )
    armorSlots.Paint = nil

    f.OpenPlayerSlots( armorSlots )
end

f.LoadInventoryUI = function( fr )
    f.OpenInventoryGrid( fr )
end