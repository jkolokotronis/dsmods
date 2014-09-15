--yeah i should break it some day when I have a reason to
local FAIL_TIMER=60

local FAIL_PERSISTANT={
	fa_adamantinepebble="fa_adamantinepebble",
	fa_diamondpebble="fa_diamondpebble",
	fa_adamantinebar="fa_adamantinebar"
}

local function isfuel(ing)
	return ing=="charcoal" or ing=="fa_coalbar"
end

local function bottleany(ing)
	return (ing=="fa_bottle_oil") or (ing=="fa_bottle_mineralwater") or (ing=="fa_bottle_water")
end
local function heavywater(ing)
	return (ing=="fa_bottle_mineralwater") or (ing=="fa_bottle_oil") 
end 
local function anyanimal(ing)
	return (ing=="mole" or ing=="rabbit" or ing=="crow" or ing=="robin" or ing=="robin_winter")
end
local function anymetalore(ing)
	return (ing=="fa_lavapebble" or ing=="fa_ironpebble" or ing=="fa_adamantinepebble" or ing=="fa_copperpebble" or ing=="fa_silverpebble" or ing=="goldnugget")
end
local function anyore(ing)
	return (anymetalore(ing) or ing=="fa_coalpebble" or ing=="fa_limestonepebble" or ing=="rocks" or ing=="flint" )
end
local function anymeat(ing)
	return (ing=="smallmeat" or ing=="meat" or ing=="monstermeat" or ing=="drumstick" or ing=="batwing")
end

