--!nocheck
---------------------------------------------------------------------------------------
--local shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Services
--local Service = game:GetService("Service")
---------------------------------------------------------------------------------------
--Classes
--local Class = require(shared.Classes.Class)
---------------------------------------------------------------------------------------
export type Stack<T> = {
	--------------------
	Type: "Stack",
	--------------------
	--Private
	--Data: { T },
	--Size: number,
	--------------------
	--Public
	GetSize: (self: Stack<T>) -> number,
	--------------------
	IsEmpty: (self: Stack<T>) -> boolean,
	--------------------
	Push: (self: Stack<T>, item: T) -> (),
	Pop: (self: Stack<T>) -> T?,
	Peek: (self: Stack<T>) -> T?,
	--------------------
}
---------------------------------------------------------------------------------------
local Stack = {} :: Stack<any>
Stack.Type = "Stack"
Stack.__index = Stack
---------------------------------------------------------------------------------------
const function Constructor<T>(): Stack<T>
	local self = (setmetatable({}, Stack) :: any) :: Stack<T>
	self.Data = {} :: { T }
	self.Size = 0
	return self
end
---------------------------------------------------------------------------------------
--Getters
function Stack.GetSize<T>(self: Stack<T>): number
	return self.Size
end
---------------------------------------------------------------------------------------
function Stack.IsEmpty<T>(self: Stack<T>): boolean
	return (self.Size == 0)
end
--
function Stack.Push<T>(self: Stack<T>, item: T)
	table.insert(self.Data, item)
	self.Size += 1
end
--
function Stack.Pop<T>(self: Stack<T>): T?
	if self:IsEmpty() then
		warn("Cannot Pop, stack is empty!")
		return nil
	end
	local item = self.Data[#self.Data]
	table.remove(self.Data, #self.Data)
	self.Size -= 1
	return item
end
--
function Stack.Peek<T>(self: Stack<T>): T?
	if self:IsEmpty() then
		warn("Cannot Pop, stack is empty!")
		return nil
	end
	return self.Data[#self.Data]
end
---------------------------------------------------------------------------------------
return Constructor
---------------------------------------------------------------------------------------
