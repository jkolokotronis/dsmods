
local Armor=require "components/armor"
local armor_takedamage_def=Armor.TakeDamage
function Armor:TakeDamage(damage_amount, attacker, weapon,element)
        --dealing with elemental damage ONLY, as of now can't have both phys and ele damage at once, since damage_amount is just one
        local damagetype=element
        if(not damagetype and weapon and weapon.components.weapon and weapon.components.weapon.fa_damagetype) then
            damagetype=weapon.components.weapon.fa_damagetype
        elseif(attacker and attacker.fa_damagetype)then
            damagetype=attacker.fa_damagetype
        end
--      technically, could just use the same logic for it - but it would break any mod that adds armor without regards to this system
        if(damagetype and damagetype~=FA_DAMAGETYPE.PHYSICAL)then
            --ele dmg, ignore default behavior altogether
            if(self.fa_resistances and self.fa_resistances[damagetype] and self.fa_resistances[damagetype]~=0)then
                local absorbed = damage_amount * self.fa_resistances[damagetype];
                absorbed = math.floor(math.min(absorbed, self.condition))
                local leftover = damage_amount - absorbed
                --note: absorb % can be negative, in which case you are taking more damage - which is fine, but it shouldnt repair your gear
                --TODO should absorbing elemental damage damage the equipment?
                if(leftover>0)then
                    self:SetCondition(self.condition - absorbed)
                    if self.ontakedamage then
                        self.ontakedamage(self.inst, damage_amount, absorbed, leftover)
                    end
                end
                -- yes >1 will heal you now, it is fully intentional, fire elemental is getting healed by fire etc
                return leftover
            else
                return damage_amount
            end
        else
            --physical damage, goes through as it wouldve been
            return armor_takedamage_def(self,damage_amount,attacker,weapon)
        end
   
    end


local Health=require "components/health"
--the point of this thing is to allow 'buffers', e.g. temp hp 

--[[
function Health:ApplyDamage(dmg, attacker,weapon,element)
    local damage=dmg
    local damagetype=element
        if(not damagetype and weapon and weapon.components.weapon and weapon.components.weapon.fa_damagetype) then
            damagetype=weapon.components.weapon.fa_damagetype
        elseif(attacker and attacker.fa_damagetype)then
            damagetype=attacker.fa_damagetype
        end

    if(not damagetype) then damagetype=FA_DAMAGETYPE.PHYSICAL end
--    if(damagetype)then
        local res=self.fa_resistances[damagetype]
        if(res) then damage=damage*(1-res) end
        if(self.fa_protection[damagetype] and damage>0)then
            if(self.fa_protection[damagetype]>damage)then
                self.fa_protection[damagetype]=self.fa_protection[damagetype]-damage
                damage=0
            else
                damage=damage-self.fa_protection[damagetype]
                self.fa_protection[damagetype]=0
            end
        end
--    end
    if(self.fa_temphp and damage>0)then
        if(self.fa_temphp>damage)then
                self.fa_temphp=self.fa_temphp-damage
                damage=0
            else
                damage=damage-self.fa_temphp
                self.fa_temphp=0
            end
    end

    return damage
end
--]]
local Combat=require "components/combat"

local combat_doattack_def=Combat.DoAttack
function Combat:DoAttack(target_override, weapon, projectile, stimuli, instancemult)
    local targ = target_override or self.target
    local weapon = weapon or self:GetWeapon()

    --basically since the whole thing happens twice on projectile attacks, i'm doing a check only on hit
    --I don't care to do the whole canattack twice either, wether it's faster or not to do so... I think it is faster like this
    if((projectile and not projectile:HasTag("spellprojectile")) or not(weapon and (weapon.components.projectile or weapon.components.weapon:CanRangedAttack())))then
        local dodge=0
        if(targ and targ.components.inventory)then
            dodge=targ.components.inventory:GetDodgeChance()
        end
        if(targ and targ.components.health and targ.components.health.fa_dodgechance)then
            dodge=dodge+targ.components.health.fa_dodgechance
        end
        if(math.random()<dodge)then
            self.inst:PushEvent("onmissother", {target = targ, weapon = weapon})
            --no idea if i should do this or not? if primary target dodges attack, attacker gets unbalanced?
            --[[
            if self.areahitrange then
                local epicentre = projectile or self.inst
                self:DoAreaAttack(epicentre, self.areahitrange, weapon, nil, stimuli)
            end]]
            return
        end
    end
    return combat_doattack_def(self,target_override,weapon,projectile, stimuli, instancemult)
end
--TODO there's gotta be a better way... but not everything reads inventory/has armor
local combat_getattacked_def=Combat.GetAttacked
function Combat:GetAttacked(attacker, damage, weapon,stimuli,element)
    --print ("ATTACKED", self.inst, attacker, damage)
    local blocked = false
    local player = GetPlayer()
    local init_damage = damage

    self.lastattacker = attacker
    if self.inst.components.health and damage then   

            local damagetype=element
            if(not damagetype and weapon and weapon.components.weapon and weapon.components.weapon.fa_damagetype) then
                damagetype=weapon.components.weapon.fa_damagetype
            elseif(attacker and attacker.fa_damagetype)then
                damagetype=attacker.fa_damagetype
            end
