--!strict
-------------------------------------------------------------------------------------------------------------------------------
const shared = game:GetService("ReplicatedStorage").Shared
-------------------------------------------------------------------------------------------------------------------------------
--Classes
--const Class = require(shared.Classes.Class)
-------------------------------------------------------------------------------------------------------------------------------
--Services
const ModuleService = require(shared.Services.ModuleService)
-------------------------------------------------------------------------------------------------------------------------------
local module = {} :: ModuleService.ClientModule
-------------------------------------------------------------------------------------------------------------------------------
module.params = {
	--["enabled"] = false, -- If false, the script is required but no functions are ran (Default: true)
	--["debugPrefix"] = script.Name, -- The name of the script that shows up in logs (Default: script.Name, script:GetFullName() if 'VerboseDebug' is true)
	--["debug"] = true, -- Toggles logs for module functions (Default: false)
	--["verboseDebug"] = true, -- Shows more specific information in module logs (Default: false)
	--["isClass"] = true, -- Tells the loader that the module is a class causing the require to be ignored (Default: false)
	--["className"] = "ClassName", -- If the module is a class, this acts as the type name of the class (Default: nil)
	--["isSubmodule"] = true, -- Tells the loader that this module is already required by another running module causing the require to be ignored (Default: false)
	--["waitForPlayerLoaded"] = true, -- Tells the loader to wait for the client to be loaded before running 'Start'. Adds 'player' parameter into 'Start()' (Default: false)
	--["waitForCharacterLoaded"] = true, -- Tells the loader to wait for the client's character to be loaded before running 'Start'. Adds 'player' and 'character' parameters into 'Start()' (Default: false)
}
-------------------------------------------------------------------------------------------------------------------------------
--Yielding the thread above this point may cause the module to not load properly. module.Start() may be skipped, but module.Init() will always be called.
-------------------------------------------------------------------------------------------------------------------------------
function module.Init()
	return -1
end
-------------------------------------------------------------------------------------------------------------------------------
function module.Start(_param1: (Player | PlayerGui | any)?, _param2: (Model | any)?)
	--

	--
	return -1
end
-------------------------------------------------------------------------------------------------------------------------------
return module
-------------------------------------------------------------------------------------------------------------------------------
--Return Code 0 (or nil): Success | Returns success print or nothing if Debug is off
--Return Code -1: Success | Forces no print even if Debug is on
--Return Code -2: Success | Forces a print even if Debug is off
--Return Code >0: Failure | Forces a warning
-------------------------------------------------------------------------------------------------------------------------------
