# Smoke Free Companion — build/test runner for the Connect IQ CLI.
# See docs/setup.md for one-time environment setup.

# Override on the command line, e.g. `make test DEVICE=fenix7`
DEVICE       ?= fenix6
DEVELOPER_KEY ?= $(HOME)/.garmin/developer_key.der
OUT_DIR      ?= out
JUNGLE       ?= monkey.jungle

# monkeyc requires a JDK on PATH. Homebrew's openjdk is keg-only, so prepend
# it here rather than rely on the user's shell config. brew --prefix resolves
# correctly on both Apple Silicon (/opt/homebrew) and Intel (/usr/local).
JDK_BIN      := $(shell brew --prefix openjdk 2>/dev/null)/bin
# Honor whichever SDK the user has marked active via the SDK Manager. The
# brew symlinks always point at the latest installed cask, which may not
# match the chosen SDK. current-sdk.cfg already includes a trailing slash.
SDK_DIR      := $(shell cat "$(HOME)/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg" 2>/dev/null)
SDK_BIN      := $(SDK_DIR)bin
SHELL        := /bin/zsh
export PATH  := $(SDK_BIN):$(JDK_BIN):$(PATH)

# Bundle name — drives the PRG filename, the sidecar JSON, and the
# in-simulator settings destination. manifest.xml's name attribute is a
# @Strings.* resource reference, not a literal, so it's set here directly.
APP_NAME     := SmokeFreeCompanion
APP_PRG      := $(OUT_DIR)/$(APP_NAME).prg
APP_SETTINGS := $(OUT_DIR)/$(APP_NAME)-settings.json
# The simulator's App Settings Editor reads the sidecar from a fixed path
# inside the simulator's vfs: GARMIN/Settings/<APP>-settings.json. Without
# this, the editor reports "No settings file found for this app."
SETTINGS_DEST := GARMIN/Settings/$(shell echo $(APP_NAME) | tr '[:lower:]' '[:upper:]')-settings.json
TEST_PRG     := $(OUT_DIR)/$(APP_NAME)-tests.prg

# monkeyc builds in ~2s, so always rebuild rather than track a wildcard of
# every .mc/resource file. Stale .prgs would be a much worse failure mode
# than the extra two seconds.
.PHONY: all build run test clean check-deps simulator

all: build

# Compile the widget for $(DEVICE).
build: check-deps | $(OUT_DIR)
	monkeyc -f $(JUNGLE) -d $(DEVICE) -y "$(DEVELOPER_KEY)" -o $(APP_PRG) -w

# Launch the widget in the simulator for manual testing.
run: build simulator
	monkeydo $(APP_PRG) $(DEVICE) -a $(APP_SETTINGS):$(SETTINGS_DEST)

# Compile with unit tests enabled, then run them in the simulator.
# monkeydo exits non-zero on a clean PASSED run, so we grep the
# output for the summary line and exit on that instead.
test: check-deps simulator | $(OUT_DIR)
	monkeyc -f $(JUNGLE) -d $(DEVICE) -y "$(DEVELOPER_KEY)" -o $(TEST_PRG) -t -w
	@set -o pipefail; \
	monkeydo $(TEST_PRG) $(DEVICE) -t 2>&1 | tee $(OUT_DIR)/test.log; \
	grep -qE '^PASSED' $(OUT_DIR)/test.log

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# Start the simulator if it isn't already up, then wait until it's
# accepting connections on its control port. Idempotent.
# monkeydo silently fails with "Unable to connect" if it tries to
# attach before the simulator has finished booting (~5s on cold start).
# Launch via the active SDK's bundle so we don't get whichever copy
# macOS has registered for `open -a ConnectIQ`.
SIMULATOR_PORT := 1234
simulator:
	@pgrep -f ConnectIQ.app > /dev/null || open -a "$(SDK_BIN)/ConnectIQ.app"
	@for i in $$(seq 1 30); do \
		nc -z localhost $(SIMULATOR_PORT) 2>/dev/null && exit 0; \
		sleep 1; \
	done; \
	echo "Simulator did not become ready on port $(SIMULATOR_PORT)"; exit 1

clean:
	rm -rf $(OUT_DIR)

# Fail fast if the toolchain isn't ready.
check-deps:
	@command -v monkeyc > /dev/null || { echo "monkeyc not found — run: brew install --cask connectiq"; exit 1; }
	@command -v monkeydo > /dev/null || { echo "monkeydo not found — run: brew install --cask connectiq"; exit 1; }
	@test -x "$(JDK_BIN)/java" || { echo "JDK not found at $(JDK_BIN) — run: brew install openjdk"; exit 1; }
	@test -f "$(DEVELOPER_KEY)" || { echo "Developer key not found at $(DEVELOPER_KEY) — see docs/setup.md"; exit 1; }
	@test -d "$(HOME)/Library/Application Support/Garmin/ConnectIQ/Devices/$(DEVICE)" \
		|| { echo "Device package $(DEVICE) not installed — open /Applications/SdkManager.app"; exit 1; }
