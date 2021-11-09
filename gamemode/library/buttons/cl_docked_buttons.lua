Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Buttons = Falcon.UI.Presets.Buttons or {}

local f = Falcon.UI.Presets.Buttons 
f.CreateHorizontalButtons = function( parent, buttonCreation, buttons, relatedPanel )
    for _, btn in pairs(buttons) do
        local b = f[buttonCreation.type or "CreateCategoricalButton"]( parent, (buttonCreation.w or 0.2), (buttonCreation.h or 0.5), nil, nil, { text = btn.name, font = buttonCreation.font, fade = buttonCreation.fade, click = function( self )
            if buttonCreation.click then
                buttonCreation.click( self )
            end

            if btn.click then
                btn.click( relatedPanel )
            end
        end } )
        b:Dock( buttonCreation.dock or LEFT )

        if buttonCreation.shouldStart and buttonCreation.shouldStart == _ then
            b.IsActive = true
            parent.CurrentActiveButton = b
            b.DoClick( b )
        end
    end
end