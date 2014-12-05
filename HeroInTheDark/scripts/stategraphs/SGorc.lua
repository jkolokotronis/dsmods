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
    CommonHandlers.OnSleep(),
    
}

local states=
{

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.AnimState:PlayAnimation('Idle', true)
            inst.Physics:Stop()
        end,
    },

    State{
        name = "walk",
        tags = {"walk", "canrotate"},
        onenter = function(inst, playanim)
            inst.AnimState:PlayAnimation('Run', true)
            inst.components.locomotor:RunForward()
            
        end,
    },    

        State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("Run")
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
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },        
        
    },

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("Run",true)
            
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
            inst.SoundEmitter:PlaySound("fa/mobs/orc/orc_atk")
            inst.AnimState:PlayAnimation("Attack")
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
            inst.AnimState:PlayAnimation("Hurt")
            inst.SoundEmitter:PlaySound("fa/mobs/orc/orc_hit")
 --           inst.sg:GoToState("idle") 
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
            inst.AnimState:PlayAnimation("Death")
            inst.SoundEmitter:PlaySound("fa/mobs/orc/orc_die")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,

    },
    State{
        name = "sleep",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("Death")
        end,


    },

    State{
        name = "sleepin",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("Death")
            inst.components.locomotor:Stop()
            --inst.Controller:Enable(false)
            --inst.AnimState:Hide()
            inst:PerformBufferedAction()             
        end,
        
        onexit= function(inst)
            --inst.Controller:Enable(true)
            --inst.AnimState:Show()
        end,

    },
    
}


return StateGraph("orc", states, events, "idle", actionhandlers)

