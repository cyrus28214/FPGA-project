import json

tiles = []
with open("./script/resources.json", "r") as f:
    tiles = json.load(f)

# [
#     {
#         "name": "black_0",
#         "id": 0,
#         "addr": 0
#     },
# ]

#convert to {name: id}

tiles = {t["name"]: t["id"] for t in tiles}

MAP_WIDTH = 13
MAP_HEIGHT = 13

G = tiles["ground_0"]
W = tiles["wall_0"]
BW = tiles["wall_2"]
D = tiles["door_0"]
K = tiles["key_0"]
S = tiles["slime_0"]
ST0 = tiles["stair_0"]
ST1 = tiles["stair_1"]

maps = [
    [
        [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW],
        [BW,ST1,  G,  K,  S,  S,  S,  G,  G,  G,  G,  G, BW],
        [BW,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W,  G, BW],
        [BW,  G,  G,  G,  D,  G,  W,  G,  K,  G,  W,  G, BW],
        [BW,  K,  G,  G,  W,  G,  W,  G,  K,  G,  W,  G, BW],
        [BW,  W,  D,  W,  W,  G,  W,  W,  W,  G,  W,  G, BW],
        [BW,  K,  G,  G,  W,  G,  D,  G,  G,  G,  W,  G, BW],
        [BW,  G,  G,  K,  W,  G,  W,  W,  W,  W,  W,  G, BW],
        [BW,  W,  D,  W,  W,  G,  G,  G,  G,  G,  G,  G, BW],
        [BW,  G,  G,  G,  W,  W,  D,  W,  W,  W,  D,  W, BW],
        [BW,  G,  G,  K,  W,  K,  G,  G,  W,  K,  G,  K, BW],
        [BW,  G,  G,  K,  W,  G,  G,  G,  W,  K,  K,  K, BW],
        [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW],
    ],
    [
        [BW, BW, BW, BW, BW, BW, BW,  W, BW, BW, BW, BW, BW],
        [BW,  G,  G,  K,  S,  S,  S,  G,  G,  G,  G,  G, BW],
        [BW,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W,  G, BW],
        [BW,  G,  G,  G,  D,  G,  W,  G,  K,  G,  W,  G, BW],
        [BW,  K,  G,  G,  W,  G,  W,  G,  K,  G,  W,  G, BW],
        [BW,  W,  D,  W,  W,  G,  W,  W,  W,  G,  W,  G, BW],
        [BW,  K,  G,  G,  W,  G,  D,  G,  G,  G,  W,  G, BW],
        [BW,  G,  G,  K,  W,  G,  W,  W,  W,  W,  W,  G, BW],
        [BW,  W,  D,  W,  W,  G,  G,  G,  G,  G,  G,  G, BW],
        [BW,  G,  G,  G,  W,  W,  D,  W,  W,  W,  D,  W, BW],
        [BW,  G,  G,  K,  W,  K,  G,  G,  W,  K,  G,  K, BW],
        [BW,  G,  G,  K,  W,  G,  G,  G,  W,  K,  K,  K, BW],
        [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW],
    ]
]

for m in maps:
    for i in range(MAP_HEIGHT):
        m[i] = [f"{x:04X}" for x in m[i]]
        m[i] = ",".join(m[i])

for i in range(len(maps)):
    maps[i] = ",\n".join(maps[i])

out_path = "./resources/map.coe"

with open(out_path, "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")
    f.write(",\n\n".join(maps) + ";\n")

print(f"地图文件已生成到{out_path}")