import json
import pandas as pd
import numpy as np

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

out_path = "./resources/map.coe"

MAP_WIDTH = 13
MAP_HEIGHT = 13

sheets = ["1f", "2f"]
sheets = [pd.read_excel(
    f"./resources/map_editor.xlsx",
    sheet_name=s,
    header=None,
    nrows=MAP_HEIGHT,
    usecols=range(MAP_WIDTH)) 
    for s in sheets]

maps = np.array(sheets)

stream = ','.join([f"{tiles[x]:04X}" for x in maps.flatten()])

with open(out_path, "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")
    f.write(stream + ";\n")

print(f"地图文件已生成到{out_path}")