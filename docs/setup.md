# Dev environment setup

One-time setup for building and testing this widget from the CLI on macOS.
After this, `make build` and `make test` are the daily commands.

> This guide assumes Apple Silicon. The paths under `/opt/homebrew` will be `/usr/local` on Intel Macs.

## Prerequisites

- macOS 11+
- [Homebrew](https://brew.sh)
- A free Garmin developer account (https://developer.garmin.com — needed by the SDK Manager to download device packages)

## 1. Install the Connect IQ SDK and the SDK Manager

```bash
brew install --cask connectiq            # SDK runtime: monkeyc, monkeydo, simulator
brew install --cask connectiq-sdk-manager # GUI for downloading device packages
```

The `connectiq` cask drops the binaries into `/opt/homebrew/bin`:

```
$ which monkeyc monkeydo
/opt/homebrew/bin/monkeyc
/opt/homebrew/bin/monkeydo
```

## 2. Install a JDK

`monkeyc` is a Java program and needs a JDK on `PATH`. The Homebrew `openjdk` formula avoids the `sudo`-required `temurin` cask:

```bash
brew install openjdk
```

Homebrew's `openjdk` is keg-only, so it does **not** end up on `PATH` automatically. The `Makefile` prepends it for its own recipes, but a plain shell won't see it — `monkeydo out/foo.prg fenix6` will fail with *"Unable to locate a Java Runtime"* until you fix `PATH`.

Append to `~/.zshrc` so every shell picks it up (one-time, recommended):

```bash
echo '' >> ~/.zshrc
echo '# Homebrew openjdk is keg-only; needed by monkeyc/monkeydo (Garmin Connect IQ)' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
```

Then `source ~/.zshrc` (or open a new terminal). Verify with `java --version` — should print `openjdk 25.x`.

## 3. Generate a developer signing key

Every Connect IQ build is signed with a private key. Generate yours once and reuse it forever — **back it up to a password manager**, you'll need the same key to publish updates to the Connect IQ Store.

```bash
mkdir -p ~/.garmin
openssl genrsa -out ~/.garmin/developer_key.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER \
  -in ~/.garmin/developer_key.pem \
  -out ~/.garmin/developer_key.der -nocrypt
chmod 600 ~/.garmin/developer_key.pem ~/.garmin/developer_key.der
```

`monkeyc` reads the DER form; the PEM is kept around in case you ever need to regenerate the DER or import the key into another tool.

To put the key somewhere else, override `DEVELOPER_KEY` when running `make`:

```bash
make test DEVELOPER_KEY=/path/to/your/key.der
```

## 4. Install device packages via the SDK Manager

```bash
open -a SdkManager
```

In the SDK Manager:

1. Sign in with your Garmin developer account.
2. **Devices** tab → install **fenix6** (the canonical test target — API 3.4, which matches `manifest.xml`'s `minApiLevel`).
3. Optional but recommended: install **fenix7** too, since the manifest targets both lineups.

Device packages land in `~/Library/Application Support/Garmin/ConnectIQ/Devices/<deviceId>/`. The `Makefile`'s `check-deps` target reports a clear error if the package for the requested `DEVICE` isn't there.

You do **not** need to install a separate "SDK" inside the SDK Manager — the binaries from the `connectiq` cask are self-contained. The Manager is only used here for device packages.

## 5. Verify

```bash
make check-deps   # passes silently when everything is in place
make build        # compiles for fenix6 by default
make run          # launch the widget in the simulator for manual testing
make test         # runs the (:test) suite in the simulator
```

A clean `make test` ends with a line like `PASSED (passed=25, failed=0, errors=0)` and exits 0.

`make run` leaves the simulator window open until you close it. Use the simulator's **Settings → Edit Persistent Storage** to change pack price / quit date / etc. without rebuilding, and the **Device** menu to switch form factor mid-session.

If `make test` reports `Unable to connect to simulator`, the simulator isn't running yet — the `Makefile` tries to start it but sometimes needs more time on the first invocation. Re-run, or `open -a ConnectIQ` first.

## Targeting a different device

```bash
make test DEVICE=fenix7
```

The device package for the target must be installed in the SDK Manager first.

## Recovering from a stuck simulator

`monkeydo` connects to the running simulator process. If a prior test run left it in a weird state (window hangs, `monkeydo` doesn't return), reset:

```bash
pkill -f ConnectIQ.app
pkill -f MonkeyDoDeux
open -a ConnectIQ
```

Then retry `make test`.

## Notes & quirks

- `monkeydo` returns a non-zero exit code even on a successful `PASSED` run. The Makefile's `test` target compensates by grepping `out/test.log` for the summary line.
- The build emits `Invalid device id` warnings for every product in `manifest.xml` whose device package isn't installed locally. These are harmless — the build succeeds for the device you asked for. Install the missing packages via the SDK Manager to silence them.
- Two pre-existing type-checker warnings (`Cannot determine if container access is using container type`) show up on every build in `Settings.mc` and `GlanceView.mc`. Known, not a regression.
