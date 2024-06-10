from PIL import Image
import numpy as np
import json

WIDTH = 12
HEIGHT = 18

base_img = Image.open("./resources/texture/number_ground.png").convert("RGBA")

def crop_image(image_path, crop_height, crop_width):
    img = Image.open(image_path)
    img_width, img_height = img.size
    
    num_crops_horizontally = img_width // crop_width
    num_crops_vertically = img_height // crop_height
    
    images = []
    for i in range(num_crops_vertically):
        for j in range(num_crops_horizontally):
            left = j * crop_width
            upper = i * crop_height
            right = left + crop_width
            lower = upper + crop_height
            
            box = (left, upper, right, lower)
            crop = img.crop(box)
            crop = Image.alpha_composite(base_img, crop)

            images.append(crop)
    return images

def image2hex(image: Image.Image):
    if image.mode != "RGBA":
        image = image.convert("RGBA")
    image = np.array(image).astype(np.uint16)
    R = image[:, :, 0] >> 4
    G = image[:, :, 1] >> 4
    B = image[:, :, 2] >> 4
    A = image[:, :, 3] >> 7
    image = A<<12 | R<<8 | G<<4 | B
    return [f"{pixel:04X}" for pixel in image.flatten()]

def hex_fancy(hex: list[str]) -> str:
    hex = [','.join(hex[i:i+WIDTH]) for i in range(0, len(hex), WIDTH)]
    hex = ',\n'.join(hex)
    return hex

def gen_vlog_params(names, addrs):
    ret = ""
    for name, addr in zip(names, addrs):
        ret += f"parameter RS_{name} = {addr}; \n"
    return ret

def main():
    image_path = "./resources/texture/number.png"
    output_dir = "./resources"
    script_dir = "./script"

    coe_out_path = output_dir + "/number.coe"
    # json_out_path = script_dir + "/number.json"
    # param_out_path = './rtl/parameters/number_params.v'

    crop_height = HEIGHT
    crop_width = WIDTH
    
    images = crop_image(image_path, crop_height, crop_width)

    hexs = [image2hex(img) for img in images]

    names = []
    for i in range(10):
        names.append(f"number_{i}")
    addr = 0
    addrs = []
    hexs_fancy = [hex_fancy(hex) for hex in hexs]
    for hex in hexs:
        addrs.append(addr)
        addr += len(hex)

    # data_json = [
    #     {"name": name, "id": i, "addr": addr}
    #     for i, (name, addr) in enumerate(zip(names, addrs))
    # ]

    # with open(json_out_path, "w") as f:
    #     json.dump(data_json, f, indent = 4)
    with open(coe_out_path, 'w') as f:
        f.write(f"memory_initialization_radix=16;\nmemory_initialization_vector=\n\n")
        f.write(',\n\n'.join(hexs_fancy) + ';\n')
    # with open(param_out_path, 'w') as f:
    #     f.write(gen_vlog_params(names, addrs))


    

if __name__ == "__main__":
    main()