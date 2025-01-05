--[[

The code is pretty unstructured, as I wanted to just start by making two dots connect together with brute force.
I did not enjoy making this code, you can also see a lot of repeating sections. This is also kind of unoptimized aswell.

--]]

local Workspace = game:GetService("Workspace")

local Grid = {}
local GRID_X, GRID_Y = 10, 10

local function ResetGrid()
	for X = 1, GRID_X do
		Grid[X] = {}

		for Y = 1, GRID_Y do
			Grid[X][Y] = "."
		end
	end
end

local function PrintGrid()
	for X = 1, GRID_X do
		print(table.concat(Grid[X]))
	end
end

local function IsAdjacent(X1, Y1, X2, Y2)
	return (math.abs(X2 - X1) + math.abs(Y2 - Y1)) == 1
end

local function OutOfBounds(X, Y)
	return 0 >= X or X >= GRID_X + 1 or 0 >= Y or Y >= GRID_Y + 1
end

local function RandomDirection()
	if math.random(2) == 1 then
		return {math.random(1, 2) * 2 - 3, 0}
	else
		return {0, math.random(1, 2) * 2 - 3}
	end
end

local function GetRandomEdge()
	local AllEdges = {}

	for X = 1, GRID_X do
		for Y = 1, GRID_Y do
			if not Grid[X] then
				continue
			end

			if Grid[X][Y] ~= "." then
				continue
			end

			local BlankAdjacentTiles = 0

			if Grid[X][Y-1] == "." then
				BlankAdjacentTiles += 1
			end

			if Grid[X][Y+1] == "." then
				BlankAdjacentTiles += 1
			end

			if Grid[X-1] and Grid[X-1][Y] == "." then
				BlankAdjacentTiles += 1
			end

			if Grid[X+1] and Grid[X+1][Y] == "." then
				BlankAdjacentTiles += 1
			end

			if 1 <= BlankAdjacentTiles and BlankAdjacentTiles <= 3 then
				table.insert(AllEdges, {X, Y})
			end
		end
	end

	return AllEdges[math.random(#AllEdges)]
end

local function MakeRandomPath(ID)
	local Start = GetRandomEdge()
	Grid[Start[1]][Start[2]] = ID

	local End

	repeat
		End = GetRandomEdge()
	until not IsAdjacent(Start[1], Start[2], End[1], End[2]) and 
		not (Start[1] == End[1] and Start[2] == End[2])
	
	Grid[End[1]][End[2]] = ID

	local CurrentX, CurrentY = Start[1], Start[2]

	local LoopCount = 0

	while true do
		if IsAdjacent(End[1], End[2], CurrentX, CurrentY) then
			print("Finished")
			break
		end

		if LoopCount >= 1000 then
			break
		end

		local RandomDir
		
		while true do
			RandomDir = RandomDirection()
			LoopCount += 1
			
			if LoopCount >= 1000 then
				RandomDir = {0, 0}
				break
			end
			
			if not OutOfBounds(CurrentX + RandomDir[1], CurrentY + RandomDir[2]) and 
				Grid[CurrentX + RandomDir[1]][CurrentY + RandomDir[2]] == "." then
				
				if Grid[CurrentX + RandomDir[1] + 1] and 
					Grid[CurrentX + RandomDir[1] + 1][CurrentY + RandomDir[2]] == "X" and 
					RandomDir[1] ~= -1 then
					continue
				end
				
				if Grid[CurrentX + RandomDir[1] - 1] and 
					Grid[CurrentX + RandomDir[1] - 1][CurrentY + RandomDir[2]] == "X" and 
					RandomDir[1] ~= 1 then
					continue
				end
				
				if Grid[CurrentX + RandomDir[1]][CurrentY + RandomDir[2] + 1] == "X" and
					RandomDir[2] ~= -1 then
					continue
				end
				
				if Grid[CurrentX + RandomDir[1]][CurrentY + RandomDir[2] - 1] == "X" and
					RandomDir[2] ~= 1 then
					continue
				end
				
				break
			end
		end

		CurrentX += RandomDir[1]
		CurrentY += RandomDir[2]
		
		if not Grid[CurrentX] then
			print(CurrentX)
		end
		
		Grid[CurrentX][CurrentY] = "X"
		LoopCount += 1
	end
	
	if LoopCount < 1000 then
		print(LoopCount)
		return true
	else
		return false
	end
end

ResetGrid()

while true do
	local PathSuccessful = MakeRandomPath(1)
	
	if PathSuccessful then
		break
	else
		ResetGrid()
	end
end

PrintGrid()
