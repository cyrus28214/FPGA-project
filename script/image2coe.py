from PIL import Image
import numpy as np
import sys

TARGET_WIDTH, TARGET_HEIGHT = 640, 480

def image2hex(img_path):
    '''
    Convert image to bytes. 
    Use format: Word = {R[11:8], G[7:4], B[3:0]}
    '''
    image = Image.open(img_path).resize((TARGET_WIDTH, TARGET_HEIGHT))
    image = np.array(image, dtype=np.uint16)
    # print(image.shape) # (480, 640, RGB)
    R = image[:, :, 0] >> 4
    G = image[:, :, 1] >> 4
    B = image[:, :, 2] >> 4
    image = R << 8 | G << 4 | B
    return ",".join([f"{pixel:03X}" for pixel in image.flatten()])

def write_coe(coe_path, hex_str):
    with open(coe_path, 'w') as f:
        f.write(f"; Width: {TARGET_WIDTH}, Height: {TARGET_HEIGHT}\n")
        f.write(f"memory_initialization_radix=16;\nmemory_initialization_vector=\n{hex_str};\n")

def main():
    file_path = sys.argv[1]
    hex_str = image2hex(file_path)
    write_coe(f"{file_path}.coe", hex_str)
    
if __name__ == '__main__':
    main()
    