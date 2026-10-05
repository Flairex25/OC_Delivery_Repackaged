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
export type Array<T> = {
	--------------------
	Type: "Array",
	--------------------
	--Private
	_Capacity: number,
	_Size: number,
	Data: { T },
	--------------------
	--Public
	GetSize: (self: Array<T>) -> number,
	GetCapacity: (self: Array<T>) -> number,
	--------------------
	Get: (self: Array<T>, index: number, range: number?) -> ...T?,
	--------------------
	Insert: (self: Array<T>, index: number, item: T) -> () & (self: Array<T>, item: T) -> (),
	Remove: (self: Array<T>, index: number) -> T?,
	Find: (self: Array<T>, item: T) -> ...number?,
	IsEmpty: (self: Array<T>) -> boolean,
	--------------------
	Sort: (self: Array<T>, compareFunction: (a: T, b: T) -> boolean) -> (),
	--------------------
	Emplace: (self: Array<T>, index: number, item: T) -> () & (self: Array<T>, item: T) -> (),
	Swap: (self: Array<T>, index1: number, index2: number) -> (),
	Erase: (self: Array<T>, index: number, range: number) -> (),
	Clear: (self: Array<T>) -> (),
	--------------------
}
---------------------------------------------------------------------------------------
local Array = {} :: Array<any>
Array.Type = "Array"
Array.__index = Array
---------------------------------------------------------------------------------------
const function Constructor<T>(size: number): Array<T>
	local self = (setmetatable({}, Array) :: any) :: Array<T>
	self.Data = {} :: { T }
	self._Size = 0
	self._Capacity = size or 1
	return self
end
---------------------------------------------------------------------------------------
--Getters
function Array.GetSize<T>(self: Array<T>): number
	return self._Size
end
function Array.GetCapacity<T>(self: Array<T>): number
	return self._Capacity
end
---------------------------------------------------------------------------------------
--Get
function Array.Get<T>(self: Array<T>, index: number, range: number?): ...T?
	if index < 1 or index > self._Size then
		warn("Index " .. index .. " out of bounds!")
		return
	end
	if range then
		if range < 1 then
			warn("Range must be greater than 0!")
			return
		end
		local items: { T } = {}
		for i = index, math.min(index + range - 1, self._Size) do
			table.insert(items, self.Data[i])
		end
		return table.unpack(items)
	end
	return self.Data[index]
end
---------------------------------------------------------------------------------------
--Insert
function Array.Insert<T>(self: Array<T>, index: number | T, item: T?)
	if not item then
		item = index :: T
		index = self._Size + 1
	end
	if index < 1 or index > self._Capacity then
		warn("Index " .. index .. " out of bounds!")
		return
	end
	self.Data[index :: number] = item :: T
	self._Size += 1
end
--Remove
function Array.Remove<T>(self: Array<T>, index: number): T?
	if index < 1 or index > self._Size then
		warn("Index " .. index .. " out of bounds!")
		return
	end
	local item = self.Data[index]
	for i = index, self._Size do
		self.Data[i] = self.Data[i + 1]
	end
	self._Size -= 1
	return item
end
--Find
function Array.Find<T>(self: Array<T>, item: T): ...number?
	local indices: { number } = {}
	for i, v in ipairs(self.Data) do
		if v == item then
			table.insert(indices, i)
		end
	end
	return table.unpack(indices)
end
--IsEmpty
function Array.IsEmpty<T>(self: Array<T>): boolean
	return (self._Size == 0)
end
---------------------------------------------------------------------------------------
--Sort
function Array.Sort<T>(self: Array<T>, compareFunction: (a: T, b: T) -> boolean)
	for _ = 1, self._Size do
		for j = 1, self._Size - 1 do
			if compareFunction(self.Data[j + 1], self.Data[j]) then
				self:Swap(j, j + 1)
			end
		end
	end
end
---------------------------------------------------------------------------------------
--Emplace
function Array.Emplace<T>(self: Array<T>, index: number | T, item: T?)
	if not item then
		item = index :: T
		index = self._Size + 1
	end
	if index < 1 or index > self._Capacity + 1 then
		warn("Index " .. index .. " out of bounds!")
		return
	end
	for i = self._Size, index, -1 do
		self.Data[i + 1] = self.Data[i]
	end
	self.Data[index :: number] = item :: T
	self._Size += 1
	self._Capacity = self._Size
end
--Swap
function Array.Swap<T>(self: Array<T>, index1: number, index2: number)
	if index1 < 1 or index1 > self._Size or index2 < 1 or index2 > self._Size then
		warn("Index out of bounds!")
		return
	end
	local temp = self.Data[index1]
	self.Data[index1] = self.Data[index2]
	self.Data[index2] = temp
end
--Erase
function Array.Erase<T>(self: Array<T>, index: number, range: number)
	if index < 1 or index > self._Size then
		warn("Index out of bounds!")
		return
	end
	if range < 1 then
		warn("Range must be greater than 0!")
		return
	end
	range = math.min(range, self._Size - index + 1)
	for i = index + range - 1, index, -1 do
		self:Remove(i)
	end
end
--Clear
function Array.Clear<T>(self: Array<T>)
	self.Data = {}
	self._Size = 0
	self._Capacity = 1
end
---------------------------------------------------------------------------------------
--To String
function Array.__tostring<T>(self: Array<T>): string
	local str = "{"
	for i, v in ipairs(self.Data) do
		str ..= tostring(v)
		if i < self._Size then
			str ..= ", "
		end
	end
	str ..= "}"
	return str
end
--Length
function Array.__len<T>(self: Array<T>): number
	return self._Size
end
---------------------------------------------------------------------------------------
return Constructor
---------------------------------------------------------------------------------------
