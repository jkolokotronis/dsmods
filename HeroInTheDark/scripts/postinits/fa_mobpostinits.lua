
local makestackablePrefabPostInit=function(inst)
    if(not inst.components.stackable)then
    inst:AddComponent("stackable")
        inst.components.stackable.maxsize = 99
    end
end

local function AddRingAsTradeOption(inst)

    local shouldacceptitem=inst.components.trader.test
    inst.components.trader.test=function(inst, item)
        if(item and item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING)then
            return true
        else 
            return shouldacceptitem(inst,item)
        end
    end
    local onacceptitem=inst.components.trader.onaccept
    inst.components.trader.onaccept=function(inst, giver, item)
        if item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING then
            local current = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.RING)
            if current then
                inst.components.inventory:DropItem(current)
            end
            inst.components.inventory:Equip(item)
        end
        return onacceptitem(inst,giver,item)
    end
end

FA_ModUtil.AddPrefabPostInit("rabbithole", function(inst) FA_ModUtil.addT1LootPrefabPostInit(inst,0.05) end)
FA_ModUtil.AddPrefabPostInit("rabbit", makestackablePrefabPostInit)

FA_ModUtil.AddPrefabPostInit("bee",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("killerbee",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("mosquito",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("spider",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.25
end)
FA_ModUtil.AddPrefabPostInit("spider_warrior",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.25
end)
FA_ModUtil.AddPrefabPostInit("frog",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
end)
FA_ModUtil.AddPrefabPostInit("merm",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    inst:AddTag("pickpocketable")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    FA_ModUtil.addFullLootPrefabPostInit(inst,0.1) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.1)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
end)
FA_ModUtil.AddPrefabPostInit("pigguard",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    inst:AddTag("pickpocketable")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    FA_ModUtil.addFullLootPrefabPostInit(inst,0.1) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.1)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.5
end)
FA_ModUtil.AddPrefabPostInit("pigman",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_good")
    inst:AddTag("pickpocketable")
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    FA_ModUtil.addFullLootPrefabPostInit(inst,0.1)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.1)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2

    local onsetwerefn_old=inst.components.werebeast.onsetwerefn
    inst.components.werebeast:SetOnWereFn(function(inst)
        if onsetwerefn_old then onsetwerefn_old(inst) end
        inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
        inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.6
    end)
    local onsetnormalfn_old=inst.components.werebeast.onsetnormalfn
    inst.components.werebeast:SetOnNormalFn(function(inst)
        if onsetnormalfn_old then onsetnormalfn_old(inst) end
        inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
        inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    end)
    AddRingAsTradeOption(inst)

end)
FA_ModUtil.AddPrefabPostInit("pigking",function(inst)
    local shouldacceptitem=inst.components.trader.test
    inst.components.trader.test=function(inst, item)
    --yeah this is dirty
        if(item and item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING and item.prefab=="fa_ring_demon")then
            return true
        else 
            return shouldacceptitem(inst,item)
        end
    end

    local onacceptitem=inst.components.trader.onaccept
    inst.components.trader.onaccept=function(inst, giver, item)
        if item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING and item.prefab=="fa_ring_demon" then
            local wortox=SpawnPrefab("fa_cursedpigking")
--            wortox.components.inventory:GiveItem(item)
            wortox.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end
        return onacceptitem(inst,giver,item)
    end
end)
FA_ModUtil.AddPrefabPostInit("tentacle",function(inst)
    inst:AddTag("fa_magicalbeast")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
FA_ModUtil.AddPrefabPostInit("hound",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.5
end)
FA_ModUtil.AddPrefabPostInit("firehound",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-1
end)
FA_ModUtil.AddPrefabPostInit("icehound",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1.5
end)
FA_ModUtil.AddPrefabPostInit("tallbird",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
end)
FA_ModUtil.AddPrefabPostInit("walrus",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    inst:AddTag("pickpocketable")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.4
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
end)
FA_ModUtil.AddPrefabPostInit("little_walrus",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.2
end)
FA_ModUtil.AddPrefabPostInit("krampus",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("monkey",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("knight",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("knight_nightmare",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("bishop",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("bishop_nightmare",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("rook",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("rook_nightmare",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("tentacle_pillar_arm",function(inst)
    inst:AddTag("fa_magicalbeast")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
FA_ModUtil.AddPrefabPostInit("spider_hider",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
FA_ModUtil.AddPrefabPostInit("spider_spitter",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
FA_ModUtil.AddPrefabPostInit("spider_dropper",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
FA_ModUtil.AddPrefabPostInit("crawlinghorror",function(inst)
    inst:AddTag("undead")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
end)
FA_ModUtil.AddPrefabPostInit("terrorbeak",function(inst)
    inst:AddTag("undead")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
end)
FA_ModUtil.AddPrefabPostInit("eyeplant",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.1
end)
FA_ModUtil.AddPrefabPostInit("worm",function(inst)
    inst:AddTag("fa_magicalbeast")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
FA_ModUtil.AddPrefabPostInit("koalefant_summer",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.5
end)
FA_ModUtil.AddPrefabPostInit("koalefant_winter",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1.5
end)
FA_ModUtil.AddPrefabPostInit("smallbird",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("teenbird",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("slurtle",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
end)
FA_ModUtil.AddPrefabPostInit("snurtle",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("beefalo",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
end)
FA_ModUtil.AddPrefabPostInit("penguin",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
end)
FA_ModUtil.AddPrefabPostInit("bunnyman",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst:AddTag("pickpocketable")
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    FA_ModUtil.addFullLootPrefabPostInit(inst,0.1) 
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2
    AddRingAsTradeOption(inst)
end)
FA_ModUtil.AddPrefabPostInit("rocky",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_good")
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
    AddRingAsTradeOption(inst)
end)
FA_ModUtil.AddPrefabPostInit("crow",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("robin",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("robin_winter",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("babybeefalo",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("perd",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("butterfly",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("rabbit",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("spiderqueen",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable2PostInit(inst,0.15)
    FA_ModUtil.addFullLootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("leif",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2
end)
FA_ModUtil.AddPrefabPostInit("leif_sparse",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2

end)
FA_ModUtil.AddPrefabPostInit("deerclops",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
end)
FA_ModUtil.AddPrefabPostInit("minotaur",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    --should not happen
    if not inst.components.lootdropper.loot then
        inst.components.lootdropper.loot={}
    end
    FA_ModUtil.addKeyTable2PostInit(inst,0.15)
    table.insert(inst.components.lootdropper.loot,"fa_scroll_45")
    table.insert(inst.components.lootdropper.loot,"fa_scroll_45")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.75
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("dragonfly",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-1
end)
FA_ModUtil.AddPrefabPostInit("bearger",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("moose",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    FA_ModUtil.addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.3
end)
FA_ModUtil.AddPrefabPostInit("mossling",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("buzzard",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("catcoon",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    FA_ModUtil.addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
FA_ModUtil.AddPrefabPostInit("glommer",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_good")
end)
FA_ModUtil.AddPrefabPostInit("mole",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
FA_ModUtil.AddPrefabPostInit("bat",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
end)
FA_ModUtil.AddPrefabPostInit("lightninggoat",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
end)
FA_ModUtil.AddPrefabPostInit("warg",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
end)
FA_ModUtil.AddPrefabPostInit("birchnutdrake",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
end)
--[[
AddPrefabPostInit("deciduous_root",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_neutral")
--    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
end)
]]
FA_ModUtil.AddPrefabPostInit("ghost",function(inst)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-1
    inst.components.lootdropper:AddChanceLoot("nightmarefuel",0.75)
    inst.components.lootdropper:AddChanceLoot("nightmarefuel",0.18) 
    inst:AddTag("undead")
    inst:AddTag("fa_evil")
end)

FA_ModUtil.AddPrefabPostInit("mermhouse", function(inst) 
    FA_ModUtil.addFullStructureLootPrefabPostInit(inst,0.2) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.15)
end)
FA_ModUtil.AddPrefabPostInit("pighouse", function(inst) 
    FA_ModUtil.addFullStructureLootPrefabPostInit(inst,0.2) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.15)
end)
FA_ModUtil.AddPrefabPostInit("rabbithouse", function(inst) FA_ModUtil.addFullStructureLootPrefabPostInit(inst,0.2) end)

FA_ModUtil.AddPrefabPostInit("spiderden", function(inst) 
    FA_ModUtil.addT1LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
FA_ModUtil.AddPrefabPostInit("poisonspiderden", function(inst) 
    FA_ModUtil.addT1LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
FA_ModUtil.AddPrefabPostInit("spiderden_2", function(inst) 
    FA_ModUtil.addT1T2LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
FA_ModUtil.AddPrefabPostInit("poisonspiderden_2", function(inst) 
    FA_ModUtil.addT1T2LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
FA_ModUtil.AddPrefabPostInit("spiderden_3", function(inst) 
    FA_ModUtil.addFullStructureLootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
FA_ModUtil.AddPrefabPostInit("poisonspiderden_3", function(inst) 
    FA_ModUtil.addFullStructureLootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
