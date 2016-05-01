return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 4,
  height = 4,
  tilewidth = 50,
  tileheight = 50,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Player",
      firstgid = 1,
      tilewidth = 50,
      tileheight = 50,
      spacing = 0,
      margin = 0,
      image = "../images/characters/player.png",
      imagewidth = 100,
      imageheight = 50,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 2,
      tiles = {
        {
          id = 0,
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
                x = 28.9964,
                y = 29.3937,
                width = 16.9808,
                height = 18.4703,
                rotation = 0,
                visible = true,
                properties = {}
              },
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 28.9964,
                y = 12.0157,
                width = 14.8954,
                height = 17.2787,
                rotation = 0,
                visible = true,
                properties = {}
              },
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 21.0522,
                y = 17.2787,
                width = 7.94423,
                height = 12.4129,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 1,
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
                x = 4.07142,
                y = 29.0957,
                width = 16.8815,
                height = 18.8675,
                rotation = 0,
                visible = true,
                properties = {}
              },
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 6.05748,
                y = 12.0157,
                width = 14.7961,
                height = 17.0801,
                rotation = 0,
                visible = true,
                properties = {}
              },
              {
                id = 0,
                name = "",
                type = "",
                shape = "rectangle",
                x = 20.8536,
                y = 16.1864,
                width = 8.14284,
                height = 12.9094,
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
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 4,
      height = 4,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    }
  }
}