--rog moisture modifiers
        if(damagetype and self.inst.components.moisture)then
            local percent=self.inst.components.moisture:GetMoisturePercent()
            if(percent>0)then
                local mod=FA_WETTNESS_DAMAGE_MODIFIER[damagetype]
                if(mod)then
                    damage=damage+mod*percent*damage
                end
            end           
        end
         --now i need to deal with health mods - this should really be done in DoDelta
--         damage=self.inst.components.health:ApplyDamage(damage,attacker,weapon,damagetype)

        if self.inst.components.inventory then
            damage = self.inst.components.inventory:ApplyDamage(damage, attacker,weapon,damagetype)
        end
        if METRICS_ENABLED and GetPlayer() == self.inst then
            local prefab = (attacker and (attacker.prefab or attacker.inst.prefab)) or "NIL"
            ProfileStatsAdd("hitsby_"..prefab,math.floor(damage))
            FightStat_AttackedBy(attacker,damage,init_damage-damage)
        end
      
--            print("damage",damage)
        --why are you so inclined to prevent healing by damage, silly klei?
        if damage~=0 and self.inst.components.health:IsInvincible() == false then

            self.inst.components.health:DoDelta(-damage, nil, attacker and attacker.prefab or "NIL",nil,damagetype)
            if self.inst.components.health:GetPercent() <= 0 then
                if attacker then
                    attacker:PushEvent("killed", {victim = self.inst})
                end

                if METRICS_ENABLED and attacker and attacker == GetPlayer() then
                    ProfileStatsAdd("kill_"..self.inst.prefab)
                    FightStat_AddKill(self.inst,damage,weapon)
                end
                if METRICS_ENABLED and attacker and attacker.components.follower and attacker.components.follower.leader == GetPlayer() then
                    ProfileStatsAdd("kill_by_minion"..self.inst.prefab)
                    FightStat_AddKillByFollower(self.inst,damage,weapon)
                end
                if METRICS_ENABLED and attacker and attacker.components.mine then
                    ProfileStatsAdd("kill_by_trap_"..self.inst.prefab)
                    FightStat_AddKillByMine(self.inst,damage)
                end
                
                if self.onkilledbyother then
                    self.onkilledbyother(self.inst, attacker)
                end
            end
        else
            blocked = true
        end
    end
    

    if self.inst.SoundEmitter then
        local hitsound = self:GetImpactSound(self.inst, weapon)
        if hitsound then
            self.inst.SoundEmitter:PlaySound(hitsound)
            --print (hitsound)
        end

        if self.hurtsound then
            self.inst.SoundEmitter:PlaySound(self.hurtsound)
        end

    end
    
    if not blocked then
         self.inst:PushEvent("attacked", {attacker = attacker, damage = damage, weapon = weapon, stimuli = stimuli})
    
        if self.onhitfn then
            self.onhitfn(self.inst, attacker, damage)
        end
        
       if attacker then
            attacker:PushEvent("onhitother", {target = self.inst, damage = damage, stimuli = stimuli})
            if attacker.components.combat and attacker.components.combat.onhitotherfn then
                attacker.components.combat.onhitotherfn(attacker, self.inst, damage, stimuli)
            end
        end
    else
        self.inst:PushEvent("blocked", {attacker = attacker})
    end
    
    return not blocked
end

local FIRE_TIMESTART = 1.0
--[[
function Health:DoFireDamage(amount1, doer)
    if not self.invincible  then
        if not self.takingfiredamage then
            self.takingfiredamage = true
            self.takingfiredamagestarttime =GetTime()
            self.inst:StartUpdatingComponent(self)
            self.inst:PushEvent("startfiredamage")
            ProfileStatsAdd("onfire")
        end
        
        local time = GetTime()
        self.lastfiredamagetime = time
        local amount=amount1

        if(self.fa_resistances[FA_DAMAGETYPE.FIRE])then
            self.fire_damage_scale=self.fa_resistances[FA_DAMAGETYPE.FIRE]
        end
        if(self.inst and self.inst.components and self.inst.components.inventory)then
            amount = self.inst.components.inventory:ApplyDamage(amount, doer,nil,FA_DAMAGETYPE.FIRE)
        end
        
        if time - self.takingfiredamagestarttime > FIRE_TIMESTART and amount ~= 0 then
            --extra param might not be 'necesary'... since I know  from this string the cause is fire, i might as well use that. 
            --But since this is dirty override, its irrelevant, anyone touching this code will collide regardless
            self:DoDelta(-amount*self.fire_damage_scale, false, "fire")
            self.inst:PushEvent("firedamage")       
        end
    end
end
]]
local old_healthdodelta=Health.DoDelta
--since I'm never using 'cause', I can safely assume that cause=="fire" means I should calculate the res
function Health:DoDelta(amount, overtime, cause, ignore_invincible,dmgtype)
    local damage=-amount
    local damagetype=dmgtype
    if(not damagetype)then
        if(cause=="fire" or cause=="hot")then
            damagetype=FA_DAMAGETYPE.FIRE
        elseif(cause=="cold")then
            damagetype=FA_DAMAGETYPE.COLD
        end
    end
    --needed cause this whole thing makes no sense on 'healing', no matter what causes it
    if(damage>0)then

    if(not damagetype) then damagetype=FA_DAMAGETYPE.PHYSICAL end
