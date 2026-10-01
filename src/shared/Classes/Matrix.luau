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
	-------------------
	Type: "Matrix",
	-------------------
	--Private
	SizeX: number,
	SizeY: number,
	Data: { { number } },
	-------------------
	--Public
	GetSizeX: (self: Matrix) -> number,
	GetSizeY: (self: Matrix) -> number,
	GetElement: (self: Matrix, x: number, y: number) -> number,
	GetRow: (self: Matrix, y: number) -> { number },
	GetColumn: (self: Matrix, x: number) -> { number },
	-------------------
	SetSizeX: (self: Matrix, sizeX: number) -> (),
	SetSizeY: (self: Matrix, sizeY: number) -> (),
	SetElement: (self: Matrix, x: number, y: number, value: number) -> (),
	SetRow: (self: Matrix, y: number, row: { number }) -> (),
	SetColumn: (self: Matrix, x: number, column: { number }) -> (),
	-------------------
}
---------------------------------------------------------------------------------------
local Matrix = {} :: Matrix
Matrix.Type = "Matrix"
Matrix.__index = Matrix
---------------------------------------------------------------------------------------
const function Constructor(sizeX: number?, sizeY: number?): Matrix
	local self = setmetatable({}, Matrix)
	self.SizeX = sizeX or 1
	self.SizeY = sizeY or 1
	self.Data = {}
	for y = 1, self.SizeY do
		self.Data[y] = {}
		for x = 1, self.SizeX do
			self.Data[y][x] = 0
		end
	end
	return self :: Matrix
end
---------------------------------------------------------------------------------------
function Matrix.GetSizeX(self: Matrix): number
	return self.SizeX
end
--
function Matrix.GetSizeY(self: Matrix): number
	return self.SizeY
end
--
function Matrix.GetElement(self: Matrix, x: number, y: number): number
	x = math.clamp(x, 1, self.SizeX)
	y = math.clamp(y, 1, self.SizeY)
	return self.Data[y][x]
end
--
function Matrix.GetRow(self: Matrix, y: number): { number }
	y = math.clamp(y, 1, self.SizeY)
	return self.Data[y]
end
--
function Matrix.GetColumn(self: Matrix, x: number): { number }
	x = math.clamp(x, 1, self.SizeX)
	local column = {}
	for y = 1, self.SizeY do
		column[y] = self.Data[y][x]
	end
	return column
end
---------------------------------------------------------------------------------------
function Matrix.SetSizeX(self: Matrix, sizeX: number)
	self.SizeX = sizeX
	for y = 1, self.SizeY do
		self.Data[y] = self.Data[y] or {}
		for x = 1, self.SizeX do
			self.Data[y][x] = self.Data[y][x] or 0
		end
	end
end
--
function Matrix.SetSizeY(self: Matrix, sizeY: number)
	self.SizeY = sizeY
	for y = 1, self.SizeY do
		self.Data[y] = self.Data[y] or {}
		for x = 1, self.SizeX do
			self.Data[y][x] = self.Data[y][x] or 0
		end
	end
end
--
function Matrix.SetElement(self: Matrix, x: number, y: number, value: number)
	x = math.clamp(x, 1, self.SizeX)
	y = math.clamp(y, 1, self.SizeY)
	self.Data[y][x] = value
end
--
function Matrix.SetRow(self: Matrix, y: number, row: { number })
	y = math.clamp(y, 1, self.SizeY)
	for x = 1, self.SizeX do
		self.Data[y][x] = row[x] or 0
	end
end
--
function Matrix.SetColumn(self: Matrix, x: number, column: { number })
	x = math.clamp(x, 1, self.SizeX)
	for y = 1, self.SizeY do
		self.Data[y][x] = column[y] or 0
	end
end
---------------------------------------------------------------------------------------
const function MatrixIterate(self: Matrix, callback: (x: number, y: number, value: number) -> ())
	for y = 1, self.SizeY do
		for x = 1, self.SizeX do
			callback(x, y, self.Data[y][x])
		end
	end
end
---------------------------------------------------------------------------------------
const function DotProduct(valueA: { number }, valueB: { number }): number
	local result = 0
	for i = 1, #valueA do
		result += valueA[i] * valueB[i]
	end
	return result
end
---------------------------------------------------------------------------------------
Matrix.__tostring = function(self: Matrix): string
	local str = ""
	for y = 1, self.SizeY do
		str = str .. "\n["
		for x = 1, self.SizeX do
			str = str .. tostring(self.Data[y][x])
			if x < self.SizeX then
				str = str .. ", "
			end
		end
		str = str .. "]"
	end
	return str
