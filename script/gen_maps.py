import numpy as np

G = 2
W = 3
BW = 5

map1f = [
    [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW],
    [BW,  G,  G,  G,  G,  G,  G,  G,  G,  G,  G,  G, BW],
    [BW,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W,  G, BW],
    [BW,  G,  G,  G,  W,  G,  W,  G,  G,  G,  W,  G, BW],
    [BW,  G,  G,  G,  W,  G,  W,  G,  G,  G,  W,  G, BW],
    [BW,  W,  W,  W,  W,  G,  W,  W,  W,  G,  W,  G, BW],
    [BW,  G,  G,  G,  W,  G,  G,  G,  G,  G,  W,  G, BW],
    [BW,  G,  G,  G,  W,  G,  W,  W,  W,  W,  W,  G, BW],
    [BW,  W,  W,  W,  W,  G,  G,  G,  G,  G,  G,  G, BW],
    [BW,  G,  G,  G,  W,  W,  G,  W,  W,  W,  W,  W, BW],
    [BW,  G,  G,  G,  W,  G,  G,  G,  W,  G,  G,  G, BW],
    [BW,  G,  G,  G,  W,  G,  G,  G,  W,  G,  G,  G, BW],
    [BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW, BW]
]
map1f = np.array(map1f, dtype=np.int16)

bts = [','.join(
    [f"{tile:04X}" for tile in row]
) for row in map1f]
data = ',\n'.join(bts)

out_path = "./resources/map.coe"

with open(out_path, "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")
    f.write(data + ";\n")

print(f"地图文件已生成到{out_path}")