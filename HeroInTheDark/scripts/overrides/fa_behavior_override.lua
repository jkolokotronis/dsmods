require "behaviourtree"
require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/standandattack"
require "behaviours/standstill"

local AddPrefabPostInit=FA_ModUtil.AddPrefabPostInit

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

local function rootNoAttackNode(self)
    return WhileNode( function() return self.inst.fa_root~=nil end, "Root", StandStill(self.inst))
end

--just so i can do oneliner properly
local function appendNode(root,node,index)
    node.parent=root
    table.insert(root.children,index,node)
end

local function flyerDefault(inst)
    appendNode(inst.bt.root,fearnode(inst),1)
    appendNode(inst.bt.root,dazeNode(inst),1)
    appendNode(inst.bt.root,stunNode(inst),1)
end
-- @TODO what exactly do I want to do here?
local function fishDefault(inst)
    return flyerDefault(inst)
end

local function walkerDefault(inst)
    appendNode(inst.bt.root,fearnode(inst),1)
    appendNode(inst.bt.root,rootAttackNode(inst),1)
    appendNode(inst.bt.root,dazeNode(inst),1)
    appendNode(inst.bt.root,stunNode(inst),1)
end
local ButterflyBrain=require "brains/butterflybrain"
local old_onstart=ButterflyBrain.OnStart
function ButterflyBrain:OnStart()
    old_onstart(self)
    appendNode(self.bt.root,fearnode(self),1)

    local function fn(inst)
        inst:ClearBufferedAction()
        inst.Physics:Stop()
        inst.sg:GoToState("land")
--        inst.AnimState:PlayAnimation("land")
--        inst.AnimState:PushAnimation("idle", true)
        return true
    end
    local node=WhileNode( function() return self.inst.fa_stun~=nil or self.inst.fa_daze~=nil end, "Stun",StandStill(self.inst,fn))
    appendNode(self.bt.root, node,1)
end
local RabbitBrain=require "brains/rabbitbrain"
local old_ghostonstart=RabbitBrain.OnStart
function RabbitBrain:OnStart()
    old_ghostonstart(self)
    appendNode(self.bt.root,fearnode(self),1)
    appendNode(self.bt.root,dazeNode(self),1)
    appendNode(self.bt.root,stunNode(self),1)
    appendNode(self.bt.root,rootNoAttackNode(self),1)
end
--[[
local BirdBrain=require "brains/birdbrain"
local old_ghostonstart=BirdBrain.OnStart
function BirdBrain:OnStart()
        old_ghostonstart(self)
        appendNode(self.bt.root,dazeNode(self),1)
        appendNode(self.bt.root,stunNode(self),1)
end]]
local GhostBrain=require "brains/ghostbrain"
local old_ghostonstart=GhostBrain.OnStart
function GhostBrain:OnStart()
        old_ghostonstart(self)
        flyerDefault(self)
