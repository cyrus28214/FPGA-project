.DEFUALT_GOAL := all

.gen_tiles:
	python ./script/gen_tiles.py

.gen_maps:
	python ./script/gen_maps.py

all: .gen_tiles .gen_maps