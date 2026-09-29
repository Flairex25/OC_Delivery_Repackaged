----!strict
---------------------------------------------------------------------------------------
local LoadingService = {} :: LoadingService
LoadingService.Type = "LoadingService"
LoadingService.RequireServerLoad = true
---------------------------------------------------------------------------------------
const shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Classes
const Signal = require(shared.Classes.Signal)
const NetworkEvent = require(shared.Classes.NetworkEvent)
---------------------------------------------------------------------------------------
--Services
const RunService = game:GetService("RunService")
const Players = game:GetService("Players")
---------------------------------------------------------------------------------------
--Types
type LoadingService = {
	-----------------------
	Type: "LoadingService",
	RequireServerLoad: boolean,
	-----------------------
	OnLocalPlayerLoaded: Signal.Signal<Player>,
	OnLocalCharacterLoaded: Signal.Signal<(Player, Model)>,
	-----------------------
}
---------------------------------------------------------------------------------------
--Current Player Loaded
LoadingService.OnLocalPlayerLoaded = Signal() :: Signal.Signal<Player>
LoadingService.OnLocalCharacterLoaded = Signal() :: Signal.Signal<(Player, Model)>
--
const onPlayerLoaded = NetworkEvent("LoadingService.OnPlayerLoaded")
const onCharacterLoaded = NetworkEvent("LoadingService.OnCharacterLoaded")
--
if RunService:IsServer() then
	Players.PlayerAdded:Connect(function(player: Player)
		onPlayerLoaded:FireClient(player, player)
		player.CharacterAdded:Connect(function(character: Model)
			onCharacterLoaded:FireClient(player, player, character)
		end)
	end)
else
	onPlayerLoaded.OnClientEvent:Connect(function(player: Player)
		LoadingService.OnLocalPlayerLoaded:Fire(player)
	end)
	onCharacterLoaded.OnClientEvent:Connect(function(player: Player, character: Model)
		LoadingService.OnLocalCharacterLoaded:Fire(player, character)
	end)
end
---------------------------------------------------------------------------------------
return LoadingService
---------------------------------------------------------------------------------------
