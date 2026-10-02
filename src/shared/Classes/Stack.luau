--!nonstrict
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
    Data: {T},
    Size: number,
    --------------------
    IsEmpty: (self: Stack<T>)->(number),
    --------------------
    Push: (self: Stack<T>, item:T)->(),
    Pop: (self: Stack<T>)-> T?,
    Peek: (self: Stack<T>) -> T?,
    --------------------
}
---------------------------------------------------------------------------------------
local Stack = {} :: Stack<any>
Stack.Type = "Stack"
Stack.__index = Stack
---------------------------------------------------------------------------------------
const function Constructor<T>(firstElement:T?): Stack<T>
    local self = (setmetatable({}, Stack) :: any) :: Stack<T>
    self.Data = {} :: {T}
    if firstElement then
        table.insert(self.Data, firstElement)
    end
    self.Size = 0
    return self
end
---------------------------------------------------------------------------------------
function Stack.IsEmpty<T>(self: Stack<T>)
    return (#self.Data == 0)
end
--
function Stack.Push<T>(self:Stack<T>, item:T)
    table.insert(self.Data, item)
end
--
function Stack.Pop<T>(self:Stack<T>): T?
    if self:IsEmpty() then
        warn("Cannot Pop, stack is empty!")
        return nil
    end
    local item = self.Data[#self.Data]
    table.remove(self.Data, #self.Data)
    return item
end
--
function Stack.Peek<T>(self:Stack<T>): T?
    if self:IsEmpty() then
        warn("Cannot Pop, stack is empty!")
        return nil
    end
    return self.Data[#self.Data]
end
---------------------------------------------------------------------------------------
return Constructor
---------------------------------------------------------------------------------------