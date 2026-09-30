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
export type Matrix = {
    ------------------
    Type: "Matrix",
    ------------------
    SizeX: number,
    SizeY: number,
    Data: {{number}},
    ------------------
    GetSizeX: (self:Matrix)->number;
    GetSizeY: (self:Matrix)->number;
    ------------------
    ReadRow: (self:Matrix, row:number)->{number},
    ReadCollumn: (self:Matrix, collumn:number)->{number},
    ReadElement: (self:Matrix, row:number, collumn:number)->number,
    WriteRow: (self:Matrix, rowData:{number}, row:number)->Matrix,
    WriteCollumn: (self:Matrix, collumnData:{number}, collumn:number)->Matrix,
    WriteElement: (self:Matrix, data:number, row:number, collumn:number)->Matrix,
    ResizeX: (self:Matrix, size:number)->Matrix,
    ResizeY: (self:Matrix, size:number)->Matrix,
    ------------------
}
---------------------------------------------------------------------------------------
local Matrix = {} :: Matrix
Matrix.Type = "Matrix"
Matrix.__index = Matrix
---------------------------------------------------------------------------------------
local function Constructor(SizeX:number?, SizeY:number?): Matrix
    local self = setmetatable({}, Matrix)
    self.SizeX = SizeX or 1
    self.SizeY = SizeY or 1
    self.Data = {}
    for y = 1, self.SizeY, 1 do
        self.Data[y] = {}
        for x = 1, self.SizeX, 1 do
            self.Data[y][x] = 0
        end
    end
    return self :: Matrix
end
---------------------------------------------------------------------------------------
const function CheckSizeX(matrix:Matrix, index:number): boolean
    if index < 1 or index > matrix.SizeX then
        const errorMsg = "Index " .. index .. " is out of Range! Value from 1-" .. matrix.SizeX .. " expected, got " .. index .. "."
        error(errorMsg)
        return true
    end
    return false
end
--
const function CheckSizeY(matrix:Matrix, index:number): boolean
    if index < 1 or index > matrix.SizeY then
        const errorMsg = "Index " .. index .. " is out of Range! Value from 1-" .. matrix.SizeY .. " expected, got " .. index .. "."
        error(errorMsg)
        return true
    end
    return false
end
---------------------------------------------------------------------------------------
--Read
function Matrix.ReadRow(self:Matrix, row:number): {number}
    row = math.clamp(row, 1, self.SizeY)
    return self.Data[row]
end
--
function Matrix.ReadCollumn(self:Matrix, collumn:number): {number}
    collumn = math.clamp(collumn, 1, self.SizeX)
    local result = {}
    for y = 1, self.SizeY, 1 do
        result[y] = self.Data[y][collumn]
    end
    return result
end
--
function Matrix.ReadElement(self:Matrix, row:number, collumn:number): number
    if CheckSizeX(self, collumn) or CheckSizeY(self, row) then
        return 0
    end
    return self.Data[row][collumn]
end
---------------------------------------------------------------------------------------
--Write
function Matrix.WriteRow(self:Matrix, rowData:{number}, row:number): Matrix
    if CheckSizeY(self, row) then
        return self
    end
    for x = 1, self.SizeX, 1 do
        self.Data[row][x] = rowData[x] or 0
    end
    return self
end
--
function Matrix.WriteCollumn(self:Matrix, collumnData:{number}, collumn:number): Matrix
    if CheckSizeX(self, collumn) then
        return self
    end
    for y = 1, self.SizeY, 1 do
        self.Data[y][collumn] = collumnData[y] or 0
    end
    return self
end
--
function Matrix.WriteElement(self: Matrix, data:number ,row:number, collumn:number): Matrix
    if CheckSizeX(self, collumn) or CheckSizeY(self, row) then
        return self
    end
    self.Data[row][collumn] = data
    return self
