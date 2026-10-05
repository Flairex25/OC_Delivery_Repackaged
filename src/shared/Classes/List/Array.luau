--!nonstrict
---------------------------------------------------------------------------------------
--const shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Services
--const Service = game:GetService("Service")
---------------------------------------------------------------------------------------
--Classes
--const Class = require(shared.Classes.Class)
--const List = require("../List")
--const Iterator = require("./Iterator")
---------------------------------------------------------------------------------------
--Class Type
export type ArrayClass = {
    ----------------------
    Type: "ArrayClass",
    ----------------------
    new: <T>(arrayCapacity: number?)->Array<T>,
    ----------------------
    --Methods to be used in class
    fromTable: <T>(data:{T})->Array<T>,
    ----------------------
}
---------------------------------------------------------------------------------------
local ArrayClass = {} :: ArrayClass
ArrayClass.__index = ArrayClass
---------------------------------------------------------------------------------------
--Array Type
export type Array<T> = {
    --------------------
    Type: "Array",
    --------------------
    --Private
    _size: number,
    _capacity: number,
    _data: {T},
    --------------------
    --Public
    GetSize: (self: Array<T>)->number,
    GetCapacity: (self: Array<T>)->number,
    Get: (self: Array<T>, index: number, range: number)->...T?,
    --------------------
    Insert: (self: Array<T>, index: number ,value: T)->() & (self: Array<T>, value: T)->(),
    Remove: (self: Array<T>, index: number)->T?,
    Find: (self: Array<T>, value: T)->...number?,
    IsEmpty: (self: Array<T>)->boolean,
    --------------------
    Iterate: (self: Array<T>, callback:(i:number, v:T)->(), from:number?, to:number?)->(),
    Sort: (self: Array<T>, compareFunction:(a:T,b:T)->boolean)->(),
    --------------------
    Emplace: (self: Array<T>, index: number, value: T)->() & (self:Array<T>, value: T)->(),
    Swap: (self: Array<T>, indexA: number, indexB: number)->(),
    Erase: (self: Array<T>, index: number, range: number)->(),
    Clear: (self: Array<T>)->(),
    --------------------
}
---------------------------------------------------------------------------------------
local Array = {} :: Array<any>
Array.__index = Array
---------------------------------------------------------------------------------------
--Private Functions

---------------------------------------------------------------------------------------
--Constructor
function ArrayClass.new<T>(arrayCapacity: number?): Array<T>
    local self = (setmetatable({}, Array) :: any) :: Array<T>
    self._data = {}
    self._size = 0
    self._capacity = arrayCapacity or 1
    self._capacity = math.max(self._capacity, 1)
    return self
end
--From Array
function ArrayClass.fromTable<T>(data:{T}): Array<T>
    local self = (setmetatable({}, Array) :: any) :: Array<T>
    self._data = data
    self._size = #data
    self._capacity = math.max(#data, 1)
    return self
end
---------------------------------------------------------------------------------------
--Getters
function Array.GetSize<T>(self: Array<T>): number
    return self._size
end
--
function Array.GetCapacity<T>(self: Array<T>): number
    return self._capacity
end
--
function Array.Get<T>(self: Array<T>, index: number, range: number?): ...T?
    if index < 1 or index > self:GetSize() then
        warn(`Cannot Get value! Index {index} is out of range! (1-{self:GetSize()})`)
        return
    end
    range = range or 1
    range = math.clamp(range::number, 1, self:GetSize() - index)
    local result = {}
    for i = 1, index + range::number - 1 do
        table.insert(result, self._data[i])
    end
    return table.unpack(result)
end
---------------------------------------------------------------------------------------
--Insert
function Array.Insert<T>(self: Array<T>, index: number | T, value: T?)
    if not value then
        value = index :: T
        index = math.clamp(self:GetSize() + 1,1,self:GetCapacity())
    end
    if index < 1 or index > self:GetSize() + 1 then
        warn(`Cannot Insert value! Index {index} is out of range! (1-{self:GetSize() + 1})`)
        return
    end
    self._data[index::number] = value::T
    self._size = self:GetSize()+1
    return
end
---------------------------------------------------------------------------------------
--Remove
function Array.Remove<T>(self: Array<T>, index: number)
    if self:IsEmpty() then
        warn(`Cannot remove values from empty array!`)
        return
    end
    if index < 1 or index > self:GetSize() then
        warn(`Cannot Remove value! Index {index} is out of range! (1-{self:GetSize()})`)
        return
    end
    table.remove(self._data, index)
end
---------------------------------------------------------------------------------------
--Find
function Array.Find<T>(self: Array<T>, value: T): ...number?
    local result = {}
    for i, v in ipairs(self._data) do
        if v == value then
            table.insert(result, i)
        end
    end
    return table.unpack(result)
end
---------------------------------------------------------------------------------------
--Is Empty
function Array.IsEmpty<T>(self: Array<T>): boolean
    return self:GetSize() == 0;
end
---------------------------------------------------------------------------------------
--Iterate
function Array.Iterate<T>(self: Array<T>, callback: (i:number, v:T)->(), from:number?, to:number?)
    if self:GetSize() == 0 then
        warn(`Cannot Iterate through empty array!`)
        return
    end
    from = from or 1
    to = to or self:GetSize()
    from = math.max(math.clamp(from::number,0,self:GetSize()), 1)
    to = math.max(math.clamp(to::number,0,self:GetSize()), 1)
    const sign = math.sign(to::number - from::number)
    if sign == 0 then
        warn(`Cannot iterate! Arguments 'to' and 'from' must be at least 1 index apart!`)
        return
    end
    for i = from::number, to::number, sign do
        callback(i, self._data[i])
    end
end
---------------------------------------------------------------------------------------
--Sort
function Array.Sort<T>(self:Array<T>, compareFunction:(a:T,b:T)->(boolean))
    self:Iterate(function(i:number, v:T)
        if i == self:GetSize() then
            return
        end
        const a = v
        const b = self._data[i + 1]
        if compareFunction(a, b) then
            self:Swap(i, i + 1)
        end
    end)
end
---------------------------------------------------------------------------------------
return ArrayClass
---------------------------------------------------------------------------------------