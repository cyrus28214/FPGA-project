import numpy as np

map1f = [
    [0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0],
    [1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1],
    [0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1],
    [0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
    [1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0],
    [0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1],
    [1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0],
    [0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0]
]
map1f = np.array(map1f, dtype=np.int16)

bts = [f"{i:04X}" for i in map1f.flatten()]

with open("./resources/map.coe", "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")
    f.write(",".join(bts) + ";\n")