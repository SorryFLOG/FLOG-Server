CreateThread(function()
    while true do
        Wait(0)

        -- Hide GTA/FiveM default HUD components
        HideHudComponentThisFrame(1)  -- Wanted stars
        HideHudComponentThisFrame(2)  -- Weapon icon
        HideHudComponentThisFrame(3)  -- Cash
        HideHudComponentThisFrame(4)  -- MP cash
        HideHudComponentThisFrame(6)  -- Vehicle name
        HideHudComponentThisFrame(7)  -- Area name
        HideHudComponentThisFrame(8)  -- Vehicle class
        HideHudComponentThisFrame(9)  -- Street name
        HideHudComponentThisFrame(13) -- Cash change
        HideHudComponentThisFrame(14) -- Reticle
        HideHudComponentThisFrame(19) -- Weapon wheel stats
    end
end)