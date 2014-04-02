local BLUETOTEM_RANGE=8
local BLUETOTEM_DAMAGE=100
local WALL_WIDTH=1.0

FA_ElectricalFence = {}
FA_ElectricalFence.nodetable={}

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
        local pos1=Vector3(pos.x,0,pos.z)
      current=Vector3(current.x,0,current.z)
--        print("from",pos,"to",current)
        local dist=math.sqrt(node:GetDistanceSqToInst(v))
        local scale=dist/4.8
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
        boom.Transform:SetRotation(angle)
        anim:PlayAnimation("idle",true)
        boom.Transform:SetScale(scale,1,scale)

        local follower = boom.entity:AddFollower()
            follower:FollowSymbol( node.GUID, "fa_bluetotem", 0.1, -50, -0.0001 )
--        boom:FacePoint(current)        
--        boom.entity:SetParent( node.entity )

        node.fa_effectlist[v.GUID]=boom

end

FA_ElectricalFence.AddNode=function(node)
	FA_ElectricalFence.RegisterNode(node)

	local pos=Vector3(node.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BLUETOTEM_RANGE,{'lightningfence'}, {"FX", "DECOR","INLIMBO"})
    for k,v in pairs(ents) do
        
      if(v~=node and not node.fa_nodelist[v.GUID])then
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
FA_ElectricalFence.RemoveNode=function(node)
    while(FA_ElectricalFence.lock)do
        Sleep(0.1)
    end

    FA_ElectricalFence.lock=true

	if(FA_ElectricalFence.nodetable[node.GUID])then
		FA_ElectricalFence.nodetable[node.GUID]=nil
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
--yeah, no, it has no length, really?
        local tablecount=0
        for xx,yy in pairs(v.fa_nodelist) do tablecount=tablecount+1 end

        print("nodelist",tablecount)
	
    	if(tablecount<1)then
			v.components.fueled:StopConsuming()
			if(v.fa_puffanim)then
                v.fa_puffanim:Remove()
                v.fa_puffanim=nil
			end
		end
	end 

    FA_ElectricalFence.lock=false
end

FA_ElectricalFence.RegisterNode=function(node)
	FA_ElectricalFence.nodetable[node.GUID]=node
end

FA_ElectricalFence.MakeGrid=function()
	for k,v in pairs(FA_ElectricalFence.nodetable)do
		FA_ElectricalFence.AddNode(v)
	end 
end

FA_ElectricalFence.StartTask=function()
--xpcall(everything) catch(donothing) because it crashes if and only if it's in illegal state due to language limitations?
-- this will crash because no volatile
   
    FA_ElectricalFence.caster=GetPlayer() --get this out of here
    if(FA_ElectricalFence.task)then
        FA_ElectricalFence.task:Cancel()
    end
    FA_ElectricalFence.task=GetPlayer():DoPeriodicTask(1, function()
--note this WILL trigger double 
        while(FA_ElectricalFence.lock)do
            Sleep(0.1)
        end
        FA_ElectricalFence.lock=true
        for k,node in pairs(FA_ElectricalFence.nodetable) do
            

            local pos=Vector3(node.Transform:GetWorldPosition())
            for k1,v in pairs(node.fa_nodelist) do
                local p2=Vector3(v.Transform:GetWorldPosition())
                local dist=math.sqrt(node:GetDistanceSqToInst(v))
                local middle=Vector3((pos.x+p2.x)/2,(pos.y+p2.y)/2,(pos.z+p2.z)/2)
                --rsin(angle) on the edges = the width of a trigger zone,dlsin(alpha) = radius delta,tan(alpha)=dr/width
                local alpha=math.atan(WALL_WIDTH/dist)
                local r=math.tan(alpha)*WALL_WIDTH+dist
                local angle=node:GetAngleToPoint(v:GetPosition())
                local ents = TheSim:FindEntities(middle.x, middle.y, middle.z, r,nil, {"FX", "DECOR","INLIMBO","pet","companion","player"})
                for i,caught in pairs(ents) do
                    if(caught and caught.components.combat and not (caught.components.health and caught.components.health:IsDead()))then
                        local caughtangle=node:GetAngleToPoint(caught:GetPosition())-angle
                        local dh=math.sqrt(node:GetDistanceSqToInst(caught))*math.sin(caughtangle)
                        --phew
                        if(dh<=WALL_WIDTH)then
                            caught.components.combat:GetAttacked(FA_ElectricalFence.caster,BLUETOTEM_DAMAGE/2, nil)
                        end
                    end
                end
            end
        end
        FA_ElectricalFence.lock=false
    end)
end

return FA_ElectricalFence