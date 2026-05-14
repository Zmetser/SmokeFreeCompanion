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
SHELL        := /bin/zsh
export PATH  := $(JDK_BIN):$(PATH)

APP_PRG      := $(OUT_DIR)/SmokeFreeCompanion.prg
TEST_PRG     := $(OUT_DIR)/SmokeFreeCompanion-tests.prg

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
	monkeydo $(APP_PRG) $(DEVICE)

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
SIMULATOR_PORT := 1234
simulator:
	@pgrep -f ConnectIQ.app > /dev/null || open -a ConnectIQ
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
