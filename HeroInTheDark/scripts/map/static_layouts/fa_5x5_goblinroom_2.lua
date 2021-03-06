return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 20,
  height = 20,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../tiles.png",
      imagewidth = 512,
      imageheight = 128,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 75,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 289,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 308,
          y = 216,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 311,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 266,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 242,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 219,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 196,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 174,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 150,
          y = 307,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 127,
          y = 307,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 105,
          y = 308,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 82,
          y = 307,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 59,
          y = 307,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 37,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 310,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 288,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 265,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 241,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 218,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 195,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 171,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 147,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 123,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 101,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 283,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 307,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 307,
          y = 34,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 307,
          y = 56,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 308,
          y = 79,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 308,
          y = 101,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 308,
          y = 124,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 309,
          y = 147,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 308,
          y = 170,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 309,
          y = 193,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 98,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 121,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 145,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 168,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 191,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 214,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 237,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 261,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 54,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 33,
          y = 10,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 9,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 34,
          y = 44,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 59,
          y = 227,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 78,
          y = 173,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 128,
          y = 130,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 176,
          y = 97,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 204,
          y = 50,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 152,
          y = 50,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 104,
          y = 92,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 63,
          y = 125,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 94,
          y = 42,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 53,
          y = 74,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 226,
          y = 126,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 164,
          y = 232,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 115,
          y = 265,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 118,
          y = 225,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 168,
          y = 190,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 176,
          y = 141,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 124,
          y = 176,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 230,
          y = 90,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 269,
          y = 51,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 57,
          y = 273,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 222,
          y = 265,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 175,
          y = 274,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 213,
          y = 234,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 259,
          y = 187,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 216,
          y = 179,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 263,
          y = 154,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 271,
          y = 107,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 196,
          y = 207,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 255,
          y = 273,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 250,
          y = 228,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 286,
          y = 244,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 297,
          y = 279,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_treasurechest",
          shape = "rectangle",
          x = 150,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_goblin_guard_1",
          shape = "rectangle",
          x = 142,
          y = 91,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
