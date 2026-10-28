local QBCore = nil
local ESX = nil

local serverStart = os.time()
local sessionStart = {} -- [src] = os.time()

-- ── Auxiliary Functions ──
local function fmtMoney(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n)
    local out = s:reverse():gsub('(%d%d%d)', '%1.'):reverse()
    out = out:gsub('^%.', '')
    return '$' .. out
end

local function fmtDuration(sec)
    sec = math.max(0, math.floor(sec))
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    
    local localeData = Config.Locales[Config.Locale] or Config.Locales['en']
    if h > 0 then 
        return (localeData.uptime_fmt or '%dsa %ddk'):format(h, m) 
    end
    return (localeData.uptime_fmt_min or '%ddk'):format(m)
end

local lastMenuData = {}

-- ── Player Session Tracker ──
AddEventHandler('playerJoining', function()
    sessionStart[source] = os.time()
end)

AddEventHandler('playerDropped', function()
    sessionStart[source] = nil
    lastMenuData[source] = nil
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    sessionStart[source] = sessionStart[source] or os.time()
end)

RegisterNetEvent('esx:playerLoaded', function(playerId, xPlayer)
    sessionStart[playerId] = sessionStart[playerId] or os.time()
end)

local function attachFramework()
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        ESX = nil
    elseif GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        QBCore = nil
    else
        QBCore = nil
        ESX = nil
    end
end

local function collectData(src)
        attachFramework()
        local activeLocale = Config.Locale or 'en'
        local localeData = Config.Locales[activeLocale] or Config.Locales['en']
        sessionStart[src] = sessionStart[src] or os.time()

        local maxP = GetConvarInt('sv_maxclients', 48)
        local hostname = GetConvar('sv_hostname', 'NOVA ROLEPLAY')
        hostname = hostname:gsub('%^%d', ''):gsub('~[%a]~', '')

        local activeAnnounce = Config.Announce[activeLocale] or Config.Announce['en']
        local activeRules = Config.Rules[activeLocale] or Config.Rules['en']
        local activeKeys = Config.Keys[activeLocale] or Config.Keys['en']

        local serverData = {
            name     = hostname,
            sub      = Config.SubLabel,
            players  = 0,
            max      = maxP,
            uptime   = fmtDuration(os.time() - serverStart),
            discord  = Config.Discord,
            announce = activeAnnounce,
            rules    = activeRules,
        }

        local playerData = {}
        local players = {}
        local count = 0

        if QBCore then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                local pd = Player.PlayerData
                local ci = pd.charinfo or {}

                playerData = {
                    name     = (ci.firstname or 'Ad') .. ' ' .. (ci.lastname or 'Soyad'),
                    id       = src,
                    job      = (pd.job and pd.job.label) or (localeData.lbl_unemployed or 'İşsiz'),
                    ping     = GetPlayerPing(tostring(src)) or 0,
                    cid      = pd.citizenid or '—',
                    phone    = (ci.phone) or '—',
                    gang     = (pd.gang and pd.gang.label and pd.gang.name ~= 'none' and pd.gang.label) or (localeData.lbl_none or 'Yok'),
                    cash     = fmtMoney(pd.money and pd.money.cash or 0),
                    bank     = fmtMoney(pd.money and pd.money.bank or 0),
                    playtime = fmtDuration(os.time() - (sessionStart[src] or os.time())),
                }
            end

            for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
                count = count + 1
                local vci = v.PlayerData.charinfo or {}
                players[#players + 1] = {
                    id   = v.PlayerData.source,
                    name = (vci.firstname or 'Bilinmeyen') .. ' ' .. (vci.lastname or ''),
                    ping = GetPlayerPing(tostring(v.PlayerData.source)) or 0,
                }
            end
        elseif ESX then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                local name = xPlayer.getName() or 'Ad Soyad'
                local jobLabel = (xPlayer.job and xPlayer.job.label) or (localeData.lbl_unemployed or 'İşsiz')
                local identifier = xPlayer.identifier or '—'

                local phone = '—'
                if xPlayer.get and xPlayer.get('phoneNumber') then
                    phone = xPlayer.get('phoneNumber')
                elseif xPlayer.phoneNumber then
                    phone = xPlayer.phoneNumber
                elseif xPlayer.variables and xPlayer.variables.phoneNumber then
                    phone = xPlayer.variables.phoneNumber
                end

                local gang = localeData.lbl_none or 'Yok'
                if xPlayer.getJob2 then
                    local job2 = xPlayer.getJob2()
                    if job2 and job2.name ~= 'unemployed' then
                        gang = job2.label
                    end
                elseif xPlayer.job2 then
                    gang = xPlayer.job2.label or (localeData.lbl_none or 'Yok')
                end

                local cash = xPlayer.getMoney() or 0
                local bank = 0
                local bankAccount = xPlayer.getAccount('bank')
                if bankAccount then
                    bank = bankAccount.money or 0
                end

                playerData = {
                    name     = name,
                    id       = src,
                    job      = jobLabel,
                    ping     = GetPlayerPing(tostring(src)) or 0,
                    cid      = identifier,
                    phone    = phone,
                    gang     = gang,
                    cash     = fmtMoney(cash),
                    bank     = fmtMoney(bank),
                    playtime = fmtDuration(os.time() - (sessionStart[src] or os.time())),
                }
            end

            local xPlayers = ESX.GetExtendedPlayers()
            for _, xp in pairs(xPlayers) do
                count = count + 1
                players[#players + 1] = {
                    id   = xp.source,
                    name = xp.getName() or 'Bilinmeyen',
                    ping = GetPlayerPing(tostring(xp.source)) or 0,
                }
            end
        else
            -- Fallback standalone
            playerData = {
                name     = GetPlayerName(src) or 'Player',
                id       = src,
                job      = localeData.lbl_unemployed or 'İşsiz',
                ping     = GetPlayerPing(tostring(src)) or 0,
                cid      = '—',
                phone    = '—',
                gang     = localeData.lbl_none or 'Yok',
                cash     = '$0',
                bank     = '$0',
                playtime = fmtDuration(os.time() - (sessionStart[src] or os.time())),
            }
            
            for _, p in ipairs(GetPlayers()) do
                local pid = tonumber(p)
                if pid then
                    count = count + 1
                    players[#players + 1] = {
                        id   = pid,
                        name = GetPlayerName(pid) or 'Bilinmeyen',
                        ping = GetPlayerPing(tostring(pid)) or 0,
                    }
                end
            end
        end

        table.sort(players, function(a, b) return a.id < b.id end)
        serverData.players = count

        return {
            server = serverData,
            player = playerData,
            players = players,
            keys    = activeKeys,
            locale  = localeData
        }
