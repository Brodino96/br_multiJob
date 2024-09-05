------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

ESX = exports["es_extended"]:getSharedObject()

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Functions

local function checkJob(job)
    for i = 1, #Config.jobs do
        if Config.jobs[i] == job then
            return true
        end
    end
    return false
end

local function getPlayerJobs(id)
    local response = MySQL.query.await("SELECT * FROM `br_multiJobs` WHERE `identifier` = ?", { ESX.GetPlayerFromId(id).getIdentifier() })
    local arr = {}

    for i = 1, (#response[1] - 1) do
        arr[i] = response[1][i+1]
    end
    return arr
end

-- /setjob1 [id] [job]
local function setJob(id, slot, job, source)
    if not checkJob(job) then
        return TriggerClientEvent("ox_lib:notify", source, { type = "error", title = "Il job selezionato non è configurato"})
    end
    local mysqlString = "UPDATE `br_multiJobs` SET `job"..tostring(slot).."` = ? WHERE `identifier` = ?"
    MySQL.update.await(mysqlString, {job, ESX.GetPlayerFromId(id).getIdentifier()})
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
AddEventHandler("br_multiJobs:setJob", setJob)

RegisterNetEvent("br_multiJobs:removeJob")
AddEventHandler("br_multiJobs:removeJob", setJob)

RegisterNetEvent("br_multiJobs:CreateTables")
AddEventHandler("br_multiJobs:CreateTables", function ()
    MySQL.insert.await("INSERT IGNORE INTO `br_multiJobs` (identifier) VALUES (?)", { ESX.GetPlayerFromId(source).getIdentifier() })
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Exports

exports("getJobs", function (id)
    return getPlayerJobs(id)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------