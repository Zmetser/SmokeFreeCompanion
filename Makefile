# Smoke Free Companion — build/test runner for the Connect IQ CLI.
# See docs/setup.md for one-time environment setup.

# Override on the command line, e.g. `make test DEVICE=fenix7`
DEVICE       ?= fenix6
DEVELOPER_KEY ?= $(HOME)/.garmin/developer_key.der
OUT_DIR      ?= out
JUNGLE       ?= monkey.jungle

# monkeyc requires a JDK on PATH. Homebrew's openjdk is keg-only, so prepend
# it here rather than rely on the user's shell config.
JDK_BIN       := /opt/homebrew/opt/openjdk/bin
SHELL         := /bin/zsh
export PATH   := $(JDK_BIN):$(PATH)

APP_PRG      := $(OUT_DIR)/SmokeFreeCompanion.prg
TEST_PRG     := $(OUT_DIR)/SmokeFreeCompanion-tests.prg

.PHONY: all build test clean check-deps simulator

all: build

# Compile the widget for $(DEVICE).
build: check-deps $(APP_PRG)

$(APP_PRG): | $(OUT_DIR)
	monkeyc -f $(JUNGLE) -d $(DEVICE) -y $(DEVELOPER_KEY) -o $@ -w

# Compile with unit tests enabled, then run them in the simulator.
# The simulator must already be running for monkeydo to attach.
# monkeydo exits non-zero on a clean PASSED run, so we grep the
# output for the summary line and exit on that instead.
test: check-deps $(TEST_PRG) simulator
	@set -o pipefail; \
	monkeydo $(TEST_PRG) $(DEVICE) -t 2>&1 | tee $(OUT_DIR)/test.log; \
	grep -qE '^PASSED' $(OUT_DIR)/test.log

$(TEST_PRG): | $(OUT_DIR)
	monkeyc -f $(JUNGLE) -d $(DEVICE) -y $(DEVELOPER_KEY) -o $@ -t -w

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# Start the simulator if it isn't already up. Idempotent.
simulator:
	@pgrep -f ConnectIQ.app > /dev/null || (open -a ConnectIQ && sleep 2)

clean:
	rm -rf $(OUT_DIR)

# Fail fast if the toolchain isn't ready.
check-deps:
	@command -v monkeyc > /dev/null || { echo "monkeyc not found — run: brew install --cask connectiq"; exit 1; }
	@command -v monkeydo > /dev/null || { echo "monkeydo not found — run: brew install --cask connectiq"; exit 1; }
	@test -x $(JDK_BIN)/java || { echo "JDK not found at $(JDK_BIN) — run: brew install openjdk"; exit 1; }
	@test -f $(DEVELOPER_KEY) || { echo "Developer key not found at $(DEVELOPER_KEY) — see docs/setup.md"; exit 1; }
	@test -d "$(HOME)/Library/Application Support/Garmin/ConnectIQ/Devices/$(DEVICE)" \
		|| { echo "Device package $(DEVICE) not installed — open /Applications/SdkManager.app"; exit 1; }
