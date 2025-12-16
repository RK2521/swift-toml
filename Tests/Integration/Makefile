.PHONY: all build test test-decoder test-encoder clean

GO ?= go
TOML_TEST := $(GO) run github.com/toml-lang/toml-test/cmd/toml-test@latest
DECODER := .build/debug/toml-decoder
ENCODER := .build/debug/toml-encoder

all: test

build: $(DECODER) $(ENCODER)

$(DECODER) $(ENCODER): Sources/**/*.swift Package.swift ../..
	swift build

test: test-decoder test-encoder

test-decoder: $(DECODER)
	$(TOML_TEST) $(DECODER)

test-encoder: $(ENCODER)
	$(TOML_TEST) -encoder $(ENCODER)

clean:
	swift package clean
