require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/standandattack"
require "behaviours/standstill"


local function fearnode(self)
	return WhileNode( function() return self.inst.fa_fear~=nil end, "Fear", Panic(self.inst))
end

local function stunNode(self)
	return WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", StandStill(self.inst))
end

local function dazeNode(self)
	return WhileNode( function() return self.inst.fa_daze~=nil end, "Daze", StandStill(self.inst))
end

local function rootAttackNode(self)
	return WhileNode( function() return self.inst.fa_root~=nil end, "RootAttack", StandAndAttack(self.inst) )
end

--just so i can do oneliner properly
local function appendNode(root,node,index)
	node.parent=root
	table.insert(root.children,index,node)
end

local GhostBrain=require "brains/ghostbrain"
local old_ghostonstart=GhostBrain.OnStart
function GhostBrain:OnStart()
        old_ghostonstart(self)
        appendNode(self.bt.root,fearnode(self),1)
        appendNode(self.bt.root,stunNode(self),1)
end
