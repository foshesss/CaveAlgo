-- this code is only a snippet of code provided for cave generation
-- feel free to fork, make updates and so on

function Chunk:GenerateCave()
	local blocks = self.blocks
	local xzScale = SETTINGS.xzScale
	local yScale = SETTINGS.yScale
	local seed = SETTINGS.Seed
	
	local AIR = -1

	-- fill in air blocks within the chunk
	for x = 1, SETTINGS.ChunkSize do
		blocks[x] = blocks[x] or {}
		for y = 1, SETTINGS.ChunkSize do
			blocks[x][y] = blocks[x][y] or {}
			for z = 1, SETTINGS.ChunkSize do

				local xScale = (x + self.origin.X/SETTINGS.BlockSize) * xzScale
				local yScale = (y + self.origin.Y/SETTINGS.BlockSize) * yScale
				local zScale = (z + self.origin.Z/SETTINGS.BlockSize) * xzScale

				local _x = math.noise(yScale, zScale, seed)
				local _y = math.noise(xScale, zScale, seed)
				local _z = math.noise(xScale, yScale, seed)
				local density = _x + _y + _z

				if density <= SETTINGS.CaveThreshold then continue end
				blocks[x][y][z] = AIR
			end
		end
	end
	
	-- add stone/ores around the air blocks (so the cave has it's shape)
	for x = 1, SETTINGS.ChunkSize do
		for y = 1, SETTINGS.ChunkSize do
			for z = 1, SETTINGS.ChunkSize do
				-- dont overwrite any blocks
				if blocks[x][y][z] ~= nil then continue end
				
				local added = false
				
				for tX = x - 1, x + 1, 2 do
					-- check next chunk if out of bound of current chunk
					if tX < 1 or SETTINGS.ChunkSize < tX then
						local xScale = (tX + self.origin.X/SETTINGS.BlockSize) * xzScale
						local yScale = (y + self.origin.Y/SETTINGS.BlockSize) * yScale
						local zScale = (z + self.origin.Z/SETTINGS.BlockSize) * xzScale
						
						local _x = math.noise(yScale, zScale, seed)
						local _y = math.noise(xScale, zScale, seed)
						local _z = math.noise(xScale, yScale, seed)
						local density = _x + _y + _z

						if density <= SETTINGS.CaveThreshold then continue end
						
						added = true
						break
					elseif blocks[tX][y][z] == AIR then
						added = true
						break
					end
				end
				
				if added then self:SpawnOreAt(x, y, z) continue end

				for tY = y - 1, y + 1, 2 do
					-- check next chunk if out of bound of current chunk
					if tY < 1 or SETTINGS.ChunkSize < tY then
						local xScale = (x + self.origin.X/SETTINGS.BlockSize) * xzScale
						local yScale = (tY + self.origin.Y/SETTINGS.BlockSize) * yScale
						local zScale = (z + self.origin.Z/SETTINGS.BlockSize) * xzScale

						local _x = math.noise(yScale, zScale, seed)
						local _y = math.noise(xScale, zScale, seed)
						local _z = math.noise(xScale, yScale, seed)
						local density = _x + _y + _z

						if density <= SETTINGS.CaveThreshold then continue end

						added = true
						break
					elseif blocks[x][tY][z] == AIR then
						added = true
						break
					end
				end

				if added then self:SpawnOreAt(x, y, z) continue end
				
				for tZ = z - 1, z + 1, 2 do
					-- check next chunk if out of bound of current chunk
					if tZ < 1 or SETTINGS.ChunkSize < tZ then
						local xScale = (x + self.origin.X/SETTINGS.BlockSize) * xzScale
						local yScale = (y + self.origin.Y/SETTINGS.BlockSize) * yScale
						local zScale = (tZ + self.origin.Z/SETTINGS.BlockSize) * xzScale

						local _x = math.noise(yScale, zScale, seed)
						local _y = math.noise(xScale, zScale, seed)
						local _z = math.noise(xScale, yScale, seed)
						local density = _x + _y + _z

						if density <= SETTINGS.CaveThreshold then continue end

						added = true
						break
					elseif blocks[x][y][tZ] == AIR then
						added = true
						break
					end
				end

				if added then self:SpawnOreAt(x, y, z) continue end
			end
		end
	end
end