end
local BabyBeefaloBrain=require "brains/babybeefalobrain"
local old_onstart=BabyBeefaloBrain.OnStart
function BabyBeefaloBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
local BatBrain=require "brains/batbrain"
local old_onstart=BatBrain.OnStart
function BatBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
local BeardBunnyManBrain=require "brains/beardbunnymanbrain"
local old_onstart=BeardBunnyManBrain.OnStart
function BeardBunnyManBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local BeeBrain=require "brains/beebrain"
local old_onstart=BeeBrain.OnStart
function BeeBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
local BeefaloBrain=require "brains/beefalobrain"
local old_onstart=BeefaloBrain.OnStart
function BeefaloBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local BishopBrain=require "brains/bishopbrain"
local old_onstart=BishopBrain.OnStart
function BishopBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local BunnymanBrain=require "brains/bunnymanbrain"
local old_onstart=BunnymanBrain.OnStart
function BunnymanBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local FrogBrain=require "brains/frogbrain"
local old_onstart=FrogBrain.OnStart
function FrogBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local HoundBrain=require "brains/houndbrain"
local old_onstart=HoundBrain.OnStart
function HoundBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local KillerBeeBrain=require "brains/killerbeebrain"
local old_onstart=KillerBeeBrain.OnStart
function KillerBeeBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
local KnightBrain=require "brains/knightbrain"
local old_onstart=KnightBrain.OnStart
function KnightBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local KoalefantBrain=require "brains/koalefantbrain"
local old_onstart=KoalefantBrain.OnStart
function KoalefantBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local MermBrain=require "brains/mermbrain"
local old_onstart=MermBrain.OnStart
function MermBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local MonkeyBrain=require "brains/monkeybrain"
local old_onstart=MonkeyBrain.OnStart
function MonkeyBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local MosquitoBrain=require "brains/mosquitobrain"
local old_onstart=MosquitoBrain.OnStart
function MosquitoBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
local NightmareMonkeyBrain=require "brains/nightmaremonkeybrain"
local old_onstart=NightmareMonkeyBrain.OnStart
function NightmareMonkeyBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local NightmareCreatureBrain=require "brains/nightmarecreaturebrain"
local old_onstart=NightmareCreatureBrain.OnStart
function NightmareCreatureBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PenguinBrain=require "brains/penguinbrain"
local old_onstart=PenguinBrain.OnStart
function PenguinBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PerdBrain=require "brains/perdbrain"
local old_onstart=PerdBrain.OnStart
function PerdBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PigGuardBrain=require "brains/pigguardbrain"
local old_onstart=PigGuardBrain.OnStart
function PigGuardBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PigBrain=require "brains/pigbrain"
local old_onstart=PigBrain.OnStart
function PigBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local RockyBrain=require "brains/rockybrain"
local old_onstart=RockyBrain.OnStart
function RockyBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local RookBrain=require "brains/rookbrain"
local old_onstart=RookBrain.OnStart
function RookBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local ShadowCreatureBrain=require "brains/shadowcreaturebrain"
local old_onstart=ShadowCreatureBrain.OnStart
function ShadowCreatureBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local SlurperBrain=require "brains/slurperbrain"
local old_onstart=SlurperBrain.OnStart
function SlurperBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local SlurtleBrain=require "brains/slurtlebrain"
local old_onstart=SlurtleBrain.OnStart
function SlurtleBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local SmallBirdBrain=require "brains/smallbirdbrain"
local old_onstart=SmallBirdBrain.OnStart
function SmallBirdBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local SpiderBrain=require "brains/spiderbrain"
local old_onstart=SpiderBrain.OnStart
function SpiderBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local TallbirdBrain=require "brains/tallbirdbrain"
local old_onstart=TallbirdBrain.OnStart
function TallbirdBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local WalrusBrain=require "brains/walrusbrain"
local old_onstart=WalrusBrain.OnStart
function WalrusBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local WerePigBrain=require "brains/werepigbrain"
local old_onstart=WerePigBrain.OnStart
function WerePigBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end

--do i want to make epic mobs ccable? LeifBrain
--MinotaurBrain
if(FA_DLCACCESS)then

local BirchNutDrakeBrain=require "brains/birchnutdrakebrain"
local old_onstart=BirchNutDrakeBrain.OnStart
function BirchNutDrakeBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
--this will likely need fixing if spells end up firing in flight
local BuzzardBrain=require "brains/buzzardbrain"
local old_onstart=BuzzardBrain.OnStart
function BuzzardBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
local CatcoonBrain=require "brains/catcoonbrain"
local old_onstart=CatcoonBrain.OnStart
function CatcoonBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local MosslingBrain=require "brains/mosslingbrain"
local old_onstart=MosslingBrain.OnStart
function MosslingBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local MoleBrain=require "brains/molebrain"
local old_onstart=MoleBrain.OnStart
function MoleBrain:OnStart()
        old_onstart(self)
        appendNode(self.bt.root,fearnode(self),1)

    local function fn(inst)
        --wouldnt it be too good if it would actually work? chained 
        --[[
        if((not inst.sg.currentstate) or not(inst.sg.currentstate.name=="stunned"))then
            inst.sg:GoToState("stunned",false)
        end]]
        inst.sg:GoToState("idle")
        inst:ClearBufferedAction()
            inst.SoundEmitter:KillSound("sniff")
            inst.components.inventory:DropEverything(false, true) 
            inst.Physics:Stop() 
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mole/hurt")
            inst.AnimState:PlayAnimation("stunned_pre", false)
            inst.AnimState:PushAnimation("stunned_loop", true)
            --if i turn it on nothing will be there to turn it off - this really needs a proper state
--                inst.components.inventoryitem.canbepickedup = true
        return true
    end
    local node=WhileNode( function() return self.inst.fa_stun~=nil or self.inst.fa_daze~=nil end, "Stun",StandStill(self.inst,fn))
    appendNode(self.bt.root, node,1)
end

end
-- there is no way for me to distinguish sw world with pork support from pork world at this point, sw flag is OFF...
if(FA_SWACCESS or FA_PORKACCESS)then

