----!strict
-------------------------------------------------------------------------------------------------------------------------------
const shared = game:GetService("ReplicatedStorage").Shared
-------------------------------------------------------------------------------------------------------------------------------
--Classes
--const Signal = require(shared.Classes.Signal)
-------------------------------------------------------------------------------------------------------------------------------
--Services
const RunService = game:GetService("RunService")
const UserInputService = game:GetService("UserInputService")
const ModuleService = require(shared.Services.ModuleService)
const LoadingService = require(shared.Services.LoadingService)
-------------------------------------------------------------------------------------------------------------------------------
local moduleList = {} :: { ModuleService.ClientModule }
local startList = {} :: { ModuleService.ClientModule }
local renderSteppedList = {} :: { ModuleService.ClientModule }
local heartbeatList = {} :: { ModuleService.ClientModule }
local inputBeganList = {} :: { ModuleService.ClientModule }
local inputEndedList = {} :: { ModuleService.ClientModule }
local inputChangedList = {} :: { ModuleService.ClientModule }
-------------------------------------------------------------------------------------------------------------------------------
local currentModuleID = 0
-------------------------------------------------------------------------------------------------------------------------------
--Process Return Codes
const function ProcessReturnCode(module: ModuleService.ClientModule, returnCode: number | nil, functionName: string)
	--
	if not module.params.debug and (returnCode ~= -2) then
		return
	end
	--
	if returnCode == nil or returnCode == 0 then
		--Standard Debug Message
		if not module.params.verboseDebug then
			print(
				module.params.uniqueID,
				" : Successfully completed",
				module.params.debugPrefix :: string .. "." .. functionName .. "() with exit code 0"
			)
		else
			--Verbose Debug Message
			print(
				module.params.uniqueID,
				": Successfully completed",
				module.params.debugPrefix :: string .. "." .. functionName .. "() with exit code 0",
				"(" .. module.params.directory :: string .. ") At:",
				os.time()
			)
		end
	elseif returnCode == -1 then
		return
	elseif returnCode == -2 then
		--Standard Debug Message
		if not module.params.verboseDebug then
			print(
				module.params.uniqueID,
				" : Successfully completed",
				module.params.debugPrefix :: string .. "." .. functionName .. "() with exit code -2"
			)
		else
			--Verbose Debug Message
			print(
				module.params.uniqueID,
				": Successfully completed",
				module.params.debugPrefix :: string .. "." .. functionName .. "() with exit code -2",
				"(" .. module.params.directory :: string .. ") At:",
				os.time()
			)
		end
	else
		--Standard Debug Message
		if not module.params.verboseDebug then
			warn(
				module.params.uniqueID,
				": Completed",
				module.params.debugPrefix :: string .. "." .. functionName .. "() with exit code",
				returnCode
			)
		else
			--Verbose Debug Message
			warn(
				module.params.uniqueID,
				": Completed",
				module.params.debugPrefix :: string .. "." .. functionName .. "() with exit code",
				returnCode,
				"(",
				module.params.directory,
				") At:",
				os.time()
			)
		end
	end
	--
end
-------------------------------------------------------------------------------------------------------------------------------
--Process Module Function PCall
const function ProcessModuleFunctionPCall(
	module: ModuleService.ClientModule,
	functionName: string,
	success: boolean,
	errorMsg: string,
	functionNameOverride: string?
)
	if success then
		table.insert(moduleList, module)
		if not module.params.verboseDebug then
			--Standard Debug Message
			print(functionName, module.params.debugPrefix)
		else
			--Verbose Debug Message
			print(
				(functionNameOverride and functionNameOverride or functionName),
				module.params.debugPrefix,
				"(",
				module.params.directory,
				") | Unique ID",
				module.params.uniqueID,
				"| At:",
				os.time()
			)
		end
	else
		warn("Failed to", functionName, module.params.directory, "|", errorMsg)
		return
	end
end
-------------------------------------------------------------------------------------------------------------------------------
const function AddModulesToList(moduleScript: ModuleScript)
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
	ProcessModuleFunctionPCall(module, "require", success, errorMsg, "Required")
	---------------------------------------------------
	if module.params.isClass or module.params.isSubmodule then
		return
	end
	---------------------------------------------------
	--Add methods
	if module.Init then
		local initSuccess, initErrorMsg = pcall(function()
			const returnCode = module.Init()
			ProcessReturnCode(module, returnCode, "Init")
		end)
		--
		ProcessModuleFunctionPCall(module, "initialize", initSuccess, initErrorMsg, "Initialized")
	end
	if module.Start then
		table.insert(startList, module)
	end
	if module.RenderStepped then
		table.insert(renderSteppedList, module)
	end
	if module.Heartbeat then
		table.insert(heartbeatList, module)
	end
	if module.InputBegan then
		table.insert(inputBeganList, module)
	end
	if module.InputEnded then
		table.insert(inputEndedList, module)
	end
	if module.InputChanged then
		table.insert(inputChangedList, module)
	end
	-- if (module.SceneBegin) then
	-- 	table.insert(sceneBeginList, module)
	-- end
	-- if (module.SceneEnded) then
	-- 	table.insert(sceneEndedList, module)
	-- end
	-- if (module.PlayerAdded) then
	-- 	table.insert(playerAddedList, module)
	-- end
	-- if (module.CharacterAdded) then
	-- 	table.insert(characterAddedList, module)
	-- end
	---------------------------------------------------
