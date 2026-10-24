SRC_DIR := src
OUT_DIR := out
SOURCES := $(wildcard $(SRC_DIR)/*.md)
OUTPUTS := $(patsubst $(SRC_DIR)/%.md,$(OUT_DIR)/%.html,$(SOURCES))

.PHONY: all deps build test check ci clean

all: ci

deps: node_modules

node_modules: package-lock.json
	npm ci
	@touch node_modules

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

build: $(OUTPUTS)

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md package-lock.json | $(OUT_DIR) node_modules
	npm run --silent build -- $< $@

test: build
	npm test --silent

check:
	npm ls --all

ci: clean deps check test

clean:
	rm -rf $(OUT_DIR) *.tgz
