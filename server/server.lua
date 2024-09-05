------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

ESX = exports["es_extended"]:getSharedObject()

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Functions

local function checkJob(job)
    if job == "" then
        return true
    end
    for i = 1, #Config.jobs do
        if Config.jobs[i] == job then
            return true
        end
    end
    return false
end

local function getPlayerJobs(id)
    local response = MySQL.query.await("SELECT * FROM `br_multiJobs` WHERE `identifier` = ?", { ESX.GetPlayerFromId(id).getIdentifier() })[1]
    local arr = {}

    for i = 1, Config.jobNum do
        arr[i] = response["job"..i]
    end
    Debug("GetPlayerJob: ["..id.."] "..json.encode(arr))
    return arr
end

-- /setjob1 [id] [job]
local function setJob(id, slot, job, sorgente)
    if not checkJob(job) then
        return TriggerClientEvent("ox_lib:notify", sorgente, { type = "error", title = "Il job selezionato non è configurato"})
    end
    local mysqlString = "UPDATE `br_multiJobs` SET `job"..tostring(slot).."` = ? WHERE `identifier` = ?"
    local response = MySQL.update.await(mysqlString, {job, ESX.GetPlayerFromId(id).getIdentifier()})
    TriggerClientEvent("ox_lib:notify", sorgente, { type = "success", title = "Job cambiato con successo"})
end

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Commands

for i = 1, Config.jobNum do
    RegisterCommand("setjob"..i, function (source, args)
        setJob(args[1], i, args[2], source)
    end, true)
end

RegisterCommand("jobmanager", function (source)
    TriggerClientEvent("br_multiJobs:openJobManager", source)
end, true)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Callbacks

lib.callback.register("br_multiJobs:getPlayers", function ()
    local list = {}
    local xPlayers = ESX.GetExtendedPlayers()

    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        list[i] = {
            name = xPlayer.getName(),
            id = xPlayer.source
        }
    end

    return list
end)

lib.callback.register("br_multiJobs:getJobs", function (source, target)
    local id = target or source
    return getPlayerJobs(id)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Events

RegisterNetEvent("br_multiJobs:setJob")
AddEventHandler("br_multiJobs:setJob", function (id, slot, job)
    setJob(id, slot, job, source)
end)

RegisterNetEvent("br_multiJobs:removeJob")
AddEventHandler("br_multiJobs:removeJob", function (id, slot)
    setJob(id, slot, "", source)
end)

RegisterNetEvent("br_multiJobs:CreateTables")
AddEventHandler("br_multiJobs:CreateTables", function ()
    MySQL.insert.await("INSERT IGNORE INTO `br_multiJobs` (identifier) VALUES (?)", { ESX.GetPlayerFromId(source).getIdentifier() })
end)

RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function (name)
    if name ~= GetCurrentResourceName() then
        return
    end
    local xPlayers = ESX.GetExtendedPlayers()
    for i = 1, #xPlayers do
        MySQL.insert.await("INSERT IGNORE INTO `br_multiJobs` (identifier) VALUES (?)", { xPlayers[i].getIdentifier() })
    end
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Exports

exports("getJobs", function (id)
    return getPlayerJobs(id)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------