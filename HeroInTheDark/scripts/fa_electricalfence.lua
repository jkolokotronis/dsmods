local BLUETOTEM_RANGE=8
local BLUETOTEM_DAMAGE=100
local WALL_WIDTH=1.0

--its probably best to turn this into a world component...
FA_ElectricalFence = Class(function(self)
    self.nodetable={}

end)

local makepuffanimation=function(v)
    local boom = CreateEntity()
            boom.entity:AddTransform()
            local anim=boom.entity:AddAnimState()
            boom.Transform:SetTwoFaced()
--    boom.Transform:SetScale(5, 5, 1)
            boom:AddTag("NOCLICK")
            boom:AddTag("FX")
            anim:SetBank("fa_shieldpuff")
            anim:SetBuild("fa_shieldpuff")
            anim:PlayAnimation("idle",true)
            v.fa_puffanim=boom
            local follower = boom.entity:AddFollower()
            follower:FollowSymbol( v.GUID, "fa_bluetotem", 0.1,-80, -0.0001 )
--            boom.entity:SetParent( v.entity )
end

local makebeameffect=function(node,v)
    local pos=Vector3(node.Transform:GetWorldPosition())
    local current = Vector3(v.Transform:GetWorldPosition() )
--        print("from",pos,"to",current)
        local dist=math.sqrt(node:GetDistanceSqToInst(v))
--        local u1,v1=TheSim:GetScreenPos(pos:Get())
--        local u2,v2=TheSim:GetScreenPos(current:Get())
--        dist=math.sqrt((u2-u1)*(u2-u1)+(v2-v1)*(v2-v1))--node:GetDistanceSqToInst(v)--
        local scale=math.sqrt(dist/3.1)--120)
        print("dist",dist,"scale",scale)
        local angle = node:GetAngleToPoint(v:GetPosition())
        local boom = CreateEntity()
        boom:AddTag("FX")
        boom:AddTag("NOCLICK")
        boom.entity:AddTransform()
        local anim=boom.entity:AddAnimState()
        anim:SetBank("bolt_tesla")
        anim:SetBuild("bolt_tesla")
        boom.Transform:SetPosition(pos.x, pos.y, pos.z)
        anim:SetOrientation( ANIM_ORIENTATION.OnGround )
        boom.Transform:SetScale(scale,1,scale)
        boom.Transform:SetRotation(angle)
        anim:PlayAnimation("idle",true)
--        boom.Transform:SetScale(scale,1,scale)

        local follower = boom.entity:AddFollower()
            follower:FollowSymbol( node.GUID, "fa_bluetotem", 0.1, -50, -0.0001 )
--        boom:FacePoint(current)        
--        boom.entity:SetParent( node.entity )

        node.fa_effectlist[v.GUID]=boom

end

function FA_ElectricalFence:AddNode(node)
	self:RegisterNode(node)

	local pos=Vector3(node.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BLUETOTEM_RANGE,{'lightningfence'}, {"FX", "DECOR","INLIMBO"})
    for k,v in pairs(ents) do
        
      if(v~=node and self.nodetable[v.GUID] and not node.fa_nodelist[v.GUID])then
        print("k",k,"v",v)
    	if(not v.components.fueled.consuming)then
            print("starting consumer",v)
    		v.components.fueled:StartConsuming()
            makepuffanimation(v)    		
    	end
    	node.fa_nodelist[v.GUID]=v
   		v.fa_nodelist[node.GUID]=node
    	if(not node.components.fueled.consuming)then
            print("starting consumer",node)
    		node.components.fueled:StartConsuming()
            makepuffanimation(node)
    	end
    	makebeameffect(node,v)
    	
      end
    end

end

