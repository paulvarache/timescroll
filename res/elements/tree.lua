return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 4,
  height = 4,
  tilewidth = 64,
  tileheight = 96,
  nextobjectid = 1,
  properties = {
    ["lifespan"] = 4
  },
  tilesets = {
    {
      name = "tree",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 96,
      spacing = 0,
      margin = 0,
      image = "../images/elements/tree.png",
      imagewidth = 256,
      imageheight = 384,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 16,
      tiles = {
        {
          id = 3,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 10.1423,
                y = 38.5407,
                width = 53.6092,
                height = 5.21603,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 7,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 19.1254,
                y = 42.018,
                width = 41.1487,
                height = 5.21603,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 11,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 19.4152,
                y = 39.9896,
                width = 42.5976,
                height = 4.63647,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 15,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            properties = {},
            objects = {
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 22.8926,
                y = 38.2509,
                width = 40.2793,
                height = 6.08537,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "base",
      x = 0,
      y = 0,
      width = 4,
      height = 4,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["lifespan"] = 4
      },
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    }
  }
}