end

RegisterNetEvent('nova-pausemenu:server:requestData', function()
    local src = source
    local now = GetGameTimer()
    local cached = lastMenuData[src]
    if cached and (now - cached.at) < 500 then
        TriggerClientEvent('nova-pausemenu:client:data', src, cached.data)
        return
    end
    local data = collectData(src)
    lastMenuData[src] = { at = now, data = data }
    TriggerClientEvent('nova-pausemenu:client:data', src, data)
end)

local githubRepo = 'msaber07/nova-pausemenu'

CreateThread(function()
    local localFile = LoadResourceFile(GetCurrentResourceName(), 'version.json')
    if not localFile then return end

    local localData = json.decode(localFile)
    if not localData or not localData.version then return end
    local currentVersion = localData.version

    PerformHttpRequest('https://raw.githubusercontent.com/' .. githubRepo .. '/main/version.json', function(statusCode, responseText)
        if statusCode == 200 and responseText then
            local data = json.decode(responseText)
            if data and data.version and data.version ~= currentVersion then
                print(('^3An update is available for %s (current version: %s)^7'):format(GetCurrentResourceName(), currentVersion))
                print(('^5https://github.com/%s/releases/tag/v%s^7'):format(githubRepo, data.version))
            end
        end
    end, 'GET', '', '')
end)

RegisterNetEvent('nova-pausemenu:server:disconnect', function()
    local src = source
    local activeReason = Config.DisconnectReason[Config.Locale] or Config.DisconnectReason['en']
    DropPlayer(src, activeReason or 'Çıkış yaptınız.')
end)
