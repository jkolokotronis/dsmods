require("constants")

local StaticLayout = require("map/static_layout")
local Layouts=require("map/layouts").Layouts
Layouts["FADungeonStart"] = StaticLayout.Get("map/static_layouts/fa_dungeon_start")
Layouts["FAGoblinRoom_1"] = StaticLayout.Get("map/static_layouts/fa_goblinroom_1")