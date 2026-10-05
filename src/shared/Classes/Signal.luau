--!nocheck
---------------------------------------------------------------------------------------
local shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Services
local TaskService = require(shared.Services.TaskService)
---------------------------------------------------------------------------------------
--Types
export type Signal<T...> = {
	--
	Type: "Signal",
	Previous: Connection<T...> | Signal<T...>,
	Next: Connection<T...> | Signal<T...>,
	Fire: (self: Signal<T...>, T...) -> (),
	Connect: <A>(self: Signal<T...>, func: (T...) -> (), ...A?) -> Connection<T...>,
	Once: (self: Signal<T...>, func: (T...) -> ()) -> Connection<T...>,
	Wait: (self: Signal<T...>) -> T...,
	--
}
--
export type Connection<T...=(),A...=()> = {
	--
	Type: "Connection",
	Previous: Connection<T...,A...>,
	Next: Connection<T...,A...>,
	Once: boolean,
	Args: {A},
	Function: (T...) -> (),
	Thread: thread,
	Disconnect: (self: Connection<T...>) -> (),
	--
}
---------------------------------------------------------------------------------------
local Signal = {}
local Connection = {}
--
Signal.__index = Signal
Connection.__index = Connection
--
Signal.Type = "Signal"
Connection.Type = "Connection"
---------------------------------------------------------------------------------------
--Signal Constructor
function Constuctor<T...>()
	local signal = (setmetatable({}, Signal) :: any) :: Signal<T...>
	signal.Previous = signal
	signal.Next = signal
	return signal
end
---------------------------------------------------------------------------------------
function Signal.Connect<T...,A...>(self: Signal<T...>, fn: (T...) -> (),...:A): Connection<T...,A...>
	local connection = (setmetatable({}, Connection) :: any) :: Connection<T...>
	connection.Previous = self.Previous
	connection.Next = self
	connection.Once = false
	connection.Args = {...}
	connection.Function = fn
	self.Previous.Next = connection
	self.Previous = connection
	return connection
end
--
function Signal.Once<T...,A...>(self: Signal<T...>, fn: (T...) -> (), ...:A): Connection<T...,A...>
	local connection = (setmetatable({}, Connection) :: any) :: Connection<T...,A...>
	connection.Previous = self.Previous
	connection.Next = self
	connection.Once = true
	connection.Args = {...}
	connection.Function = fn
	self.Previous.Next = connection
	self.Previous = connection
	return connection
end
--
function Signal.Wait<T...,A...>(self: Signal<T...>)
	local connection = (setmetatable({}, Connection) :: any) :: Connection<T...,A...>
	connection.Previous = self.Previous
	connection.Next = self
	connection.Once = true
	connection.Thread = coroutine.running()
	self.Previous.Next = connection
	self.Previous = connection
	return coroutine.yield()
end
--
function Signal.Fire<T...,A...>(self: Signal<T...>, ...: T)
	local connection = self.Next :: Connection<T...,A...>
	while connection.Type == "Connection" do
		if connection.Function then
			TaskService:Defer(connection.Function, ..., table.unpack(connection.Args))
		else
			TaskService:Defer(connection.Thread, ..., table.unpack(connection.Args))
		end
		if connection.Once then
			connection.Previous.Next = connection.Next
			connection.Next.Previous = connection.Previous
		end
		connection = connection.Next
	end
end
---------------------------------------------------------------------------------------
function Connection.Disconnect<T...>(self: Connection<T...>)
	self.Previous.Next = self.Next
	self.Next.Previous = self.Previous
end
---------------------------------------------------------------------------------------
return Constuctor
---------------------------------------------------------------------------------------
