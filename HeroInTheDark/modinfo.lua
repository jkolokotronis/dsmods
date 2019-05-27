name = "Hero in the Dark"
id="herointhedark"
description = "This mod will incorporate traditional fantasy elements and lore while retaining the artistic style and the survive or die elements of Don\'t Starve. A large focus of the lore and design of the mod will be from D&D and other games/books within the genre."
author = "kraken121 / DeathDisciple"
version = "0.2.5.3 Beta"

forumthread = "/files/file/518-mod-hero-in-the-dark/"
icon_atlas = "modicon.xml"
icon = "modicon.tex"

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

configuration_options =
{
    {
        name = "damageindicators",
        label = "Damage Indicators",
        options =
        {
            {description = "On", data = true},
            {description = "Off", data = false}
        },
        default = true,
    },
    --[[
    {
        name = "detailedexamine",
        label = "Detailed Examine",
        options =
        {
            {description = "On", data = true},
            {description = "Off", data = false}
        },
        default = true,
    },]]
    {
        name = "spellbooks",
        label = "Detailed Spell Books",
        options =
        {
            {description = "On", data = true},
            {description = "Off", data = false}
        },
        default = true,
    },
    {
        name = "extracontrollerrange",
        label = "Extra Controller Target Range",
        options =
        {
            {description = "On", data = true},
            {description = "Off", data = false}
        },
        default = true,
    },
    {
        name = "extrazoom",
        label = "Unlock full camera zoom",
        options =
        {
            {description = "On", data = true},
            {description = "Off", data = false}
        },
        default = true,
    },
    {
        name = "memspikefix",
        label = "Local MemSpikefix version",
        options =
        {
            {description = "On", data = true},
            {description = "Off", data = false}
        },
        default = false,
    }
}

api_version = 6
priority=-1