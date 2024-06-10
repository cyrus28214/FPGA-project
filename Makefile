.DEFUALT_GOAL := all

.gen_tiles:
	python ./script/gen_tiles.py

.gen_maps: .gen_tiles
	python ./script/gen_maps.py

.gen_bg:
	python ./script/gen_bg.py

.gen_nums:
	python ./script/gen_nums.py

all: .gen_maps .gen_bg .gen_nums