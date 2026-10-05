--!nonstrict
---------------------------------------------------------------------------------------
local shared = game:GetService("ReplicatedStorage").Shared
---------------------------------------------------------------------------------------
--Services
--const Service = game:GetService("Service")
---------------------------------------------------------------------------------------
--Classes
--const Class = require(shared.Classes.Class)
const List = require("../List")
const Signal = require(shared.Classes.Signal)
---------------------------------------------------------------------------------------
--Class Type
export type IteratorClass = {
    ----------------------
    Type: "IteratorClass",
    ----------------------
    new: <T>(list: List.List<T>)->Iterator<T>,
    ----------------------
}
---------------------------------------------------------------------------------------
local IteratorClass = {} :: IteratorClass
IteratorClass.__index = IteratorClass
---------------------------------------------------------------------------------------
--Iterator Type
export type Iterator<T> = {
    ----------------------
    Type: "Iterator",
    ----------------------
    --Private
    _head: number,
    _list: List.List<T>,
    _listSizeChanged: Signal.Signal<(number)>,
    ----------------------
    --Public
    Next: (self: Iterator<T>)->(T),
    Previous: (self: Iterator<T>)->(T),
    HasNext: (self: Iterator<T>)->(boolean),
    HasPrevious: (self: Iterator<T>)->(boolean),
    Remove: (self: Iterator<T>)->(T),
    ----------------------
}
---------------------------------------------------------------------------------------
local Iterator = {} :: Iterator<any>
Iterator.__index = Iterator
---------------------------------------------------------------------------------------
--Constructor
function IteratorClass.new<T>(list:List.List<T>): Iterator<T>
    local self = (setmetatable({}, Iterator) :: any) :: Iterator<T>
    self._head = 0
    self._list = list
    self._listSizeChanged = Signal()
    return self
end
---------------------------------------------------------------------------------------
--Next

---------------------------------------------------------------------------------------
return IteratorClass
---------------------------------------------------------------------------------------