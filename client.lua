local pendingData = nil

RegisterNetEvent('nova-pausemenu:client:data', function(data)
    local cb = pendingData
    pendingData = nil
    if cb then cb(data) end
end)

local function requestMenuData(cb)
    local finished = false
    local function finish(data)
        if finished then return end
        finished = true
        if pendingData == finish then pendingData = nil end
        cb(data)
    end
    pendingData = finish
    TriggerServerEvent('nova-pausemenu:server:requestData')
    SetTimeout(5000, function()
        finish(nil)
    end)
end

local menuOpen = false
local isOpening = false
local cam      = nil
local mapState = 'none'   -- 'none' | 'pending' | 'shown'
local scenarioStarted = false

-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- HUD Hide/Show
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
local function HudVisible(show)
    -- Nova HUD
    if GetResourceState('nova-hud') == 'started' then
        if show then
            pcall(function() exports['nova-hud']:pmShow() end)
            pcall(function() exports['nova-hud']:showHud() end)
        else
            pcall(function() exports['nova-hud']:pmHide() end)
            pcall(function() exports['nova-hud']:hideHud() end)
        end
    -- Standart QBCore HUD
    elseif GetResourceState('qb-hud') == 'started' then
        pcall(function() exports['qb-hud']:HideHud(not show) end)
    -- Project Sloth HUD
    elseif GetResourceState('ps-hud') == 'started' then
        pcall(function() exports['ps-hud']:ToggleHud(show) end)
    end

    -- Pusula / Compass
    if GetResourceState('compass') == 'started' then
        pcall(function() exports['compass']:setVisible(show) end)
    end

    -- GTA Radar
    DisplayRadar(show)
end

-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- Character Cinema (Camera)
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- Is it safe to play a standing scenario on this ped right now?
-- IsPedOnFoot is false while in / entering / exiting a vehicle, falling, ragdolling or
-- swimming. Playing the scenario during a vehicle transition (e.g. a quick ESC mid-entry)
-- glitches the ped through the map, so we gate strictly on a settled on-foot state.
local function PedCanScenario(ped)
    return IsPedOnFoot(ped)
        and not IsPedInAnyVehicle(ped, true)        -- true = also counts get-in/out stage
        and GetVehiclePedIsEntering(ped) == 0
        and not IsPedRagdoll(ped)
        and not IsPedFalling(ped)
end

local function StartCam()
    if not Config.ShowCharacter then return end
    local ped = PlayerPedId()
    local dist = Config.CamDistance or 2.2
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        AttachCamToEntity(cam, veh, -dist, 0.0, Config.CamHeight or 0.55, true)
        PointCamAtEntity(cam, ped, 0.0, 0.0, Config.CamLookZ or 0.45, true)
    else
        local pc  = GetEntityCoords(ped)
        local fwd = GetEntityForwardVector(ped)
        local camX = pc.x + fwd.x * dist
        local camY = pc.y + fwd.y * dist
        local camZ = pc.z + (Config.CamHeight or 0.55)
        SetCamCoord(cam, camX, camY, camZ)
        PointCamAtCoord(cam, pc.x, pc.y, pc.z + (Config.CamLookZ or 0.45))
    end
    SetCamFov(cam, Config.CamFov or 38.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 400, true, true)
    scenarioStarted = false
    if Config.CharacterScenario and Config.CharacterScenario ~= ''
       and PedCanScenario(ped) then
        TaskStartScenarioInPlace(ped, Config.CharacterScenario, 0, true)
        scenarioStarted = true
    end
end

local function StopCam()
    if cam then
        RenderScriptCams(false, true, 300, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
    -- Only clear if we started a scenario and are still on foot.
    -- (Condition IsPedOnFoot as ClearPedTasksImmediately can throw the pad in the vehicle.)
    if scenarioStarted and IsPedOnFoot(PlayerPedId()) then
        ClearPedTasksImmediately(PlayerPedId())
    end
    scenarioStarted = false
end

-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- Menu Transactions
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
local function CloseMenu()
    if not menuOpen then return end
    menuOpen = false
    isOpening = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    StopCam()
    HudVisible(true)
end

local function OpenMenu()
    if menuOpen or isOpening then return end
    isOpening = true
    requestMenuData(function(data)
        isOpening = false
        if not data then return end
        menuOpen = true
        HudVisible(false)
        StartCam()
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', data = data })
    end)
end

-- Hide HUD in every frame when the menu is open (to avoid leaking speedometer etc.)
CreateThread(function()
    while true do
        if menuOpen then
            HideHudAndRadarThisFrame()
            Wait(0)
        else
            Wait(300)
        end
    end
end)

-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- Key Controls and Triggers
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- GTA Pause Menu Suppression + Map Status Machine
CreateThread(function()
    while true do
        Wait(0)
        if IsPauseMenuActive() then
            if mapState ~= 'none' then
                mapState = 'shown' -- Native map shown, don't touch
            elseif not menuOpen then
                SetFrontendActive(false)
                OpenMenu()
            else
                SetFrontendActive(false)
            end
        else
            if mapState == 'shown' then mapState = 'none' end -- Map closed
            Wait(150)
        end
    end
end)

-- Closing the Menu with ESC or Cellphone Cancel (Backup)
CreateThread(function()
    while true do
        if menuOpen then
            Wait(0)
            if IsControlJustPressed(0, 200) or IsControlJustPressed(0, 322) then
                CloseMenu()
            end
        else
            Wait(250)
        end
    end
end)

-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
-- NUI Callback Definitions
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
RegisterNUICallback('close', function(_, cb)
    CloseMenu()
    cb('ok')
end)

RegisterNUICallback('disconnect', function(_, cb)
    CloseMenu()
    TriggerServerEvent('nova-pausemenu:server:disconnect')
    cb('ok')
end)

-- Native GTA ESC Menu (Map and Settings redirected here)
RegisterNUICallback('openNative', function(data, cb)
    CloseMenu()
    mapState = 'pending'
    cb('ok')
    CreateThread(function()
        Wait(120)
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_SP_PAUSE'), false, -1)
        if data and data.which == 'map' then
            -- Pause opens the map directly in the menu
            PauseMenuceptionGoDeeper(0)
        end
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and menuOpen then
        SetNuiFocus(false, false)
        StopCam()
        HudVisible(true)
    end
end)

-- Exports (For other scripts)
exports('OpenMenu', OpenMenu)
exports('CloseMenu', CloseMenu)
exports('IsOpen', function() return menuOpen end)
