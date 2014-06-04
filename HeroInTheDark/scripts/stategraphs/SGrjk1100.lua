require("stategraphs/commonstates")

local events=
{    
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst) 
        if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then 
            inst.sg:GoToState("attack") 

        end 
    end),
    CommonHandlers.OnDeath(),
    --CommonHandlers.OnAttacked(),
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not 
            inst.sg:HasStateTag("attack") then
            inst.sg:GoToState("hit") 
        end 
    end)
}

local states=
{   
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.syncanim("idle_loop", true)
            --inst.AnimState:PlayAnimation("idle_loop", true)
        end, 
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.syncanim("death")      
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,

        timeline = 
        {
            TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeballturret/pop") end)
        },
    },    
        
    State{
        name = "hit",
        tags = {"hit"},
        
        onenter = function(inst) inst.syncanim("hit") end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },        
    },

    State
    { 
        name = "attack",
        tags = {"attack", "canrotate"},
        onenter = function(inst)
            inst.components.lighttweener:StartTween(nil, 0, .65, .7, nil, 0, function(inst, light) if light then light:Enable(true) end end)
            inst.components.lighttweener:StartTween(nil, 3.5, .9, .9, nil, .66, inst.dotweenin)
            inst.syncanim("atk")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeballturret/charge")
        end,        
        timeline=
        {
            TimeEvent(22*FRAMES, function(inst) 
                inst.components.combat:StartAttack()
                inst.components.combat:DoAttack()
                inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeballturret/shoot")
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },   
    State{
        name = "open",
        tags = {"busy", "open"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.components.sleeper:WakeUp()
--            inst.AnimState:PlayAnimation("open")
            inst.sg:GoToState("open_idle")
        end,

        events=
        {   
--            EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end ),
        },

        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/open") end),
        },        
    },

    State{
        name = "open_idle",
        tags = {"busy", "open"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_loop_open")
            
            if not inst.sg.mem.pant_ducking or inst.sg:InNewState() then
                inst.sg.mem.pant_ducking = 1
            end
            
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end ),
        },

        timeline=
        {
        
        
            TimeEvent(3*FRAMES, function(inst) 
                inst.sg.mem.pant_ducking = inst.sg.mem.pant_ducking or 1
                inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/pant", nil, inst.sg.mem.pant_ducking) 
                if inst.sg.mem.pant_ducking and inst.sg.mem.pant_ducking > .35 then
                    inst.sg.mem.pant_ducking = inst.sg.mem.pant_ducking - .05
                end
            end),
        },        
    },

    State{
        name = "close",
        tags = {""},
        
        onenter = function(inst)
--            inst.AnimState:PlayAnimation("closed")
            inst.sg:GoToState("idle")
        end,

        events=
        {   
--            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },

        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/close") end),
        },        
    },
}
    
return StateGraph("rjk1100", states, events, "idle")

