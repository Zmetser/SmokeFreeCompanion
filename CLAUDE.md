# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Smoke Free Companion is a Garmin Connect IQ **widget** (see `manifest.xml`) written in Monkey C. It shows users how long they've been smoke-free, cigarettes not smoked, and money saved since their configured quit date.

- `minApiLevel`: 3.4.0
- Supported devices: fenix6 and fenix7 lineups only (downgraded from a broader set in v0.4.0 — see CHANGELOG.md)
- Languages: English (`resources/`) and Hungarian (`resources-hun/`)

## Build / Run / Test

Primary workflow is the **Makefile** (see `docs/setup.md` for one-time install):

```bash
make build              # compile for fenix6
make test               # build with --unit-test + run in simulator
make test DEVICE=fenix7 # other devices (package must be installed)
make clean
```

`make test` succeeds (exit 0) when monkeydo prints `PASSED (passed=N, failed=0, errors=0)`. The simulator must be running; the target tries to start it but sometimes needs `open -a ConnectIQ` first on a cold boot.

VS Code is still available — `.vscode/launch.json` defines **Run App** and **Run Tests** configurations against the device chosen via `GetTargetDevice` — but the CLI is the source of truth.

Single-test runs are not supported by either path; `monkeydo -t` runs every `(:test)`-annotated function. Narrow scope by temporarily renaming functions.

`monkey.jungle` simply points at `manifest.xml`; product/permission/language edits are done through the **Monkey C: Edit Application / Edit Products / Edit Permissions / Edit Languages** VS Code commands rather than by hand-editing `manifest.xml` (which is marked generated).

## Architecture

Entry point `source/App.mc` (`class App extends Application.AppBase`):

- `getInitialView()` returns `CigarettesNotSmokedView` paired with a `NavigationBehavior(0)` delegate.
- `getGlanceView()` returns `GlanceView` — the compact widget preview. Code reachable from the glance must be annotated `(:glance)` (see `App`, `Settings.getQuitDate`, `Stats.durationSince`, `Stats.elapsedTimeSince`).

**View paging.** `source/view/NavigationBehavior.mc` is a `BehaviorDelegate` that cycles through 3 stat views via `onNextPage` / `onPreviousPage`, hard-coded in `getView(page)`:

0. `CigarettesNotSmokedView`
1. `MoneyNotSpentView`
2. `CleanSinceView`

Each transition calls `WatchUi.switchToView` with a **new** `NavigationBehavior(nextPage)` — page state is held in the delegate, not globally. `NavigationBehavior.initialize` also writes the current page to `Application.Storage["lastPage"]`, and `App.getInitialView()` reads it back on launch so the widget reopens to where the user left off. When adding a new stat view, update both `_numberOfViews` and the `switch` in `getView`; the `default` case keeps stale stored values safe.

**Stats module** (`source/stats/Stats.mc`) is pure functions over `Time.Moment`:

- `durationSince`, `elapsedTimeSince` — used by glance and views.
- `cigarettesNotSmoked` works in **hours**, not days (`cigarettesPerDay / 24` × duration-in-hours). This was a deliberate change in v0.4.0 for finer-grained updates; preserve hour-level math when modifying.
- `ElapsedTimeBuilder` (`stats/ElapsedTimeBuilder.mc`) converts a `Time.Duration` into the `ElapsedTime` struct that views render.
- `Milestones.mc` defines progress milestones.

**Settings** (`source/Settings.mc`) wraps `Application.Properties` for `packPrice`, `packSize`, `cigarettesPerDay`, `quitDate`, `currency`, `colorSpace`. Every getter null-guards the underlying property read with a sensible default. Property keys are defined in `resources/settings/properties.xml` and surfaced to users via `resources/settings/settings.xml`. `getQuitDate()` falls back to today when the stored timestamp is `0` or in the future (handles the pre-1970 / future-date edge cases called out in CHANGELOG.md). `getCurrencyConfig()` returns a dict `{:symbol, :suffixed, :priceFormat, :defaultPrice, :pickerMode}` for the active currency — views and the on-watch price picker consume this, not the raw index. `:pickerMode` is one of `:narrow` (USD/EUR: 2 int + "." + 1 decimal, max 99.9) or `:hundreds` (HUF: 2 int + literal "00.0", max 9900 step 100). To add a currency: append an entry to `getCurrencyConfig`'s `configs` table (including `:defaultPrice` and `:pickerMode`), add a string resource for the symbol, and add a `listEntry` in `settings.xml`.

**Settings reactivity.** `App.onSettingsChanged` calls `WatchUi.requestUpdate()` so Connect-Mobile-pushed setting changes are visible without relaunch. This means **settings-dependent computation belongs in `onUpdate`, not `onShow`** — `onShow` is for one-time resource loads (icons, static strings). Each stat view follows this pattern: resources in `onShow`, settings reads + title computation in `onUpdate`. Note: `onSettingsChanged` does **not** fire for in-app writes via `Properties.setValue` (only for Connect Mobile / Garmin Express pushes), so the on-watch editors trigger `WatchUi.requestUpdate()` themselves on back-out.

**On-watch editing.** Long-press UP (the MENU behavior) on any stat view opens `SettingsMenu` (`source/settings/SettingsMenu.mc`) via `NavigationBehavior.onMenu`. Editors live in the same folder: `CurrencyMenu` for the list pick, `Pickers.mc` for the three `WatchUi.Picker`s (whole-number, currency-aware price, date). The price picker layout branches on `currencyConfig[:pickerMode]`. Setters in `Settings.mc` write through `Properties.setValue` via the same `PropertyReader` DI seam the getters use, so unit tests round-trip without hitting real Properties. Changing currency in `CurrencyMenu` also resets `packPrice` to the new currency's `:defaultPrice` so the user isn't left with a price at the wrong scale.

**Upgrade compatibility — load-bearing.** The current Store release is **v0.4.0**; existing users have real configured values in `Application.Properties` on their devices. Property **keys** and **types** in `resources/settings/properties.xml` (and the corresponding casts in `Settings.mc`) are an external contract — changing or removing any of `quitDate` (number), `currency` (number), `packPrice` (double), `cigarettesPerDay` (number), `packSize` (number) silently wipes the value for every existing user on update. If a key or type must change, ship an explicit migration that reads the old key and writes the new one before the first getter is called. The regression guard is `SettingsTests.upgradeFromV040_preservesAllUserSettings` in `source/Settings.tests.mc` — keep it green.

Note: v0.4.0's `Settings.mc` had no null-guards and stricter `as Number` casts; the current null-guard-everything pattern is strictly more permissive, so any value a v0.4.0 user could have stored is readable by today's code.

**Tests** live next to the code they cover as `*.tests.mc` files using Toybox `(:test)` modules. `source/utils/TestUtils.mc` and `source/stats/Stats.tests.mc` set up shared `today` / `quitDate` moments inside a `TestConsts` module.

## Conventions

- Per `.editorconfig`: `.mc` and `.xml` files are 2-space indent, UTF-8, LF.
- Any function/module that can be reached from the glance view must carry `(:glance)`, otherwise it will be stripped from the glance build and fail at runtime.
- Hungarian translations live in a **separate** resource root (`resources-hun/`), not as `resources/strings/strings-hun.xml`. Mirror string IDs across both.
