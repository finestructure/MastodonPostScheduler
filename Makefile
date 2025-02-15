.DEFAULT_GOAL := build

clean:
	swift package clean

force-clean:
	rm -rf .build

build:
	xcrun swift build

build-release:
	xcrun swift build -c release --disable-sandbox

install: build-release
	install .build/release/mastodon-post-scheduler /usr/local/bin/
