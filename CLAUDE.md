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

Each transition calls `WatchUi.switchToView` with a **new** `NavigationBehavior(nextPage)` — page state is held in the delegate, not globally. When adding a new stat view, update both `_numberOfViews` and the `switch` in `getView`.

**Stats module** (`source/stats/Stats.mc`) is pure functions over `Time.Moment`:

- `durationSince`, `elapsedTimeSince` — used by glance and views.
- `cigarettesNotSmoked` works in **hours**, not days (`cigarettesPerDay / 24` × duration-in-hours). This was a deliberate change in v0.4.0 for finer-grained updates; preserve hour-level math when modifying.
- `ElapsedTimeBuilder` (`stats/ElapsedTimeBuilder.mc`) converts a `Time.Duration` into the `ElapsedTime` struct that views render.
- `Milestones.mc` defines progress milestones.

**Settings** (`source/Settings.mc`) wraps `Application.Properties` for `packPrice`, `packSize`, `cigarettesPerDay`, `quitDate`, `currency`. Property keys are defined in `resources/settings/properties.xml` and surfaced to users via `resources/settings/settings.xml`. `getQuitDate()` falls back to today when the stored timestamp is `0` or in the future (handles the pre-1970 / future-date edge cases called out in CHANGELOG.md). Currency is an index into a fixed `currencySymbols` array of resource symbols (`:SignUSD`, `:SignEUR`, `:SignHUF`); add new currencies in both the array and the strings resources.

**Tests** live next to the code they cover as `*.tests.mc` files using Toybox `(:test)` modules. `source/utils/TestUtils.mc` and `source/stats/Stats.tests.mc` set up shared `today` / `quitDate` moments inside a `TestConsts` module.

## Conventions

- Per `.editorconfig`: `.mc` and `.xml` files are 2-space indent, UTF-8, LF.
- Any function/module that can be reached from the glance view must carry `(:glance)`, otherwise it will be stripped from the glance build and fail at runtime.
- Hungarian translations live in a **separate** resource root (`resources-hun/`), not as `resources/strings/strings-hun.xml`. Mirror string IDs across both.