--This needs to be synchronized() or it will (IT DOES) crash the rest
function FA_ElectricalFence:RemoveNode(node)
    while(self.lock)do
        Sleep(0.1)
    end

    self.lock=true

	if(self.nodetable[node.GUID])then
		self.nodetable[node.GUID]=nil
	end
    if(node.fa_puffanim)then
                node.fa_puffanim:Remove()
                node.fa_puffanim=nil
            end
	for k,v in pairs(node.fa_effectlist) do
		v:Remove()
	end
	for k,v in pairs(node.fa_nodelist) do
		if(v.fa_nodelist[node.GUID])then
            print("removing ref to ",node.GUID)
			v.fa_nodelist[node.GUID]=nil
		end
		if(v.fa_effectlist[node.GUID])then
            v.fa_effectlist[node.GUID]:Remove()
            v.fa_effectlist[node.GUID]=nil
		end
        local tablecount=GetTableSize(v.fa_nodelist)

        print("nodelist",tablecount)
	
    	if(tablecount<1)then
			v.components.fueled:StopConsuming()
			if(v.fa_puffanim)then
                v.fa_puffanim:Remove()
                v.fa_puffanim=nil
			end
		end
	end 

    self.lock=false
end

function FA_ElectricalFence:RegisterNode(node)
	self.nodetable[node.GUID]=node
end

function FA_ElectricalFence:MakeGrid()
	for k,v in pairs(self.nodetable)do
		self:AddNode(v)
	end 
end

function FA_ElectricalFence:Config(inst,caster,dotags, donttags)
    self.inst=inst
    self.caster=caster
    self.dotags=dotags or {}
    self.donttags=donttags or {}
end

function FA_ElectricalFence:StartTask()
--xpcall(everything) catch(donothing) because it crashes if and only if it's in illegal state due to language limitations?
-- this will crash because no volatile
   
    if(self.task)then
        self.task:Cancel()
    end
    self.task=self.inst:DoPeriodicTask(1, function()
--note this WILL trigger double 
        while(self.lock)do
            Sleep(0.1)
        end
        self.lock=true
        for k,node in pairs(self.nodetable) do
            

            local pos=Vector3(node.Transform:GetWorldPosition())
            for k1,v in pairs(node.fa_nodelist) do
                local p2=Vector3(v.Transform:GetWorldPosition())
                local dist=math.sqrt(node:GetDistanceSqToInst(v))
                local middle=Vector3((pos.x+p2.x)/2,(pos.y+p2.y)/2,(pos.z+p2.z)/2)
                --rsin(angle) on the edges = the width of a trigger zone,dlsin(alpha) = radius delta,tan(alpha)=dr/width
                local alpha=math.atan(WALL_WIDTH/dist)
                local r=math.tan(alpha)*WALL_WIDTH+dist
                local angle=node:GetAngleToPoint(v:GetPosition())
                local ents = TheSim:FindEntities(middle.x, middle.y, middle.z, r,self.dotags,self.donttags)
                for i,caught in pairs(ents) do
                    if(caught and caught.components.combat and not (caught.components.health and caught.components.health:IsDead()))then
                        local caughtangle=node:GetAngleToPoint(caught:GetPosition())-angle
                        local dh=math.sqrt(node:GetDistanceSqToInst(caught))*math.sin(caughtangle)
                        --phew
                        if(dh<=WALL_WIDTH)then
                            caught.components.combat:GetAttacked(self.caster,BLUETOTEM_DAMAGE/2, nil,nil,FA_DAMAGETYPE.ELECTRIC)
                        end
                    end
                end
            end
        end
        self.lock=false
    end)
end

local PlayerFence=FA_ElectricalFence()
local MobFence=FA_ElectricalFence()

FA_ModUtil.AddPrefabPostInit("world",function(inst)
    inst:DoTaskInTime(0,function()
        --need to delay activate for player, but i could just fire it up for the rest without delays? Meh
        inst:DoTaskInTime(0,function()
            PlayerFence:Config(inst,GetPlayer(),nil, {"FX", "DECOR","INLIMBO","pet","companion","player"})
            PlayerFence:MakeGrid()
            PlayerFence:StartTask()
            MobFence:Config(inst,nil,nil,nil)
            MobFence:MakeGrid()
            MobFence:StartTask()
        end)
    end)
end)

return {PlayerFence=PlayerFence,MobFence=MobFence}