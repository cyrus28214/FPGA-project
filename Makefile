.DEFUALT_GOAL := all

.gen_tiles:
	python ./script/gen_tiles.py

ll: .gen_tiles