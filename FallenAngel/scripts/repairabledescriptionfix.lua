local function getcharacterstring(tab, item, modifier)
    if modifier then
        modifier = string.upper(modifier)
    end
  
    if tab then
        local topic_tab = tab[item]
        if topic_tab then
            if type(topic_tab) == "string" then
                return topic_tab
            elseif type(topic_tab) == "table" then
                if modifier and topic_tab[modifier] then
                    return topic_tab[modifier]
                end
  
                if topic_tab['GENERIC'] then
                    return topic_tab['GENERIC']
                end
  
                if #topic_tab > 0 then
                    return topic_tab[math.random(#topic_tab)]
                end
            end
        end
    end
end
 
function GetDescription(character, item, modifier)
    character = character and string.upper(character)
    local itemname = item.components.inspectable.nameoverride or item.prefab
    itemname = itemname and string.upper(itemname)
    modifier = modifier and string.upper(modifier)
  
    local ret = GetSpecialCharacterString(character)
 
     if not ret then
        if STRINGS.CHARACTERS[character] then
            ret = getcharacterstring(STRINGS.CHARACTERS[character].DESCRIBE, itemname, modifier)
        end
           
        if not ret and STRINGS.CHARACTERS.GENERIC then
            ret = getcharacterstring(STRINGS.CHARACTERS.GENERIC.DESCRIBE, itemname, modifier)
        end
       
        if not ret and STRINGS.CHARACTERS.GENERIC then
            ret = STRINGS.CHARACTERS.GENERIC.DESCRIBE_GENERIC
        end
       
        if ret and item and item.components.repairable and item.components.repairable:NeedsRepairs() and item.components.repairable.announcecanfix then
            local repairstring = nil
       
            if STRINGS.CHARACTERS[character] and STRINGS.CHARACTERS[character].DESCRIBE then
                repairstring = getcharacterstring(STRINGS.CHARACTERS[character], "ANNOUNCE_CANFIX", modifier)
            end
       
            if not repairstring and STRINGS.CHARACTERS.GENERIC then
                repairstring = getcharacterstring(STRINGS.CHARACTERS.GENERIC, "ANNOUNCE_CANFIX", modifier)
            end
               
            if repairstring then
                ret = ret..repairstring
            end
        end
    end
  
    return ret
end