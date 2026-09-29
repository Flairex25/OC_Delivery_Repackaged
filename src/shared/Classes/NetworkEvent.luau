----!strict
---------------------------------------------------------------------------------------
local shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Services
local RunService = game:GetService("RunService")
---------------------------------------------------------------------------------------
--Classes
local Signal = require(shared.Classes.Signal)
---------------------------------------------------------------------------------------
--Types
export type NetworkEvent<A... = (), B... = ()> = {
	--
	Type: "NetworkEvent",
	Name: string,
	--
	FireClient: (self: NetworkEvent<A..., B...>, player: Player, A...) -> (),
	FireServer: (self: NetworkEvent<A..., B...>, B...) -> (),
	--
	OnClientEvent: Signal.Signal<A...>,
	OnServerEvent: Signal.Signal<(Player, B...)>,
	--
}
---------------------------------------------------------------------------------------
local NetworkEvent = {}
--
NetworkEvent.__index = NetworkEvent
NetworkEvent.Type = "NetworkEvent"
---------------------------------------------------------------------------------------
local remoteEvent: RemoteEvent
local eventList = {} :: { [string]: NetworkEvent }
---------------------------------------------------------------------------------------
function Constructor<A..., B...>(eventName: string): NetworkEvent<A..., B...>
	--
	local networkEvent = eventList[eventName] :: NetworkEvent<A..., B...>
	if networkEvent then
		return networkEvent
	end
	networkEvent = (setmetatable({}, NetworkEvent) :: any) :: NetworkEvent<A..., B...>
	networkEvent.Name = eventName
	--
	networkEvent.OnClientEvent = Signal() :: Signal.Signal<A...>
	networkEvent.OnServerEvent = Signal() :: Signal.Signal<(Player, B...)>
	--
	eventList[networkEvent.Name] = networkEvent
	--
	return networkEvent
end
---------------------------------------------------------------------------------------
function NetworkEvent:FireServer(...)
	--
	if RunService:IsClient() then
		remoteEvent:FireServer(self.Name, ...)
	else
		error("Cannot run FireServer from the Server!")
	end
end
--
function NetworkEvent:FireClient(player, ...)
	--
	if RunService:IsServer() then
		remoteEvent:FireClient(player, self.Name, ...)
	else
		error("Cannot run FireClient from the Client!")
	end
end
---------------------------------------------------------------------------------------
--Initialize RemoteEvent
if RunService:IsServer() then
	--Server
	remoteEvent = script:FindFirstChild("RemoteEvent") or Instance.new("RemoteEvent") :: RemoteEvent
	remoteEvent.Parent = script
	--
	local function OnServerEvent(player: Player, eventName: string, ...: any)
		--
		local networkEvent = eventList[eventName]
		if not networkEvent then
			return
		end
		networkEvent.OnServerEvent:Fire(player, ...)
	end
	remoteEvent.OnServerEvent:Connect(OnServerEvent)
	--
else
	--Client
	remoteEvent = script:FindFirstChild("RemoteEvent") or Instance.new("RemoteEvent") :: RemoteEvent
	remoteEvent.Parent = script
	--
	local function OnClientEvent(eventName: string, ...: any)
		--
		local networkEvent = eventList[eventName]
		if not networkEvent then
			return
		end
		networkEvent.OnClientEvent:Fire(...)
	end
	remoteEvent.OnClientEvent:Connect(OnClientEvent)
end
---------------------------------------------------------------------------------------
return Constructor
---------------------------------------------------------------------------------------
