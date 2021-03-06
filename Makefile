.DEFAULT_GOAL := dev

BUILD_TAGS_PRODUCTION := 'production'
BUILD_TAGS_DEVELOPMENT := 'development unittest'

VERSION := $(shell git describe --tags --abbrev=0)
REVISION := $(shell git rev-parse --short HEAD)
BUILDDATE := $(shell date '+%Y/%m/%d %H:%M:%S %Z')

LDFLAGS_VERSION := -X \"main.version=$(VERSION)\"
LDFLAGS_REVISION := -X \"main.revision=$(REVISION)\"
LDFLAGS_BUILDDATE := -X \"main.buildDate=$(BUILDDATE)\"
LDFLAGS_PROD := -s -w

LDFLAGS := "$(LDFLAGS_VERSION) $(LDFLAGS_REVISION) $(LDFLAGS_BUILDDATE) $(LDFLAGS_OPT)"

build-base:
	cd pkg/tglo_core; \
	cd template; \
	go build; \
	cd ..; \
	cd time_util; \
	go build; \
	cd ..; \
	go build; \
	cd ../..; \
	cd cli; \
	go build -o $(BIN_NAME) -tags '$(BUILD_TAGS)' -ldflags=$(LDFLAGS); \
	cd ..

dev:
	$(MAKE) build-base BUILD_TAGS=$(BUILD_TAGS_DEVELOPMENT) BIN_NAME=../tglo

prod:
	$(MAKE) build-base BUILD_TAGS=$(BUILD_TAGS_PRODUCTION) LDFLAGS_OPT=$(LDFLAGS_PROD) GOOS=linux GOARCH=amd64 BIN_NAME=../bin/linux/tglo
	$(MAKE) build-base BUILD_TAGS=$(BUILD_TAGS_PRODUCTION) LDFLAGS_OPT=$(LDFLAGS_PROD) GOOS=windows GOARCH=amd64 BIN_NAME=../bin/windows/tglo.exe
	$(MAKE) build-base BUILD_TAGS=$(BUILD_TAGS_PRODUCTION) LDFLAGS_OPT=$(LDFLAGS_PROD) GOOS=darwin GOARCH=amd64 BIN_NAME=../bin/osx/tglo
	zip -r tglo.$(VERSION).$(REVISION).zip bin/