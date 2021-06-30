
TOOL_NAME = axx
VERSION = 0.1.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
TAR_FILENAME = $(VERSION).tar.gz

.PHONY: build

install: build
	install -d "$(PREFIX)/bin"
	install -C -m 755 $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift build --disable-sandbox -c release

uninstall:
	rm -f $(INSTALL_PATH)

xcode:
	swift package generate-xcodeproj

zip: build
	zip -D $(TOOL_NAME).macos.zip $(BUILD_PATH)

get_sha:
	curl -OLs https://github.com/eneko/$(TOOL_NAME)/archive/$(VERSION).tar.gz
	shasum -a 256 $(TAR_FILENAME)
	rm $(TAR_FILENAME)

