require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/standandattack"
require "behaviours/standstill"


local function fearnode(inst)
	return WhileNode( function() return inst.fa_fear~=nil end, "Fear", Panic(inst))
end

local function stunNode(inst)
	return WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", Panic(self.inst))
end

local function rootAttackNode(inst)
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
        appendNode(self.bt.root,fearnode(inst),1)
        appendNode(self.bt.root,stunNode(inst),1)
end
