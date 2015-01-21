
local function dappernessPostContruct(component)
    local dapperness_getdapperness_def=component.GetDapperness
    function component:GetDapperness(owner)
        local d=dapperness_getdapperness_def(self,owner)
        if(owner and owner:HasTag("player") and owner.prefab=="cleric" and d<0)then
          --  print("got in dapperness nerf")
            d=d*2
        end
        return d
    end
end

FA_ModUtil.AddClassPostConstruct("components/dapperness",dappernessPostContruct)
if(FA_DLCACCESS)then
    FA_ModUtil.AddClassPostConstruct("components/equippable",dappernessPostContruct)
end
--AddComponentPostInit("armor",function(component,inst)
FA_ModUtil.AddClassPostConstruct("components/armor",function(component)
    component.fa_resistances=component.fa_resistances or {}
end)
--why the heck doesnt it have a default?
FA_ModUtil.AddClassPostConstruct("components/combat",function(component)
    component.damagemultiplier=1
end)
FA_ModUtil.AddClassPostConstruct("components/health",function(component)
    component.fa_resistances=component.fa_resistances or {}
    component.fa_protection=component.fa_protection or {}
    component.fa_damagereduction=component.fa_damagereduction or {}
    component.fa_dodgechance=component.fa_dodgechance or 0
    component.fa_temphp=component.fa_temphp or 0
    component.fa_spellreflect=component.fa_spellreflect or 0
    component.fa_stunresistance=component.fa_stunresistance or 0
end)
FA_ModUtil.AddClassPostConstruct("components/sanity",function(component)
    --no namespaces because if it clashes then it likely should clash anyway
    component.duskmultiplier=1
end)


function lootdropperPostInit(component)
    local old_generateloot=component.GenerateLoot
    if(not component.fallenLootTables)then
            component.fallenLootTables={}
    end
    function component:AddFallenLootTable(lt,weight,chance)
        table.insert(self.fallenLootTables,{loottable=lt,weight=weight,chance=chance})
    end
    function component:GenerateLoot()
        local loots=old_generateloot(self)
        for ind,tabledata in pairs(self.fallenLootTables) do
            local chance=math.random()
            if(chance<=tabledata.chance)then
                local newloot=nil
                --pick one of...
                local rnd = math.random()*tabledata.weight
                for k,v in pairs(tabledata.loottable) do
                    rnd = rnd - v
                    if rnd <= 0 then
                        newloot=k
                        break
                    end
                end
                table.insert(loots, newloot)
            end
        end
        return loots
    end

    function component:DropLoot(pt)
    local prefabs = self:GenerateLoot()
    local burn=false
    if not self.inst.components.fueled and self.inst.components.burnable and self.inst.components.burnable:IsBurning() then
        burn=true
        for k,v in pairs(prefabs) do
            local cookedAfter = v.."_cooked"
            local cookedBefore = "cooked"..v
            if GLOBAL.PrefabExists(cookedAfter) then
                prefabs[k] = cookedAfter
            elseif GLOBAL.PrefabExists(cookedBefore) then
                prefabs[k] = cookedBefore 
            else   
            --this was burning everything in list regardless of wether it can be actually burned        
--                prefabs[k] = "ash"               
            end
        end
    end
    for k,v in pairs(prefabs) do
        local loot=self:SpawnLootPrefab(v, pt)
        --now i have to check if it should burn instead, is there anything else i should be checking here?
        if(burn and loot and loot.components.burnable)then
            loot.components.burnable:Ignite()
        end
    end
    end

end

FA_ModUtil.AddComponentPostInit("lootdropper",lootdropperPostInit)
