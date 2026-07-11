.PHONY: pdf png clean

pdf:
	python3 build.py

png:
	python3 build.py --png

clean:
	rm -rf out
