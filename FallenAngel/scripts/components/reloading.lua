local Reloading = Class(function(self, inst)
    self.inst = inst
    self.returnuses = 0
    self.ammotype = nil

end)

function Reloading:CollectUseActions(doer, target, actions, right)
    
    if  target.components.reloadable and target.components.reloadable.ammotype == self.ammotype and
        target.components.finiteuses and target.components.finiteuses.total>target.components.finiteuses.current then
        table.insert(actions, ACTIONS.RELOAD)
    end

end

return Reloading

