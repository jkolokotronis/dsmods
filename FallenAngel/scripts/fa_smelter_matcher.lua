--yeah i should break it some day when I have a reason to
local FAIL_TIMER=120

local smelt_recipes={
	{product={"fa_goldbar"},cooktime=120}={
		"goldnugget"=4,
		"charcoal"=4
		},
	{product={"fa_goldbar"},cooktime=120}={
		"goldnugget"=4,
		"fa_coalbar"=4
		},
	{product={"fa_ironbar"},cooktime=360}={
		"fa_ironpebble"=4,
		"fa_coalbar"=4
		},
	{product={"fa_pigironbar"},cooktime=120}={
		"fa_ironbar"=4,
		"marble"=2,
		"fa_coalbar"=2
		},
	{product={"fa_pigironbar"},cooktime=120}={
		"fa_ironbar"=4,
		"fa_limestonepebble"=2,
		"fa_coalbar"=2
		},
	{product={"fa_coalbar","fa_coalbar","fa_coalbar"},cooktime=240}={
		"fa_coalpebble"=6,
		"charcoal"=2
		},
	{product={"fa_steelbar"},cooktime=480}={
		"fa_coalbar"=2,
		"fa_ironbar"=2,
		"fa_pigironbar"=2,
		"fa_limestonepebble"=2,
		},
	{product={"fa_steelbar"},cooktime=480}={
		"fa_coalbar"=2,
		"fa_ironbar"=2,
		"fa_pigironbar"=2,
		"marble"=2,
		},
	{product={"fa_copperbar"},cooktime=120}={
		"fa_copperpebble"=4,
		"charcoal"=4
		},
	{product={"fa_copperbar"},cooktime=120}={
		"fa_copperpebble"=4,
		"fa_coalbar"=4
		},
	{product={"fa_silverbar"},cooktime=240}={
		"fa_silverpebble"=4,
		"charcoal"=4
		},
	{product={"fa_silverbar"},cooktime=240}={
		"fa_silverpebble"=4,
		"fa_coalbar"=4
		},
	{product={"fa_adamantinebar"},cooktime=960}={
		"fa_adamantinepebble"=4,
		"fa_coalbar"=4
		},
	{product={"fa_lavabar"},cooktime=240}={
		"fa_lavapebble"=4,
		"charcoal"=4
		},
	{product={"fa_lavabar"},cooktime=240}={
		"fa_lavapebble"=4,
		"fa_coalbar"=4
		},
}

local FASmelterMatcher=Class(function(self, craftlists)
	self.craftlists=craftlists
end)

local function FASmelterMatcher:Match(itemlist)
	local matched=false
	for k,v in pairs(smelt_recipes) do
		test=true
		for p,count in pairs(v) do
			if((not itemlist[p]) or(itemlist[p]<count))then
				test=false
				break
			end
		end
		if(test)then
			return k
		end
	end

	--failed
	local product={}
	for k,v in pairs(itemlist) do
		if(string.find(k,"pebble"))then
		for i=1,v do

			table.insert(product,i)
		end
		end
	end
	return {product=product,cooktime=FAIL_TIMER}
end

local function FASmelterMatcher:TryMatch(itemlist)
	return true
end

return FASmelterMatcher