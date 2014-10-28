
require 'base64'
local ForestMap=require "map/forest_map"

local LevelPostGenerates={}
local LevelPostPopulate={}
local LevelGenerates={}
local generate_orig=ForestMap.Generate
ForestMap.Generate=function(prefab, map_width, map_height, tasks, world_gen_choices, level_type, level)
	if(LevelGenerates[level.id])then
		return LevelGenerates[level.id](prefab, map_width, map_height, tasks, world_gen_choices, level_type, level)
	end
	local save=generate_orig(prefab, map_width, map_height, tasks, world_gen_choices, level_type, level)
		if(LevelPostGenerates[level.id])then
			for k,v in pairs(LevelPostGenerates[level.id])do
				v(save,prefab, map_width, map_height, tasks, world_gen_choices, level_type, level)
			end
		end
	return save
end
local AddLevelPostGenerate=function(levelid,fn)
	if(not LevelPostGenerates[levelid])then
		LevelPostGenerates[levelid]={}
	end
	table.insert(LevelPostGenerates[levelid],fn)
end
local AddLevelPostPopoulate=function(levelid,fn)
	if(not LevelPostPopulate[levelid])then
		LevelPostPopulate[levelid]={}
	end
	table.insert(LevelPostPopulate[levelid],fn)
end
--need to be able to filter in graph otherwise im risking total chaos
require "map/storygen"
local old_start=Story.GenerationPipeline
function Story:GenerationPipeline(...)
	print("generation pipeline fix for ",self.level.id)
	self.rootNode.story_level=self.level.id
	return old_start(self,...)
end
--apparently post gen is useless/too late/faulty/whatever
require "map/network"
local graph_postpop=Graph.GlobalPostPopulate
function Graph:GlobalPostPopulate(entities, width, height)
	print("self.story_level",self.story_level)
	local x=graph_postpop(self,entities, width, height)
	if(self.story_level and LevelPostPopulate[self.story_level])then
			for k,v in pairs(LevelPostPopulate[self.story_level])do
				v(self,entities, width, height)
			end
	end
	return x
end

local function DorfPostPop(graph,entities, width, height)
	print("post pop")
	local nodes = graph:GetNodes(true)
	for idx,node in pairs(nodes) do
    	print("node",idx,node,node.data,node.populated)
		local points_x, points_y, points_type = WorldSim:GetPointsForSite(node.id)
		print("npoints",#points_x,#points_y,points_type)
		--[[
		for i=1,#points_x do
			--theres prob a way faster way 
			local tile=WorldSim:GetVisualTileAtPosition(points_x[i],points_y[i])
			if(tile and tile==FA_FAKE_TILE)then
				WorldSim:SetTile(points_x[i],points_y[i], GROUND.IMPASSABLE)
			end
		end
		]]
	end

	print("w h",width,height)
	for i=1,width do
		for j=1,height do
			local tile=WorldSim:GetVisualTileAtPosition(i,j)
			if(tile and tile==FA_FAKE_TILE)then
				print("fake ",i,j)
				WorldSim:SetTile(i,j, GROUND.IMPASSABLE)
			end
		end
	end
end
AddLevelPostPopoulate("DWARF_FORTRESS",DorfPostPop)
--AddLevelPostGenerate("DWARF_FORTRESS",DorfFortPostGenerate)

