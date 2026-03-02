.PHONY: build clean

build:
	mkdir -p dist
	cp index.html chat.html dist/

clean:
	rm -rf dist
