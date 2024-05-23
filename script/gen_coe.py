from PIL import Image
import numpy as np

TARGET_WIDTH, TARGET_HEIGHT = 640, 480

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
    image = np.array(image)
    R = image[:, :, 0] >> 4
    G = image[:, :, 1] >> 4
    B = image[:, :, 2] >> 4
    A = image[:, :, 3] >> 7
    image = A << 12 | R << 8 | G << 4 | B
    return [f"{pixel:04X}" for pixel in image.flatten()]

reousrces_dict = {
    "hero" : "/entity/hero.png"
}

def main():
    base_path = './resources'
    coe_out_path = './resources/resources.coe'
    param_out_path = './rtl/resources_param.v'
    
    names, images = [], []
    for name, path in reousrces_dict.items():
        images.extend(split_image(f"{base_path}/{path}"))
        names.extend([f"{name}[{i}]" for i in range(len(images))])
    hexs = [image2hex(img) for img in images]
    
    addr = 0
    addrs = []
    for hex in hexs:
        addrs.append(addr)
        addr += len(hex)
        
    for name, addr in zip(names, addrs):
        print(f"{name} : 0x{addr:08X}")
    
    with open(coe_out_path, 'w') as f:
        f.write(f"memory_initialization_radix=16;\nmemory_initialization_vector=\n\n")
        entries = []
        for name, addr, hex in zip(names, addrs, hexs):
            entries.append(
                f"; {name} : 0x{addr:08X}\n{','.join(hex)}"
            )
        f.write(",\n\n".join(entries) + ';\n')
        
    

if __name__ == '__main__':
    main()