local CrabBrain=require "brains/crabbrain"
local old_onstart=CrabBrain.OnStart
function CrabBrain:OnStart()
    old_onstart(self)
    appendNode(self.bt.root,fearnode(self),1)
    appendNode(self.bt.root,dazeNode(self),1)
    appendNode(self.bt.root,stunNode(self),1)
    appendNode(self.bt.root,rootNoAttackNode(self),1)
end
local LobsterBrain=require "brains/lobsterbrain"
local old_onstart=LobsterBrain.OnStart
function LobsterBrain:OnStart()
    old_onstart(self)
    appendNode(self.bt.root,fearnode(self),1)
    appendNode(self.bt.root,dazeNode(self),1)
    appendNode(self.bt.root,stunNode(self),1)
    appendNode(self.bt.root,rootNoAttackNode(self),1)
end
local DoydoyBrain=require "brains/doydoybrain"
local old_onstart=DoydoyBrain.OnStart
function DoydoyBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local DragoonBrain=require "brains/dragoonbrain"
local old_onstart=DragoonBrain.OnStart
function DragoonBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local MermFisherBrain=require "brains/mermfisherbrain"
local old_onstart=MermFisherBrain.OnStart
function MermFisherBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local FlupBrain=require "brains/flupbrain"
local old_onstart=FlupBrain.OnStart
function FlupBrain:OnStart()
        old_onstart(self)
--        walkerDefault(self)
    local node=WhileNode( function() return (not self.inst.sg:HasStateTag("jumping") and not self.inst.sg:HasStateTag("ambusher") and self.inst.fa_fear~=nil) end, 
        "Fear", Panic(self.inst))
    appendNode(self.bt.root,node ,1)
    local node=WhileNode( function() 
        return (not self.inst.sg:HasStateTag("jumping") and not self.inst.sg:HasStateTag("ambusher") and self.inst.fa_stun~=nil) end, 
        "Stun", StandStill(self.inst))
    appendNode(self.bt.root,node ,1)
    local node=WhileNode( function() 
        return (not self.inst.sg:HasStateTag("jumping") and not self.inst.sg:HasStateTag("ambusher") and self.inst.fa_daze~=nil) end, 
        "Daze", StandStill(self.inst))
    appendNode(self.bt.root,node ,1)
    local node=WhileNode( function() 
        return (not self.inst.sg:HasStateTag("jumping") and not self.inst.sg:HasStateTag("ambusher") and self.inst.fa_root~=nil) end, 
        "Root", StandAndAttack(self.inst))
    appendNode(self.bt.root,node ,1)

end
-- TODO check if spitting works while rooted
local SnakeBrain=require "brains/snakebrain"
local old_onstart=SnakeBrain.OnStart
function SnakeBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PrimeapeBrain=require "brains/primeapebrain"
local old_onstart=PrimeapeBrain.OnStart
function PrimeapeBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
-- TODO does fear work proper? they lack fire-panic
local SharkittenBrain=require "brains/sharkittenbrain"
local old_onstart=SharkittenBrain.OnStart
function SharkittenBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local WildboreGuardBrain=require "brains/wildboreguardbrain"
local old_onstart=WildboreGuardBrain.OnStart
function WildboreGuardBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local WildboreBrain=require "brains/wildborebrain"
local old_onstart=WildboreBrain.OnStart
function WildboreBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local CrocodogBrain=require "brains/crocodogbrain"
local old_onstart=CrocodogBrain.OnStart
function CrocodogBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local WhiteWhaleBrain=require "brains/whitewhalebrain"
local old_onstart=WhiteWhaleBrain.OnStart
function WhiteWhaleBrain:OnStart()
        old_onstart(self)
    appendNode(self.inst.bt.root,fearnode(inst),2)
    appendNode(self.inst.bt.root,dazeNode(inst),2)
    appendNode(self.inst.bt.root,stunNode(inst),2)
end
local BallphinBrain=require "brains/ballphinbrain"
local old_onstart=BallphinBrain.OnStart
function BallphinBrain:OnStart()
        old_onstart(self)
    appendNode(self.inst.bt.root,fearnode(inst),2)
    appendNode(self.inst.bt.root,dazeNode(inst),2)
    appendNode(self.inst.bt.root,stunNode(inst),2)
end
local KnightBoatBrain=require "brains/knightboatbrain"
local old_onstart=KnightBoatBrain.OnStart
function KnightBoatBrain:OnStart()
        old_onstart(self)
        fishDefault(self)