end
-------------------------------------------------------------------------------------------------------------------------------
--Add Modules
for _, moduleScript in ipairs(shared.Modules:GetDescendants()) do
	if moduleScript:IsA("ModuleScript") then
		coroutine.wrap(function()
			AddModulesToList(moduleScript)
		end)()
	end
end
-------------------------------------------------------------------------------------------------------------------------------
--Start
const function StartModule(module: ModuleService.ClientModule)
	--
	local player: Player | nil
	local character: Model | nil
	--
	if module.params.waitForPlayerLoaded then
		LoadingService.OnLocalPlayerLoaded:Connect(function(loadedPlayer: Player)
			player = loadedPlayer
		end)
		LoadingService.OnLocalPlayerLoaded:Wait()
	end
	if module.params.waitForCharacterLoaded then
		LoadingService.OnLocalCharacterLoaded:Connect(function(loadedPlayer: Player, loadedCharacter: Model)
			player = loadedPlayer
			character = loadedCharacter
		end)
		LoadingService.OnLocalCharacterLoaded:Wait()
	end
	--
	local success, errorMsg = pcall(function()
		const returnCode = module.Start(player, character)
		ProcessReturnCode(module, returnCode, "Start")
	end)
	--
	ProcessModuleFunctionPCall(module, "start", success, errorMsg, "Started")
end
--
for _, module in ipairs(startList) do
	coroutine.wrap(function()
		StartModule(module)
	end)()
end
-------------------------------------------------------------------------------------------------------------------------------
--RenderStepped
const function RenderSteppedModule(module: ModuleService.ClientModule, deltaTime: number)
	local success, errorMsg = pcall(function()
		const returnCode = module.RenderStepped(deltaTime)
		ProcessReturnCode(module, returnCode, "RenderStepped")
	end)
	--
	ProcessModuleFunctionPCall(module, "run RenderStepped", success, errorMsg, "Ran RenderStepped")
end
--
RunService.RenderStepped:Connect(function(deltaTime: number)
	for _, module in ipairs(renderSteppedList) do
		coroutine.wrap(function()
			RenderSteppedModule(module, deltaTime)
		end)()
	end
end)
-------------------------------------------------------------------------------------------------------------------------------
--Heartbeat
const function HeartbeatModule(module: ModuleService.ClientModule, deltaTime: number)
	local success, errorMsg = pcall(function()
		const returnCode = module.Heartbeat(deltaTime)
		ProcessReturnCode(module, returnCode, "Heartbeat")
	end)
	--
	ProcessModuleFunctionPCall(module, "run Heartbeat", success, errorMsg, "Ran Heartbeat")
end
--
RunService.Heartbeat:Connect(function(deltaTime: number)
	for _, module in ipairs(heartbeatList) do
		coroutine.wrap(function()
			HeartbeatModule(module, deltaTime)
		end)()
	end
end)
-------------------------------------------------------------------------------------------------------------------------------
--InputBegan
const function InputBeganModule(module: ModuleService.ClientModule, input: InputObject, gameProcessedEvent: boolean)
	local success, errorMsg = pcall(function()
		const returnCode = module.InputBegan(input, gameProcessedEvent)
		ProcessReturnCode(module, returnCode, "InputBegan")
	end)
	--
	ProcessModuleFunctionPCall(module, "run InputBegan", success, errorMsg, "Ran InputBegan")
end
--
UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	for _, module in ipairs(inputBeganList) do
		coroutine.wrap(function()
			InputBeganModule(module, input, gameProcessedEvent)
		end)()
	end
end)
-------------------------------------------------------------------------------------------------------------------------------
--InputEnded
const function InputEndedModule(module: ModuleService.ClientModule, input: InputObject, gameProcessedEvent: boolean)
	local success, errorMsg = pcall(function()
		const returnCode = module.InputEnded(input, gameProcessedEvent)
		ProcessReturnCode(module, returnCode, "InputEnded")
	end)
	--
	ProcessModuleFunctionPCall(module, "run InputEnded", success, errorMsg, "Ran InputEnded")
end
--
UserInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	for _, module in ipairs(inputEndedList) do
		coroutine.wrap(function()
			InputEndedModule(module, input, gameProcessedEvent)
		end)()
	end
end)
-------------------------------------------------------------------------------------------------------------------------------
--InputChanged
const function InputChangedModule(module: ModuleService.ClientModule, input: InputObject, gameProcessedEvent: boolean)
	local success, errorMsg = pcall(function()
		const returnCode = module.InputChanged(input, gameProcessedEvent)
		ProcessReturnCode(module, returnCode, "InputChanged")
	end)
	--
	ProcessModuleFunctionPCall(module, "run InputChanged", success, errorMsg, "Ran InputChanged")
end
--
UserInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	for _, module in ipairs(inputChangedList) do
		coroutine.wrap(function()
			InputChangedModule(module, input, gameProcessedEvent)
		end)()
	end
end)
-------------------------------------------------------------------------------------------------------------------------------
