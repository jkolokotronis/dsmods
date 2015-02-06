require("stategraphs/commonstates")


local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events=
{
  
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnAttack(),
}


local states=
{
    State{
        name = "spawn",
        tags = {"spawn","busy"},
        onenter = function(inst, playanim)
            inst.AnimState:PlayAnimation('idle')
            inst.Physics:Stop()
        end,           

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
  
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.AnimState:PlayAnimation('idle', true)
            inst.Physics:Stop()
        end,
    },
    State{
        name = "walk",
        tags = {"walk", "canrotate"},
        onenter = function(inst, playanim)
            inst.AnimState:PlayAnimation('run', true)
            inst.components.locomotor:RunForward()
            
        end,
    },    

    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run")
            inst.sg.mem.foosteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
        
        timeline=
        {        
            TimeEvent(4*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("fa/mobs/ogre/footstep")
            end),
        },        
        
    },

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("walk",true)
            
        end,
        
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst)
                inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
            TimeEvent(15*FRAMES, function(inst)
                inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
    },
    
    State{
    
        name = "run_stop",
        tags = {"canrotate", "idle"},
        
        onenter = function(inst) 
            inst.Physics:Stop()
            inst.sg:GoToState("idle")
        end,
        
    },

    State{
        name = "attack",
        tags = {"attack", "busy", "canrotate"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack")
--            inst.SoundEmitter:PlaySound("fa/mobs/ogre/atk")
        end,
        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        events=
        {
            EventHandler("animover", function(inst) inst.components.combat:SetTarget(nil) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "stomp",
        tags = { "busy"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("stomp")
        end,
        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        events=
        {
            EventHandler("animover", function(inst) inst.components.combat:SetTarget(nil) inst.sg:GoToState("idle") end),
        },
    },
    State{
        name = "spell",
        tags = { "busy", "canrotate"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("spell")
        end,
        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        events=
        {
            EventHandler("animover", function(inst) inst.components.combat:SetTarget(nil) inst.sg:GoToState("idle") end),
        },
    },
	State{
		name = "hit",
        tags = {"busy", "hit"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
--            inst.SoundEmitter:PlaySound("fa/mobs/ogre/hurt")
            inst.AnimState:PlayAnimation("hurt")
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
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
--            inst.SoundEmitter:PlaySound("fa/mobs/ogre/death")
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,

    },

    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("eat")
        end,
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
}


return StateGraph("dryad", states, events, "idle", actionhandlers)