end
---------------------------------------------------------------------------------------
--Meta Methods
Matrix.__tostring = function(self:Matrix): string
    local result = ""
    for y = 1, self.SizeY, 1 do
        result += "\n["
        for x = 1, self.SizeX, 1 do
            result += tostring(self.Data[y][x])
            if x < self.SizeX then
                result += ", "
            end
        end
        result += "]\n"
    end
    return result
end
---
Matrix.__add = function(self:Matrix, other:Matrix): Matrix
    if typeof(other) ~= "number" then
        if self.SizeX ~= other.SizeX then
            error("Cannot add Matrices because X sizes " .. self.SizeX .. " and " .. other.SizeX .. " do not match!")
            return self
        end
        if self.SizeY ~= other.SizeY then
            error(
                "Cannot add Matrices because Y sizes " 
                .. self.SizeY 
                .. " and " 
                .. other.SizeY 
                .. " do not match!"
            )
            return self
        end
    end
    local newMatrix = Constructor(self.SizeX, self.SizeY)
    for y = 1, newMatrix.SizeY, 1 do
        for x = 1, newMatrix.SizeX, 1 do
            if typeof(other) == "number" then
                newMatrix.Data[y][x] = self.Data[y][x] + other
            else
                newMatrix.Data[y][x] = self.Data[y][x] + other.Data[y][x]
            end
        end
    end
    return newMatrix
end
--
Matrix.__sub = function(self:Matrix, other:Matrix|number): Matrix
    if typeof(other) ~= "number" then
        if self.SizeX ~= other.SizeX then
            error(
                "Cannot subtract Matrices because X sizes " 
                .. self.SizeX 
                .. " and " 
                .. other.SizeX 
                .. " do not match!"
            )
            return self
        end
        if self.SizeY ~= other.SizeY then
            error(
                "Cannot subtract Matrices because Y sizes " 
                .. self.SizeY 
                .. " and " 
                .. other.SizeY 
                .. " do not match!"
            )
            return self
        end
    end
    local newMatrix = Constructor(self.SizeX, self.SizeY)
    for y = 1, newMatrix.SizeY, 1 do
        for x = 1, newMatrix.SizeX, 1 do
            if typeof(other) == "number" then
                newMatrix.Data[y][x] = self.Data[y][x] - other
            else
                newMatrix.Data[y][x] = self.Data[y][x] - other.Data[y][x]
            end
        end
    end
    return newMatrix
end
--
const function dot(v1:{number},v2:{number}): number
    if #v1 == #v2 then
        local sum = 0
        for i = 1, #v1, 1 do
            sum += v1[i] * v2[i]
        end
        return sum
    else
        error("Lists must be the same size!")
        return 0
    end
end
--
Matrix.__mul = function(self:Matrix, other:Matrix|number): Matrix
    if typeof(other) == "number" then
        local newMatrix = Constructor(self.SizeX, self.SizeY)
        for y = 1, newMatrix.SizeY, 1 do
            for x = 1, newMatrix.SizeX, 1 do
                newMatrix.Data[y][x] = self.Data[y][x] * other
            end
        end
        return newMatrix
    else
        if self.SizeX ~= other.SizeY then
            error(
                "Cannot multply matrices because Matrix 1 X size " 
                .. self.SizeX
                .. " does not match Matrix 2 Y size " 
                .. other.SizeY
                .. "."
            )
            return self
        end
        local newMatrix = Constructor(other.SizeX,self.SizeY)
        for y = 1, newMatrix.SizeY, 1 do
            for x = 1, newMatrix.SizeX, 1 do
                local row = self:ReadRow(y)
                local collumn = self:ReadCollumn(x)
                self.Data[y][x] = dot(row, collumn)
            end
        end
        return newMatrix
    end
end
--
Matrix.__div = function(self:Matrix, other:number): Matrix
    local newMatrix = Constructor(self.SizeX, self.SizeY)
    for y = 1, newMatrix.SizeY, 1 do
        for x = 1, newMatrix.SizeX, 1 do
            newMatrix.Data[y][x] = self.Data[y][x] * other
        end
    end
    return newMatrix
end
---------------------------------------------------------------------------------------
return Constructor
---------------------------------------------------------------------------------------