--    if(damagetype)then
        local res=self.fa_resistances[damagetype]
        if(res) then damage=damage*(1-res) end
        if(self.fa_protection[damagetype] and damage>0)then
            if(self.fa_protection[damagetype]>damage)then
                self.fa_protection[damagetype]=self.fa_protection[damagetype]-damage
                damage=0
            else
                damage=damage-self.fa_protection[damagetype]
                self.fa_protection[damagetype]=0
            end
        end
    end
-- even if it hits temp hp, it will not 'remove' hp but it should trigger the indicator (it got hit, but it went into temp, as opposed to simply being eaten by prot from el)
--    print("damage",damage,damagetype)
    if(FA_ModUtil.GetModConfigData("damageindicators"))then
        if math.abs(damage) > 0.1 and (damage>0 or self:GetPercent()<1) then
            FA_ModUtil.MakeDamageEntity(self.inst, -damage,damagetype)
        end
    end
    if(damage>0)then
        if(self.fa_temphp and damage>0)then
            if(self.fa_temphp>damage)then
                    self.fa_temphp=self.fa_temphp-damage
                    damage=0
            else
                damage=damage-self.fa_temphp
                self.fa_temphp=0
            end
        end
    end
    
    return old_healthdodelta(self,-damage, overtime, cause, ignore_invincible)
end


if(FA_ModUtil.GetModConfigData("extracontrollerrange"))then
    print('overriding controller max range')
    local PlayerController=require "components/playercontroller"
    --sigh inline constants
    
    function PlayerController:UpdateControllerAttackTarget(dt)
    if self.controllerattacktargetage then
        self.controllerattacktargetage = self.controllerattacktargetage + dt
    end
    
    --if self.controller_attack_target and self.controllerattacktargetage and self.controllerattacktargetage < .3 then return end

    local heading_angle = -(self.inst.Transform:GetRotation())
    local dir = Vector3(math.cos(heading_angle*DEGREES),0, math.sin(heading_angle*DEGREES))
    
    local me_pos = Vector3(self.inst.Transform:GetWorldPosition())
    
    
    local min_rad = 4
    local max_range = self.inst.components.combat:GetAttackRange() + 3

    local rad = max_range
    if self.controller_attack_target and self.controller_attack_target:IsValid() and self:CanAttackWithController(self.controller_attack_target) then
        local distsq = self.inst:GetDistanceSqToInst(self.controller_attack_target)
        if distsq <= max_range*max_range then
            rad = math.min(rad, math.sqrt(distsq) * .5)
        end
    end
    
    local x,y,z = me_pos:Get()
    local nearby_ents = TheSim:FindEntities(x,y,z, rad, must_have_attack, cant_have_attack)

    local target = nil
    local target_score = nil
    local target_action = nil

    if self.controller_attack_target then
        table.insert(nearby_ents, self.controller_attack_target)
    end

    for k,v in pairs(nearby_ents) do
    
        local canattack = self:CanAttackWithController(v)

        if canattack then

            local px,py,pz = v.Transform:GetWorldPosition()
            local ox,oy,oz = px - me_pos.x, py - me_pos.y, pz - me_pos.z
            local dsq = ox*ox + oy*oy +oz*oz
            local dist = dsq > 0 and math.sqrt(dsq) or 0
            
            local dot = 0
            if dist > 0 then
                local nx, ny, nz = ox/dist, oy/dist, oz/dist
                dot = nx*dir.x + ny*dir.y + nz*dir.z
            end
            
            if (dist < min_rad or dot > 0) and dist < max_range then
                
                local score = (1 + dot)* (1 / math.max(min_rad*min_rad, dsq))

                if (v.components.follower and v.components.follower.leader == self.inst) or self.inst.components.combat:IsAlly(v) then
                    score = score * .25
                elseif v:HasTag("monster") then
                    score = score * 4
                end

                if v.components.combat.target == self.inst then
                    score = score * 6
                end

                if self.controller_attack_target == v then
                    score = score * 10
                end

                if not target or target_score < score then
                    target = v
                    target_score = score
                end
            end
        end
    end

    if not target and self.controller_target and self.controller_target:HasTag("wall") and self.controller_target.components.health and self.controller_target.components.health.currenthealth > 0 then
        target = self.controller_target
    end

    if target ~= self.controller_attack_target then
        self.controller_attack_target = target
        self.controllerattacktargetage = 0
    end
    
    

end

end