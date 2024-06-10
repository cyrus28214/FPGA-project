from PIL import Image
import os

def crop_image(image_path, output_dir, crop_height, crop_width):
    # 打开图像文件
    img = Image.open(image_path)
    img_width, img_height = img.size
    
    # 计算横向和纵向的切割次数
    num_crops_horizontally = img_width // crop_width
    num_crops_vertically = img_height // crop_height
    
    # 确保输出目录存在
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # 进行切割
    for i in range(num_crops_vertically):
        for j in range(num_crops_horizontally):
            left = j * crop_width
            upper = i * crop_height
            right = left + crop_width
            lower = upper + crop_height
            
            # 定义每个小图的边界框
            box = (left, upper, right, lower)
            crop = img.crop(box)
            
            # 保存每个小图到输出目录
            crop.save(os.path.join(output_dir, f"crop_{i}_{j}.png"))

if __name__ == "__main__":
    # 输入图像路径
    image_path = "./resources/entity/enemy.png"  # 替换为你的图片路径
    
    # 输出目录
    output_dir = "./temp_out"  # 替换为你的输出目录路径
    
    # 指定切割的高度和宽度
    crop_height = 128
    crop_width = 64
    
    # 调用切割函数
    crop_image(image_path, output_dir, crop_height, crop_width)
