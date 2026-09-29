----!strict
-------------------------------------------------------------------------------------------------------------------------------
local shared = game:GetService("ReplicatedStorage").Shared
-------------------------------------------------------------------------------------------------------------------------------
--Classes
local Signal = require(shared.Classes.Signal)
-------------------------------------------------------------------------------------------------------------------------------
--Services
local ModuleService = require(shared.Services.ModuleService)
-------------------------------------------------------------------------------------------------------------------------------
local moduleList = {} :: {ModuleService.ClientModule}
local initList = {} :: {ModuleService.ClientModule}
local startList = {} :: {ModuleService.ClientModule}
local renderSteppedList = {} :: {ModuleService.ClientModule}
local heartbeatList = {} :: {ModuleService.ClientModule}
-------------------------------------------------------------------------------------------------------------------------------
local currentModuleID = 0
-------------------------------------------------------------------------------------------------------------------------------
local function AddModulesToList(moduleScript:ModuleScript)
    ------------------------------------------------------
    local module = {} :: ModuleService.ClientModule
    --
    local success, errorMsg = pcall(function()
        --
        module = require(moduleScript)
        --
        if module.params == nil then
            module.params = {} :: ModuleService.ModuleParams
        end
        if module.params.enabled == nil then
            module.params.enabled = true
        end
        if module.params.debug == nil then
            module.params.debug = false
        end
        if module.params.verboseDebug == nil then
            module.params.verboseDebug = false
        end
        module.params.name = moduleScript.Name
        module.params.directory = moduleScript:GetFullName()
        module.params.uniqueID = currentModuleID
        currentModuleID += 1
        if module.params.debugPrefix == nil then
            module.params.debugPrefix = module.params.name
        end
        if module.params.isClass == nil then
            module.params.isClass = false
        end
        if not module.params.isClass then
            module.params.className = nil
        end
    end)
    --
    if not success then
       warn("Could not load module:",errorMsg) 
    end
end
-------------------------------------------------------------------------------------------------------------------------------