
GM.Name 	= "starwarsrp"
GM.Author 	= "Falcon"
GM.Email 	= "swrpdeveloping@gmail.com"

DeriveGamemode( "sandbox" )

function includeFiles( scanDirectory, isGamemode )
	isGamemode = isGamemode or false
	local queue = { scanDirectory }
	while #queue > 0 do
		for _, directory in pairs( queue ) do
			local files, directories = file.Find( directory .. "/*", "LUA" )
			for _, fileName in pairs( files ) do
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					local relativePath = directory .. "/" .. fileName
					if isGamemode then
						relativePath = string.gsub( directory .. "/" .. fileName, GM.FolderName .. "/gamemode/", "" )
					end
					if string.match( fileName, "^sv" ) then
						if SERVER then
							include( relativePath )
						end
					end
					if string.match( fileName, "^sh" ) then
						AddCSLuaFile( relativePath )
						include( relativePath )
					end
					if string.match( fileName, "^cl" ) then
						AddCSLuaFile( relativePath )
						if CLIENT then
							include( relativePath )
						end
					end
				end
			end
			for _, subdirectory in pairs( directories ) do
				table.insert( queue, directory .. "/" .. subdirectory )
			end
			table.RemoveByValue( queue, directory )
		end
	end
end
includeFiles( GM.FolderName .. "/gamemode", true )

Falcon = Falcon or {}


function SortNewData( data )
	local nextData = {}
	table.insert(nextData, data)
	while (#nextData > 0) do
		for id, tbl in pairs( nextData ) do
			for keys, vals in pairs( tbl ) do
				local dataType = type(vals)
				if dataType == "table" then
					table.insert(nextData, vals)
				elseif dataType == "string" then
					local result = util.JSONToTable( vals )
					if result then
						tbl[keys] = result
					end

					local checkNumber = tonumber( vals )
					if checkNumber then
						tbl[keys] = checkNumber
					end
				end
			end
			table.remove(nextData, id)
		end
	end
end