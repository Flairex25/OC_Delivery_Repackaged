----!strict
-------------------------------------------------------------------------------------------------------------------------------
const shared = game:GetService("ReplicatedStorage").Shared
-------------------------------------------------------------------------------------------------------------------------------
--Classes
const Matrix = require(shared.Classes.Matrix)
-------------------------------------------------------------------------------------------------------------------------------
--Services
const ModuleService = require(shared.Services.ModuleService)
-------------------------------------------------------------------------------------------------------------------------------
local module = {} :: ModuleService.ServerModule
-------------------------------------------------------------------------------------------------------------------------------
module.params = {
	--["enabled"] = false, -- If false, the script is required but no functions are ran (Default: true)
	--["debugPrefix"] = script.Name, -- The name of the script that shows up in logs (Default: script.Name, script:GetFullName() if 'VerboseDebug' is true)
	--["debug"] = true, -- Toggles logs for module functions (Default: false)
	--["verboseDebug"] = true, -- Shows more specific information in module logs (Default: false)
	--["isClass"] = true, -- Tells the loader that the module is a class causing the require to be ignored (Default: false)
	--["className"] = "ClassName", -- If the module is a class, this acts as the type name of the class (Default: nil)
	--["isSubmodule"] = true, -- Tells the loader that this module is already required by another running module causing the require to be ignored (Default: false)
}
-------------------------------------------------------------------------------------------------------------------------------
--Yielding the thread above this point may cause the module to not load properly. module.Start() may be skipped, but module.Init() will always be called.
-------------------------------------------------------------------------------------------------------------------------------
function module.Init()
	return -1
end
-------------------------------------------------------------------------------------------------------------------------------
function module.Start()
	local m1 = Matrix(3,3)
	local m2 = Matrix(3,3)
	--
	m1:WriteRow({1,2,3}, 1)
	m1:WriteRow({4,5,6}, 2)
	m1:WriteRow({7,8,9}, 3)
	--
	m2:WriteRow({9,8,7}, 1)
	m2:WriteRow({6,5,4}, 2)
	m2:WriteRow({3,2,1}, 3)
	--
	print(m1)
	print(m2)
	print(m1 * m2)
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