end
---------------------------------------------------------------------------------------
--Add
Matrix.__add = function(self: Matrix | number, other: Matrix | number): Matrix | nil
	if typeof(self) ~= "number" and typeof(other) == "number" then
		local result = Constructor(self.SizeX, self.SizeY)
		MatrixIterate(self, function(x, y, value)
			result:SetElement(x, y, value + other)
		end)
		return result
	elseif typeof(self) == "number" and typeof(other) ~= "number" then
		local result = Constructor(other.SizeX, other.SizeY)
		MatrixIterate(other, function(x, y, value)
			result:SetElement(x, y, self + value)
		end)
		return result
	elseif typeof(self) ~= "number" and typeof(other) ~= "number" then
		if (self.SizeX ~= other.SizeX) or (self.SizeY ~= other.SizeY) then
			error("Invalid operands for addition: Matrices must have the same dimensions.")
			return nil
		end
		--
		local result = Constructor(self.SizeX, self.SizeY)
		MatrixIterate(self, function(x, y, value)
			result:SetElement(x, y, value + other:GetElement(x, y))
		end)
		return result
	else
		error("Invalid operands for addition: " .. typeof(self) .. " and " .. typeof(other) .. ".")
	end
end
---------------------------------------------------------------------------------------
--Subtract
Matrix.__sub = function(self: Matrix | number, other: Matrix | number): Matrix | nil
	if typeof(self) ~= "number" and typeof(other) == "number" then
		local result = Constructor(self.SizeX, self.SizeY)
		MatrixIterate(self, function(x, y, value)
			result:SetElement(x, y, value - other)
		end)
		return result
	elseif typeof(self) == "number" and typeof(other) ~= "number" then
		local result = Constructor(other.SizeX, other.SizeY)
		MatrixIterate(other, function(x, y, value)
			result:SetElement(x, y, self - value)
		end)
		return result
	elseif typeof(self) ~= "number" and typeof(other) ~= "number" then
		--
		if (self.SizeX ~= other.SizeX) or (self.SizeY ~= other.SizeY) then
			error("Invalid operands for subtraction: Matrices must have the same dimensions.")
			return nil
		end
		--
		local result = Constructor(self.SizeX, self.SizeY)
		MatrixIterate(self, function(x, y, value)
			result:SetElement(x, y, value - other:GetElement(x, y))
		end)
		return result
	else
		error("Invalid operands for subtraction: " .. typeof(self) .. " and " .. typeof(other) .. ".")
	end
end
---------------------------------------------------------------------------------------
--Multiply
Matrix.__mul = function(self: Matrix | number, other: Matrix | number): Matrix | nil
	if typeof(self) ~= "number" and typeof(other) == "number" then
		local result = Constructor(self.SizeX, self.SizeY)
		MatrixIterate(self, function(x, y, value)
			result:SetElement(x, y, value * other)
		end)
		return result
	elseif typeof(self) == "number" and typeof(other) ~= "number" then
		local result = Constructor(other.SizeX, other.SizeY)
		MatrixIterate(other, function(x, y, value)
			result:SetElement(x, y, self * value)
		end)
		return result
	elseif typeof(self) ~= "number" and typeof(other) ~= "number" then
		--
		if self.SizeX ~= other.SizeY then
			error("Invalid operands for multiply: Matrix A's SizeX must equal Matrix B's SizeY.")
			return nil
		end
		--
		local result = Constructor(other.SizeX, self.SizeY)
		MatrixIterate(result, function(x, y, _value)
			result:SetElement(x, y, DotProduct(self:GetRow(y), other:GetColumn(x)))
		end)
		return result
	else
		error("Invalid operands for multiply: " .. typeof(self) .. " and " .. typeof(other) .. ".")
	end
end
---------------------------------------------------------------------------------------
--Divide
Matrix.__div = function(self: Matrix | number, other: Matrix | number): Matrix | nil
	if typeof(self) ~= "number" and typeof(other) == "number" then
		local result = Constructor(self.SizeX, self.SizeY)
		MatrixIterate(self, function(x, y, value)
			result:SetElement(x, y, value / other)
		end)
		return result
	elseif typeof(self) == "number" and typeof(other) ~= "number" then
		local result = Constructor(other.SizeX, other.SizeY)
		MatrixIterate(other, function(x, y, value)
			result:SetElement(x, y, self / value)
		end)
		return result
	elseif typeof(self) ~= "number" and typeof(other) ~= "number" then
		--
		error("Cannot divide two matrices.")
		return nil
		--
	else
		error("Invalid operands for divide: " .. typeof(self) .. " and " .. typeof(other) .. ".")
	end
end
---------------------------------------------------------------------------------------
return Constructor
---------------------------------------------------------------------------------------
