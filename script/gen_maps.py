MAP_WIDTH = 13
MAP_HEIGHT = 13

G = 2
W = 3
BW = 5
D = 6

maps = [
    [
        [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW],
        [BW,  G,  G,  G,  G,  G,  G,  G,  G,  G,  G,  G, BW],
        [BW,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W,  G, BW],
        [BW,  G,  G,  G,  D,  G,  W,  G,  G,  G,  W,  G, BW],
        [BW,  G,  G,  G,  W,  G,  W,  G,  G,  G,  W,  G, BW],
        [BW,  W,  D,  W,  W,  G,  W,  W,  W,  G,  W,  G, BW],
        [BW,  G,  G,  G,  W,  G,  D,  G,  G,  G,  W,  G, BW],
        [BW,  G,  G,  G,  W,  G,  W,  W,  W,  W,  W,  G, BW],
        [BW,  W,  D,  W,  W,  G,  G,  G,  G,  G,  G,  G, BW],
        [BW,  G,  G,  G,  W,  W,  D,  W,  W,  W,  D,  W, BW],
        [BW,  G,  G,  G,  W,  G,  G,  G,  W,  G,  G,  G, BW],
        [BW,  G,  G,  G,  W,  G,  G,  G,  W,  G,  G,  G, BW],
        [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW],
    ]
]

align_size = 256

for m in maps:
    for i in range(MAP_HEIGHT):
        m[i] = [f"{x:04X}" for x in m[i]]
        m[i] = ",".join(m[i])
    padding = ",".join([f"{0:04X}"] * (align_size - len(m[i])))
    m.append(padding)

for i in range(len(maps)):
    maps[i] = ",\n".join(maps[i])

out_path = "./resources/map.coe"

with open(out_path, "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")
    f.write(",\n\n".join(maps) + ";\n")

print(f"地图文件已生成到{out_path}")