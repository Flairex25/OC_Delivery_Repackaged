--!strict
---------------------------------------------------------------------------------------
local ModuleService = {}
---------------------------------------------------------------------------------------
local shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Types
export type ClientModule = {
	---------------------
	params: ModuleParams,
	-----------------------------------
	Init: (...any?) -> number | nil,
	Start: (...any?) -> number | nil,
	RenderStepped: (deltaTime: number) -> number | nil,
	Heartbeat: (deltaTime: number) -> number | nil,
	InputBegan: (input: InputObject) -> number | nil,
	InputEnded: (input: InputObject) -> number | nil,
	InputChanged: (input: InputObject) -> number | nil,
	SceneBegin: (sceneID: string) -> number | nil,
	SceneEnded: (sceneID: string) -> number | nil,
	PlayerAdded: (...any?) -> number | nil,
	CharacterAdded: (character: Model) -> number | nil,
	[string]: (...any?) -> ...any?,
	----------------------------------
}
--
export type ServerModule = {
	---------------------
	params: ModuleParams,
	----------------------------------
	Init: (...any?) -> number?,
	Start: (...any?) -> number?,
	PlayerAdded: (...any?) -> number?,
	CharacterAdded: (character: Model) -> number?,
	[string]: (...any?) -> ...any?,
	----------------------------------
}
--
export type ModuleParams = {
	-----------------------
	uniqueID: number?,
	enabled: boolean?,
	debug: boolean?,
	verboseDebug: boolean?,
	directory: string?,
	name: string?,
	debugPrefix: string?,
	isClass: boolean?,
	className: string?,
	isSubmodule: boolean?,
	-----------------------
}
---------------------------------------------------------------------------------------
local _Signal = require(shared.Classes.Signal)
local _NetworkEvent = require(shared.Classes.NetworkEvent)
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
return ModuleService
---------------------------------------------------------------------------------------