local alchemy_recipes={
	{
		match={product={"fa_bottle_r"},cooktime=960},
		test={
			{ingred="poisonspidergland",count=4},
			{ingred="stinger",count=3},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_r"},cooktime=960},
		test={
			{ingred="spidergland",count=4},
			{ingred="stinger",count=3},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_y"},cooktime=960},
		test={
			{ingred="petal",count=5},
			{ingred="fa_orcskin",count=2},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_y"},cooktime=960},
		test={
			{ingred="petal",count=5},
			{ingred="fa_goblinskin",count=2},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_g"},cooktime=960},
		test={
			{ingred="petal",count=5},
			{ingred="nightmarefuel",count=2},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
	--yeah i need a freaking counter somewhere
		match={product={"fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand"}
		,cooktime=30},
		test={
			{ingred="rocks",count=8},
		},
	},
	{
		match={product={"fa_bottle_frozenessence"},cooktime=30},
		test={
			{ingred="ice",count=5},
			{ingred="nightmarefuel",count=2},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_lifeessence"},cooktime=30},
		test={
			{ingred=anyanimal,count=6},
			{ingred="nightmarefuel",count=1},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_lightningessence"},cooktime=30},
		test={
			{ingred="fireflies",count=4},
			{ingred=anymetalore,count=1},
			{ingred="nightmarefuel",count=1},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_mineralwater"},cooktime=60},
		test={
			{ingred=anyore,count=6},
			{ingred="fa_bottle_water",count=1},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_oil"},cooktime=120},
		test={
			{ingred=anymeat,count=7},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_water"},cooktime=30},
		test={
			{ingred="ice",count=4},
			{ingred="fa_bottle_empty",count=1},
		},
	},
}

local smelt_recipes={
	{
		match={product={"fa_goldbar"},cooktime=72},
		test={
			{ingred="goldnugget",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_goldbar"},cooktime=120},
		test={
			{ingred="goldnugget",count=4},
			{ingred=isfuel,count=4}
		},
	},
	{
		match={product={"fa_ironbar"},cooktime=360},
		test={
			{ingred="fa_ironpebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_pigironbar"},cooktime=120},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="marble",count=2},
			{ingred="fa_coalbar",count=2},
		},
	},
	{
		match={product={"fa_pigironbar"},cooktime=120},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="fa_limestonepebble",count=2},
			{ingred="fa_coalbar",count=2},
		},
	},
	{
		match={product={"fa_coalbar","fa_coalbar","fa_coalbar"},cooktime=144},
		test={
			{ingred="fa_coalpebble",count=6},
			{ingred="fa_coalbar",count=2},
		},
	},
	{
		match={product={"fa_coalbar","fa_coalbar","fa_coalbar"},cooktime=240},
		test={
			{ingred="fa_coalpebble",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_steelbar"},cooktime=480},
		test={
			{ingred="fa_coalbar",count=2},
			{ingred="fa_ironbar",count=2},
			{ingred="fa_pigironbar",count=2},
			{ingred="fa_limestonepebble",count=2},
		},
	},
	{
		match={product={"fa_steelbar"},cooktime=480},
		test={
			{ingred="fa_coalbar",count=2},
			{ingred="fa_ironbar",count=2},
			{ingred="fa_pigironbar",count=2},
			{ingred="marble",count=2},
		},
	},
	{
		match={product={"fa_copperbar"},cooktime=72},
		test={
			{ingred="fa_copperpebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_copperbar"},cooktime=120},
		test={
			{ingred="fa_copperpebble",count=4},
			{ingred=isfuel,count=4},
		},
	},
	{
		match={product={"fa_silverbar"},cooktime=144},
		test={
			{ingred="fa_silverpebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_silverbar"},cooktime=240},
		test={
			{ingred="fa_silverpebble",count=4},
			{ingred=isfuel,count=4},
		},
	},
	{
		match={product={"fa_adamantinebar"},cooktime=960},
		test={
			{ingred="fa_adamantinepebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_lavabar"},cooktime=144},
		test={
			{ingred="fa_lavapebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_lavabar"},cooktime=240},
		test={
			{ingred="fa_lavapebble",count=4},
			{ingred=isfuel,count=4},
		},
	},
}

local forge_recipes={
	{
		match={product={"fa_coppersword","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_coppersword","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred=isfuel,count=4},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_copperaxe","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_copperaxe","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred=isfuel,count=3},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_copperdagger","fa_bottle_empty","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_copperdagger","fa_bottle_empty","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred=isfuel,count=3},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_ironsword","fa_bottle_empty"},cooktime=144},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_ironsword","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred=isfuel,count=4},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_ironaxe","fa_bottle_empty"},cooktime=144},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_ironaxe","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred=isfuel,count=3},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_irondagger","fa_bottle_empty","fa_bottle_empty"},cooktime=144},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_irondagger","fa_bottle_empty","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred=isfuel,count=3},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_steelsword","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_steelbar",count=2},
			{ingred="fa_pigironbar",count=1},
			{ingred="fa_coalbar",count=4},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_steelaxe","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_steelbar",count=3},
			{ingred="fa_pigironbar",count=1},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_steeldagger","fa_bottle_empty","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_steelbar",count=2},
			{ingred="fa_pigironbar",count=1},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_silversword","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_silveraxe","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_silverdagger","fa_bottle_empty","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_copperarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred="fa_coalbar",count=2},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_copperarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_ironarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=288},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_ironarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred=isfuel,count=2},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_steelarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_steelbar",count=4},
			{ingred="fa_coalbar",count=2},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"armorfire","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_lavabar",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"armorfire2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_lavabar",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"armorfire3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_lavabar",count=3},
			{ingred="fa_coalbar",count=1},
			{ingred="fa_steelarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"armorfrost","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_frozenessence",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"armorfrost2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_frozenessence",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"armorfrost3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_frozenessence",count=3},
			{ingred="fa_coalbar",count=1},
			{ingred="fa_steelarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_fireaxe","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_lavabar",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperaxe",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_fireaxe2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_lavabar",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironaxe",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_fireaxe3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_lavabar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelaxe",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"flamingsword","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_lavabar",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_coppersword",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"flamingsword2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_lavabar",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironsword",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"flamingsword3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_lavabar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelsword",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"frostsword","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_frozenessence",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_coppersword",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"frostsword2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_frozenessence",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironsword",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"frostsword3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_frozenessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelsword",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_iceaxe","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_frozenessence",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperaxe",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_iceaxe2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_frozenessence",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironaxe",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_iceaxe3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_frozenessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelaxe",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"vorpalaxe","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_lifeessence",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperaxe",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"vorpalaxe2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lifeessence",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_ironaxe",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"vorpalaxe3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_lifeessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelaxe",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"dagger","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_lifeessence",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperdagger",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"dagger2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lifeessence",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_irondagger",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"dagger3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_lifeessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steeldagger",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_lightningsword","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_lightningessence",count=1},
			{ingred="charcoal",count=3},
			{ingred="fa_copperdagger",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_lightningsword2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lightningessence",count=2},
			{ingred="charcoal",count=2},
			{ingred="fa_irondagger",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_lightningsword3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_lightningessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steeldagger",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_bottle_empty","blowdart_sleep"},cooktime=120},
		test={
			{ingred="fa_sand",count=5},
			{ingred="blowdart_sleep",count=1},
		},
	},
	{
		match={product={"fa_bottle_empty","blowdart_fire"},cooktime=120},
		test={
			{ingred="fa_sand",count=5},
			{ingred="blowdart_fire",count=1},
		},
	},
	{
		match={product={"fa_bottle_empty","blowdart_pipe"},cooktime=120},
		test={
			{ingred="fa_sand",count=5},
			{ingred="blowdart_pipe",count=1},
		},
	},
}
local FA_Matcher=Class(function(self, craftlists)
	self.craftlists=craftlists
end)

function FA_Matcher:Match(itemlist)

	local matched=false
	for k,v in ipairs(self.craftlists) do
		local test=true
		local copylist=deepcopy(itemlist)
		for k1,t in ipairs(v.test) do
			local count=t.count
			if(type(t.ingred)=="function")then
				for ping,pc in pairs(copylist) do
					if(t.ingred(ping))then
						if count<=pc then
							copylist[ping]=pc-count
							count=0
							break
						else
							copylist[ping]=0
							count=count-pc
						end
					end
				end
				if(count and count>0)then
					test=false
					break
				end
			else
				if(copylist[t.ingred] and copylist[t.ingred]>=count)then
					copylist[t.ingred]=copylist[t.ingred]-count
				else
					test=false
					break
				end
			end
		end
		if(test)then
			return v.match
		end
	end

	--failed
	local product={}
	for k,v in pairs(itemlist) do
		local slag=FAIL_PERSISTANT[k]
		--too lazy to read lua string/regex options
		if(not slag)then
			local index=string.find(k,"pebble")
			if(not index)then index=string.find(k,"bar") end
			if(index and index>0)then
				slag=string.sub(k,1,index-1).."slag"
			end
		end
		if(slag)then
			print("adding slag",slag)
			for i=1,v do
				table.insert(product,slag)
			end
		end
	end
	return {product=product,cooktime=FAIL_TIMER}
end

function FA_Matcher:TryMatch(itemlist)
	return true
end

local matchers={
	SmelterMatcher=FA_Matcher(smelt_recipes),
	AlchemyMatcher=FA_Matcher(alchemy_recipes),
	ForgeMatcher=FA_Matcher(forge_recipes)
}

return matchers