from PIL import Image
import numpy as np

def split_image(image_path, size = (32, 32)) -> list[Image.Image] :
    '''
    将图片按照size切割
    '''
    image = Image.open(image_path)
    width, height = image.size
    if width % size[0]!= 0 or height % size[1]!= 0:
        raise ValueError("图片尺寸应是size的整数倍")
    images = []
    for i in range(0, height, size[1]):
        for j in range(0, width, size[0]):
            box = (j, i, j+size[0], i+size[1])
            images.append(image.crop(box))
    return images

def image2hex(image: Image.Image) -> list[str]:
    '''
    Convert image to hex. 
    Use format: Word = {
        [12] = A,
        [11:8] = R,
        [7:4] = G,
        [3:0] = B
    }
    '''
    if image.mode != "RGBA":
        image = image.convert("RGBA")
    image = np.array(image).astype(np.uint16)
    R = image[:, :, 0] >> 4
    G = image[:, :, 1] >> 4
    B = image[:, :, 2] >> 4
    A = image[:, :, 3] >> 7
    image = A << 12 | R << 8 | G << 4 | B
    return [f"{pixel:04X}" for pixel in image.flatten()]

def hex_fancy(hex: list[str]) -> str:
    hex = [','.join(hex[i:i+32]) for i in range(0, len(hex), 32)]
    hex = ',\n'.join(hex)
    return hex

def gen_vlog_params(names: list[str], addrs: list[int]) -> str:
    ret = ""
    for name, addr in zip(names, addrs):
        ret += f"parameter RS_{name} = 32'h{addr:08X};\n"
    return ret

resources_dict = {
    "white" : "/texture/white.png",
    "ground": "/texture/ground.png",
    "wall" : "/texture/wall.png",
    "door" : "/entity/door.png",
    "hero" : "/entity/hero.png",
}

def main():
    base_path = './resources'
    coe_out_path = './resources/resources.coe'
    param_out_path = './rtl/parameters/resources_params.v'
    
    names, images = [], []
    for name, path in resources_dict.items():
        splited = split_image(f"{base_path}/{path}")
        images.extend(splited)
        names.extend([f"{name}_{i}" for i in range(len(splited))])
    hexs = [image2hex(img) for img in images]
    
    addr = 0
    addrs = []
    for hex in hexs:
        addrs.append(addr)
        addr += len(hex)
        
    for name, addr in zip(names, addrs):
        print(f"{name} : 0x{addr:08X}")
    
    
    hexs_fancy = [hex_fancy(hex) for hex in hexs]
    with open(coe_out_path, 'w') as f:
        f.write(f"memory_initialization_radix=16;\nmemory_initialization_vector=\n\n")
        f.write(',\n\n'.join(hexs_fancy) + ';\n')
    print(f"COE文件已生成到{coe_out_path}")
        
    with open(param_out_path, 'w') as f:
        f.write(gen_vlog_params(names, addrs))
    print(f"参数文件已生成到{param_out_path}")
        
if __name__ == '__main__':
    main()