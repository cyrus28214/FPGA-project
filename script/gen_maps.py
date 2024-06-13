import json
import pandas as pd
import numpy as np

coe_out_path = "./resources/map.coe"
param_out_path = "./rtl/floor_pos.v"

MAP_WIDTH = 13
MAP_HEIGHT = 13
sheets = ["1f", "2f", "3f", "4f", "End"]

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

def name_to_id(name):
    if (name == "pos_0" or name == "pos_1"):
        return tiles["ground_0"]
    return tiles[name]

def get_pos(floor):
    init_x, init_y = 0, 0
    back_x, back_y = 0, 0
    for i in range(MAP_WIDTH):
        for j in range(MAP_HEIGHT):
            if floor[i][j] == "pos_0":
                init_x = i
                init_y = j
            elif floor[i][j] == "pos_1":
                back_x = i
                back_y = j
    return init_x, init_y, back_x, back_y

sheets = [pd.read_excel(
    f"./resources/map_editor.xlsx",
    sheet_name=s,
    header=None,
    nrows=MAP_HEIGHT,
    usecols=range(MAP_WIDTH)) 
    for s in sheets]

with open(param_out_path, "w") as f:
    f.write('''module floor_pos(
    input [15:0] floor,
    output reg [3:0] down_x,
    output reg [3:0] down_y,
    output reg [3:0] up_x,
    output reg [3:0] up_y
);

always @(*) begin
    case(floor)
''')
    for i in range(len(sheets)):
        if i == 0:
            prev_floor = (0, 0, 0, 0)
        else:
            prev_floor = get_pos(sheets[i-1])
        if i != len(sheets)-1:
            next_floor = get_pos(sheets[i+1])
        else:
            next_floor = (0, 0, 0, 0)
        down_x, down_y = prev_floor[2], prev_floor[3]
        up_x, up_y = next_floor[0], next_floor[1]
        f.write(f"        {i}: begin\n")
        f.write(f"            down_x = {down_x};\n")
        f.write(f"            down_y = {down_y};\n")
        f.write(f"            up_x = {up_x};\n")
        f.write(f"            up_y = {up_y};\n")
        f.write(f"        end\n")
    f.write("        default: begin\n")
    f.write("            down_x = 0;\n")
    f.write("            down_y = 0;\n")
    f.write("            up_x = 0;\n")
    f.write("            up_y = 0;\n")
    f.write("        end\n")
    f.write("    endcase\n")
    f.write("end\n")
    f.write("endmodule\n")
        
print(f"地图参数文件已生成到{param_out_path}")
    

stream = ','.join([f"{name_to_id(x):04X}" for x in np.array(sheets).flatten()])

with open(coe_out_path, "w") as f:
    f.write("memory_initialization_radix=16;\n")
    f.write("memory_initialization_vector=\n")
    f.write(stream + ";\n")
print(f"地图COE文件已生成到{coe_out_path}")