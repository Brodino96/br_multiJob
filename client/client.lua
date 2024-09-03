------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

function OpenJobManager()

    local options = {}
    local players = lib.callback.await("br_multiJobs:getPlayers", false)

    for i = 1, #players do
        local player = players[i]
        options[i] = {
            title = "["..player.id.."] - "..player.name,
            onSelect = OpenSecondMenu,
            args = { id = player.id}
        }
    end

    lib.registerContext({
        id = "jobManager",
        title = "Job Manager",
        canClose = true,
        options = options
    })

    lib.showContext("jobManager")
end

-----------------------------------

function OpenSecondMenu(arr)

    local options = {}
    local slots = lib.callback.await("br_multiJobs:getSlots", false, arr.id)
    slots = slots[1]

    for i = 1, 3 do
        options[i] = {
            title = "["..i.."] = "..slots["job"..tostring(i)],
            onSelect = OpenThirdMenu,
            args = { id = arr.id, job = slots["job"..tostring(i)], slot = i },
        }
    end

    lib.registerContext({
        id = "slotSelector",
        title = "Job Selector",
        canClose = true,
        options = options
    })

    lib.showContext("slotSelector")
end

-----------------------------------

function OpenThirdMenu(arr)

    local options = { [1] = { title = "Remove", onSelect = RemoveJob, args = { id = arr.id, slot = arr.slot } }}

    for i = 1, #Config.jobs do
        options[i+1] = {
            title = "SetJob: "..Config.jobs[i],
            onSelect = SetJob,
            args = { job = Config.jobs[i], id = arr.id, slot = arr.slot },
            argst = Config.jobs[i]
        }
    end

    lib.registerContext({
        id = "actionSelector",
        title = arr.job,
        canClose = true,
        options = options
    })

    lib.showContext("actionSelector")
end

-----------------------------------

function SetJob(arr)
    TriggerServerEvent("br_multiJobs:setJob", arr.id, arr.slot, arr.job)
end

function RemoveJob(arr)
    TriggerServerEvent("br_multiJobs:removeJob", arr.id, arr.slot)
end

-----------------------------------

function CreateTables()
    TriggerServerEvent("br_multiJobs:CreateTables")
end

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

RegisterNetEvent("br_multiJobs:openJobManager")
AddEventHandler("br_multiJobs:openJobManager", OpenJobManager)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", CreateTables)

RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function (rname)
    if rname ~= GetCurrentResourceName() then
        return
    end

    CreateTables()
end)

CreateThread(function ()
    TriggerEvent("chat:addSuggestion", "/jobmanager", "Apre il menù per la gestione dei multijob")
    TriggerEvent("chat:addSuggestion", "/setjob1", "Setta un job al giocatore", {
        { name = "playerId", help = "Id del giocatore"}, { name = "job", help = "Job da settare" }
    })
    TriggerEvent("chat:addSuggestion", "/setjob2", "Setta un job al giocatore", {
        { name = "playerId", help = "Id del giocatore"}, { name = "job", help = "Job da settare" }
    })
    TriggerEvent("chat:addSuggestion", "/setjob3", "Setta un job al giocatore", {
        { name = "playerId", help = "Id del giocatore"}, { name = "job", help = "Job da settare" }
    })
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

exports("getJobs", function ()
    local arr = lib.callback.await("br_multiJobs:getSlots", false, GetPlayerServerId(PlayerId()))
    return { [1] = arr.job1, [2] = arr.job2, [3] = arr.job3 }
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------