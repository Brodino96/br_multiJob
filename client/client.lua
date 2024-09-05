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
    local slots = lib.callback.await("br_multiJobs:getJobs", false, arr.id)

    for i = 1, Config.jobNum do
        options[i] = {
            title = "["..i.."] = "..slots[i],
            onSelect = OpenThirdMenu,
            args = { id = arr.id, job = slots[i], slot = i },
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

CreateThread(function ()
    TriggerEvent("chat:addSuggestion", "/jobmanager", "Opens menu to manage multijobs")
    for i = 1, Config.jobNum do
        TriggerEvent("chat:addSuggestion", "/setjob"..i, "Sets a job to the player", {
            { name = "playerId", help = "Server Id of the player"}, { name = "job", help = "Job to set" }
        })
    end
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

exports("getJobs", function ()
    return lib.callback.await("br_multiJobs:getJobs", false)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------