end
local SharxBrain=require "brains/sharxbrain"
local old_onstart=SharxBrain.OnStart
function SharxBrain:OnStart()
        old_onstart(self)
        fishDefault(self)
end
local SwordfishBrain=require "brains/swordfishbrain"
local old_onstart=SwordfishBrain.OnStart
function SwordfishBrain:OnStart()
        old_onstart(self)
        fishDefault(self)
end
local StungrayBrain=require "brains/stungraybrain"
local old_onstart=StungrayBrain.OnStart
function StungrayBrain:OnStart()
        old_onstart(self)
        fishDefault(self)
end

end

if(FA_PORKACCESS)then

local PigBanditBrain=require "brains/pigbanditbrain"
local old_onstart=PigBanditBrain.OnStart
function PigBanditBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PigTraderBrain=require "brains/pigtraderbrain"
local old_onstart=PigTraderBrain.OnStart
function PigTraderBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local GlowflyBrain=require "brains/glowflybrain"
local old_onstart=GlowflyBrain.OnStart
function GlowflyBrain:OnStart()
        old_onstart(self)
    appendNode(self.bt.root.children[1].children[2],fearnode(self),1)
    appendNode(self.bt.root.children[1].children[2],dazeNode(self),1)
    appendNode(self.bt.root.children[1].children[2],stunNode(self),1)
end
--[[
    local root = PriorityNode(
    {
      WhileNode( function() return not self.inst:HasTag("cocoon") end, "is not cocoon", 
        PriorityNode{
            WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            ]]

local HippopotamooseBrain=require "brains/hippopotamoosebrain"
local old_onstart=HippopotamooseBrain.OnStart
function HippopotamooseBrain:OnStart()
        old_onstart(self)
    appendNode(self.bt.root, WhileNode( function() 
        return (not self.inst.sg:HasStateTag("leapattack") and self.inst.fa_fear~=nil) end, 
        "Fear", Panic(self.inst)),1)
    appendNode(self.bt.root, WhileNode( function() 
        return (not self.inst.sg:HasStateTag("leapattack") and self.inst.fa_stun~=nil) end, 
        "Stun", StandStill(self.inst)),1)
    appendNode(self.bt.root, WhileNode( function() 
        return (not self.inst.sg:HasStateTag("leapattack") and self.inst.fa_daze~=nil) end, 
        "Daze", StandStill(self.inst)),1)
end
local AntBrain=require "brains/antbrain"
local old_onstart=AntBrain.OnStart
function AntBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local AntWarriorBrain=require "brains/antwarriorbrain"
local old_onstart=AntWarriorBrain.OnStart
function AntWarriorBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PikoBrain=require "brains/pikobrain"
local old_onstart=PikoBrain.OnStart
function PikoBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local BillBrain=require "brains/billbrain"
local old_onstart=BillBrain.OnStart
function BillBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local PogBrain=require "brains/pogbrain"
local old_onstart=PogBrain.OnStart
function PogBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
local SpiderMonkeyBrain=require "brains/spidermonkeybrain"
local old_onstart=SpiderMonkeyBrain.OnStart
function SpiderMonkeyBrain:OnStart()
        old_onstart(self)
        walkerDefault(self)
end
-- @TODO scorps use spider brain - check 
-- @TODO should plants be immune to root?
local FlytrapBrain=require "brains/flytrapbrain"
local old_onstart=FlytrapBrain.OnStart
function FlytrapBrain:OnStart()
        old_onstart(self)
    appendNode(self.bt.root,fearnode(self),1)
    appendNode(self.bt.root,dazeNode(self),1)
    appendNode(self.bt.root,stunNode(self),1)
end
local ThunderbirdBrain=require "brains/thunderbirdbrain"
local old_onstart=ThunderbirdBrain.OnStart
function ThunderbirdBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end
-- leaving shield as higher priority 
-- part of me wants to make fear > shield
local WeevoleBrain=require "brains/weevolebrain"
local old_onstart=WeevoleBrain.OnStart
function WeevoleBrain:OnStart()
        old_onstart(self)
    appendNode(self.bt.root.children[1].children[2],fearnode(self),2)
    appendNode(self.bt.root.children[1].children[2],dazeNode(self),2)
    appendNode(self.bt.root.children[1].children[2],stunNode(self),2)
    appendNode(self.bt.root.children[1].children[2],rootAttackNode(self),2)
end
local VampireBatBrain=require "brains/vampirebatbrain"
local old_onstart=VampireBatBrain.OnStart
function VampireBatBrain:OnStart()
        old_onstart(self)
        flyerDefault(self)
end

end
