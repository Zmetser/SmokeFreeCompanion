# Learnings

Cross-cutting principles surfaced by past fixes in this repo. Each entry is the *principle* a future contributor needs — the example is an anchor, not a recap. Add to this list only when a fix exposes something a careful reader of the code couldn't infer for themselves.

## Subtract in the unit you counted in

When decomposing a `Time.Duration` into a `(years, months, days, hours, minutes)` tuple, the unit used to **extract** a component must match the unit used to **subtract that component back out** of the duration. Translating between units (years → days → seconds) opens the door to silent drift.

Anchor: `source/stats/ElapsedTimeBuilder.mc`

## Monkey C `Number / Number` truncates silently

`365 / 12 == 30` because both operands are `Number`. If a constant looks fractional, it isn't unless one operand is forced to `Float`/`Double`: write `365.0 / 12` when you mean a real ratio. Constant names that imply fractions (`DAYS_IN_MONTH`, `AVG_…`, anything that sounds like a mean) without the matching type are a smell — verify the type before using them in proportional math.

Anchor: `source/stats/Stats.mc`

## Anything reachable from the glance build needs `(:glance)`

The glance build is a separate, smaller binary than the full app, produced by stripping every function, class, and module that is not annotated `(:glance)`. The linker does **not** warn when a glance call site references stripped code — you get a silent broken binary that crashes at first invocation with `"Failed invoking <symbol>"`.

Rule: every function that can be on the call path from a `(:glance)` class (transitively) must carry `(:glance)` itself. When in doubt, follow the chain from `GlanceView.onLayout` / `onUpdate` through every call and check each callee.

Anchor: `source/Settings.mc` — `getColorSpace()` was missed during the v0.4.1 Settings refactor and crashed the glance view at launch until the annotation was added.
