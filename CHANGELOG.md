# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- New **Milestones** page as the widget's landing view: shows a circular progress arc with an `elapsed / target` fraction (e.g. `23h / 48h`, `60d / 12w`, `260d / 1y`) toward the next NHS milestone.
- Each of the 6 NHS milestone bands (24h, 48h, 72h, weeks, months, 1y+) carries a paraphrased physiological description; repeat visits to the same band swap in one of two band-specific motivational lines so the page rewards return visits.
- Hungarian translations for all new milestone copy.

### Changed

- Milestone set rebalanced to a curated 10-entry list (`24h, 48h, 72h, 1w, 2w, 4w, 12w, 6mo, 9mo, 1y`) replacing the previous 31-entry array.

## [0.5.0] - 2026-05-23

### Added

- The widget now remembers the last-viewed stat page and reopens to it on next launch.
- All five settings (quit date, cigarettes per day, currency, pack price, pack size) can now be edited directly on the watch: long-press UP on any stat view to open the on-watch settings menu.
- Picking a different currency now resets the pack price to a sensible default for that currency (USD/EUR: 9.0, HUF: 2100), so existing values aren't left at a nonsensical scale.

### Changed

- Settings edits (quit date, pack price, cigarettes per day, currency, etc.) now take effect immediately without needing to relaunch the widget.

## [0.4.1] - 2026-05-16

### Changed

- Code quality: null-guarded all `Settings` property reads, removed the dead `Settings.tz` constant, moved `ceil` to `Math.ceil`, injected `today` into `Milestones` functions to remove internal clock reads, and centralised currency layout behind `Settings.getCurrencyConfig()`.

### Fixed

- Elapsed-time display no longer drifts by ~5 days per year past your 1-year anniversary (was showing e.g. `2y 0m 10d` instead of `2y 0m 0d`).
- Cigarettes-not-smoked count now updates continuously within each hour, instead of staying at zero until a full hour elapses.
- Milestone progress bar no longer overflows past the screen edge for users beyond the last milestone (50 years).
- Glance view no longer crashes on launch (regression caught during release prep — `getColorSpace` was missing the `(:glance)` annotation and got stripped from the glance build).

## [0.4.0]

### Added

- New screen to display quit date.

### Changed

- Downgrade device support to fenix6 and fenix7 lineup.
- Adjusted stat calculation from per day to per hour.

## [0.3.0]

### Added

 - hungarian language support
 - support for more devices (#5)
    - fenix 7 lineup
    - instinct 2 lineup
    - venu 2 and venu 3 lineups
    - vivoactive 5
    - all forerunner devices with glance support

## [0.2.0]

### Added

 - support for fenix lineup, fenix7s, fenix7s pro, forerunner245, forerunner245m

### Changed

 - Use calming and positive colors to evoke feelings of health
 - Improve placement of surrency symbol on MoneyNotSpent stat

### Fixed

 - Allow quit dates before 1970, fallback to today for future dates
 - Change packPrice from Int to Double

## [0.1.0] - 2024-05-10

First test release to Connect IQ Store to test app settings

[unreleased]: https://github.com/Zmetser/SmokeFreeCompanion/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/Zmetser/SmokeFreeCompanion/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/Zmetser/SmokeFreeCompanion/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/Zmetser/SmokeFreeCompanion/releases/tag/v0.4.0
[0.3.0]: https://github.com/Zmetser/SmokeFreeCompanion/releases/tag/v0.3.0
[0.2.0]: https://github.com/Zmetser/SmokeFreeCompanion/releases/tag/v0.2.0
[0.1.0]: https://github.com/Zmetser/SmokeFreeCompanion/releases/tag/v0.1.0
