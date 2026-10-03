--!nocheck
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
export type NetworkEvent<Server... = (), Client... = (), Shared... = ()> = {
	----------------------------------------------
	Type: "NetworkEvent",
	----------------------------------------------
	--Private
	--Name: string,
	----------------------------------------------
	--Public
	GetName: (self: NetworkEvent<Server..., Client..., Shared...>) -> string,
	----------------------------------------------
	FireClient: (self: NetworkEvent<Server..., Client..., Shared...>, player: Player, Client...) -> (),
	FireServer: (self: NetworkEvent<Server..., Client..., Shared...>, Server...) -> (),
	FireEvent: (self: NetworkEvent<Server..., Client..., Shared...>, Shared...) -> (),
	----------------------------------------------
	OnClientEvent: Signal.Signal<Client...>,
	OnServerEvent: Signal.Signal<(Player, Server...)>,
	OnEvent: Signal.Signal<Shared...>,
	----------------------------------------------
}
---------------------------------------------------------------------------------------
local NetworkEvent = {}
--
NetworkEvent.__index = NetworkEvent
NetworkEvent.Type = "NetworkEvent"
---------------------------------------------------------------------------------------
const remoteEvent: RemoteEvent = script:FindFirstChild("RemoteEvent") or Instance.new("RemoteEvent") :: RemoteEvent
const bindableEvent: BindableEvent = script:FindFirstChild("Event") or Instance.new("BindableEvent") :: BindableEvent
local eventList = {} :: { [string]: NetworkEvent }
--
remoteEvent.Parent = script
bindableEvent.Parent = script
---------------------------------------------------------------------------------------
function Constructor<Server..., Client..., Shared...>(eventName: string): NetworkEvent<Server..., Client..., Shared...>
	--
	local networkEvent = eventList[eventName] :: NetworkEvent<Server..., Client..., Shared...>
	if networkEvent then
		return networkEvent
	end
	networkEvent = (setmetatable({}, NetworkEvent) :: any) :: NetworkEvent<Server..., Client..., Shared...>
	networkEvent.Name = eventName
	--
	networkEvent.OnClientEvent = Signal() :: Signal.Signal<Client...>
	networkEvent.OnServerEvent = Signal() :: Signal.Signal<(Player, Server...)>
	networkEvent.OnEvent = Signal() :: Signal.Signal<Shared...>
	--
	eventList[networkEvent.Name] = networkEvent
	--
	return networkEvent
end
---------------------------------------------------------------------------------------
--Getters
function NetworkEvent.GetName<Server..., Client..., Shared...>(self: NetworkEvent<Server..., Client..., Shared...>): string
	return self.Name
end
---------------------------------------------------------------------------------------
--Fire Server
function NetworkEvent.FireServer<Server..., Client..., Shared...>(self: NetworkEvent<Server..., Client..., Shared...>, ...)
	--
	if RunService:IsClient() then
		remoteEvent:FireServer(self.Name, ...)
	else
		error("Cannot run FireServer from the Server!")
	end
end
--Fire Client
function NetworkEvent.FireClient<Server..., Client..., Shared...>(self: NetworkEvent<Server..., Client..., Shared...>, player: Player, ...: Client)
	--
	if RunService:IsServer() then
		remoteEvent:FireClient(player, self.Name, ...)
	else
		error("Cannot run FireClient from the Client!")
	end
end
--Fire Event
function NetworkEvent.FireEvent<Server..., Client..., Shared...>(self: NetworkEvent<Server..., Client..., Shared...>, ...: Shared)
	--
	bindableEvent:Fire(self.Name, ...)
end
---------------------------------------------------------------------------------------
--Bindable Event
const function OnBindableEvent(eventName: string, ...)
	--
	local networkEvent = eventList[eventName]
	if not networkEvent then
		return
	end
	networkEvent.OnEvent:Fire(...)
end
--
bindableEvent.Event:Connect(OnBindableEvent)
--
if RunService:IsServer() then
	--Server
	const function OnServerEvent(player: Player, eventName: string, ...: any)
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
	const function OnClientEvent(eventName: string, ...: any)
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
