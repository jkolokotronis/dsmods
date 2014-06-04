--[[
-- Shamelessly stolen, all credits @Simplex
--
-- The following tables list what may be present in the tile and minimap
-- tile specifications passed to AddTile(). The values listed here are the
-- default ones used when none are specified.
--]]

-- Lists the structure for a tile specification by mapping the possible fields to their
-- default values.
local tile_spec_defaults = {
	noise_texture = "images/square.tex",
	runsound = "dontstarve/movement/run_dirt",
	walksound = "dontstarve/movement/walk_dirt",
	snowsound = "dontstarve/movement/run_ice",
	mudsound = "dontstarve/movement/run_mud",
}

-- Like the above, but for the minimap tile specification.
local mini_tile_spec_defaults = {
	name = "map_edge",
	noise_texture = "levels/textures/mini_dirt_noise.tex",
}


------------------------------------------------------------------------


local _G = GLOBAL
local require = _G.require


require 'util'
require 'map/terrain'


local Asset = _G.Asset

local tiledefs = require 'worldtiledefs'
local GROUND = _G.GROUND
local GROUND_NAMES = _G.GROUND_NAMES
local resolvefilepath = _G.resolvefilepath
local softresolvefilepath = _G.softresolvefilepath

local assert = _G.assert
local error = _G.error
local type = _G.type
local rawget = _G.rawget


local GroundAtlas = rawget(_G, "GroundAtlas") or function( name )
	return ("levels/tiles/%s.xml"):format(name) 
end

local GroundImage = rawget(_G, "GroundImage") or function( name )
	return ("levels/tiles/%s.tex"):format(name) 
end

local noise_locations = {
	"%s.tex",
	"levels/textures/%s.tex",
}

local function GroundNoise( name )
	local trimmed_name = name:gsub("%.tex$", "")
	for _, pattern in ipairs(noise_locations) do
		local tentative = pattern:format(trimmed_name)
		if softresolvefilepath(tentative) then
				return tentative
		end
	end

	-- This is meant to trigger an error.
	local status, err = pcall(resolvefilepath, name)
	return error(err or "This shouldn't be thrown. But your texture path is invalid, btw.", 3)
end


local function AddAssetsTo(assets_table, specs)
	table.insert( assets_table, Asset( "IMAGE", GroundNoise( specs.noise_texture ) ) )
	table.insert( assets_table, Asset( "IMAGE", GroundImage( specs.name ) ) )
	table.insert( assets_table, Asset( "FILE", GroundAtlas( specs.name ) ) )
end

local function AddAssets(specs)
	AddAssetsTo(tiledefs.assets, specs)
end



local function validate_ground_numerical_id(numerical_id)
	if numerical_id >= GROUND.UNDERGROUND then
		return error(("Invalid numerical id %d: values greater than or equal to %d are assumed to represent walls."):format(numerical_id, GROUND.UNDERGROUND), 3)
	end
	for k, v in pairs(GROUND) do
		if v == numerical_id then
			return error(("The numerical id %d is already used by GROUND.%s!"):format(v, tostring(k)), 3)
		end
	end
end

--[[
-- name should match the texture/atlas specification in levels/tiles.
-- (it's not just an arbitrary name, it defines the texture used)
--]]
function AddTile(id, numerical_id, name, specs, minispecs)
	assert( type(id) == "string" )
	assert( type(numerical_id) == "number" )
	assert( type(name) == "string" )
	assert( GROUND[id] == nil, ("GROUND.%s already exists!"):format(id))

	specs = specs or {}
	minispecs = minispecs or {}

	assert( type(specs) == "table" )
	assert( type(minispecs) == "table" )

	-- Ideally, this should never be passed, and we would wither generate it or load it
	-- from savedata if it had already been generated once for the current map/saveslot.
	validate_ground_numerical_id(numerical_id)

	GROUND[id] = numerical_id
	GROUND_NAMES[numerical_id] = name


	local real_specs = { name = name }
	for k, default in pairs(tile_spec_defaults) do
		if specs[k] == nil then
			real_specs[k] = default
		else
			-- resolvefilepath() gets called by the world entity.
			real_specs[k] = specs[k]
		end
	end
	real_specs.noise_texture = GroundNoise( real_specs.noise_texture )

	table.insert(tiledefs.ground, {
		GROUND[id], real_specs
	})

	AddAssets(real_specs)


	local real_minispecs = {}
	for k, default in pairs(mini_tile_spec_defaults) do
		if minispecs[k] == nil then
			real_minispecs[k] = default
		else
			real_minispecs[k] = minispecs[k]
		end
	end

	AddPrefabPostInit("minimap", function(inst)
		local handle = _G.MapLayerManager:CreateRenderLayer(
			GROUND[id],
			resolvefilepath( GroundAtlas(real_minispecs.name) ),
			resolvefilepath( GroundImage(real_minispecs.name) ),
			resolvefilepath( GroundNoise(real_minispecs.noise_texture) )
		)
		inst.MiniMap:AddRenderLayer( handle )
	end)

	AddAssets(real_minispecs)


	return real_specs, real_minispecs
end
