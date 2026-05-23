# Testing on a real device

The simulator covers most cases, but menu/picker theming and button input timing only show their true behavior on hardware. This guide walks through sideloading a dev build to a fenix 6/7 over USB.

> Tested on fenix 6 (macOS). The flow is the same for any other fenix 6/7 variant — just rebuild with the matching `DEVICE=` target.

## Prerequisites

- A fenix 6 or fenix 7 with a USB cable.
- `make build` working locally (see [setup.md](./setup.md)).

## 1. Build for the target device

```bash
make build              # defaults to fenix6
make build DEVICE=fenix7 # or any other supported variant
```

The output is `out/SmokeFreeCompanion.prg`.

## 2. Connect the watch and identify it

Plug the watch in over USB and wait for it to mount as a USB mass-storage volume (it appears as `/Volumes/GARMIN`).

Confirm which device is connected:

```bash
grep -oE '<Description>[^<]+</Description>' /Volumes/GARMIN/GARMIN/GarminDevice.xml | head -1
```

The output should match the `DEVICE=` you built for (e.g. `<Description>fenix 6</Description>`).

## 3. Back up the Store-installed widget

The widget on the device shares its **App ID** with the Connect IQ Store release (declared in `manifest.xml`). The cleanest sideload is to replace the existing `.PRG` in place — but back it up first so you can roll back.

Find the existing file via the device's app registry:

```bash
grep -oE '<App>.*?SMOKE FREE.*?</App>' /Volumes/GARMIN/GARMIN/GarminDevice.xml
```

Look for `<FileName>E5xxxxxx.PRG</FileName>` in that block — that's the Store-installed binary, living at `/Volumes/GARMIN/GARMIN/Apps/Media/<FileName>`.

Back it up to your Desktop:

```bash
cp /Volumes/GARMIN/GARMIN/Apps/Media/E5xxxxxx.PRG ~/Desktop/smoke-free-store-backup.PRG
```

## 4. Sideload the dev build

Widgets live under `Apps/Media/` on fenix 6/7 (watch faces and watch apps live directly under `Apps/`). Overwrite the Store-installed file with your dev build:

```bash
cp out/SmokeFreeCompanion.prg /Volumes/GARMIN/GARMIN/Apps/Media/E5xxxxxx.PRG
```

If macOS leaves an AppleDouble metadata file behind, clean it up — Garmin firmware can choke on those:

```bash
rm -f /Volumes/GARMIN/GARMIN/Apps/Media/._E5xxxxxx.PRG
```

> **Why overwrite vs. add a parallel file?** Both PRGs would declare the same App ID, and the device's deduplication is undefined. Replacing the existing file in place is the deterministic dev-loop.

## 5. Safely eject and disconnect

```bash
diskutil eject /Volumes/GARMIN
```

Then unplug the cable. The watch will resume from its boot screen; you may see a brief "Refreshing data" indexing pass.

## 6. Test on the watch

1. From the watch face, press **UP** (middle-left) to enter the widget loop.
2. Scroll to **SMOKE FREE** and press **enter/start** (top-right) to open the full widget.
3. **Verify settings survived the upgrade.** Page through the stat views — the cigarettes-not-smoked count, money saved, and quit date must match what the user had on the previous version. The widget's settings live in `Apps/SETTINGS/<PRG-stem>.SET`, which the sideload does *not* touch, so this should always hold. If it doesn't, **stop and roll back** (step 7); a release that wipes user data is the worst-case regression for this widget.
4. Page through the stat views with **UP / DOWN**.
5. Long-press **UP** on any stat view to invoke the **MENU** behavior — the settings menu should slide up.
6. Edit each setting; back out and confirm the stat view reflects the change.
7. (Optional) Unplug, reboot the watch, and reopen the widget to confirm the edited values persisted across a power cycle.

## 7. Roll back

To return to the Store-installed version, reconnect the watch, copy the backup back, and eject:

```bash
cp ~/Desktop/smoke-free-store-backup.PRG /Volumes/GARMIN/GARMIN/Apps/Media/E5xxxxxx.PRG
diskutil eject /Volumes/GARMIN
```

Alternatively, uninstall and reinstall the widget from the Connect IQ Store via the mobile app.

## Troubleshooting

- **Widget doesn't appear / appears broken** — check that you copied to `Apps/Media/`, not `Apps/`. Widgets and data fields live in `Media/`; watch faces and watch apps don't.
- **"App is corrupt" or boot loop** — restore from the backup. A dev key signed with the wrong PRG type, or a copy that left an AppleDouble file, are the usual causes.
- **Settings menu shows white-on-white** in the simulator only — known sim artifact; on hardware the native Menu2 theme renders correctly.
- **Build mismatch** — if you built for `fenix7` and try to load on a fenix 6, the widget either won't appear or the firmware will reject it. Match `DEVICE=` to the device under `<Description>` in `GarminDevice.xml`.
- **Settings reset to defaults after sideload** — should not happen. The `.SET` file in `Apps/SETTINGS/` is keyed by the PRG stem and survives an in-place PRG overwrite. If you renamed the PRG (e.g. dropped `SmokeFreeDev.PRG` alongside the original instead of overwriting), the firmware treats it as a separate install and the `.SET` won't be picked up. Use the same filename as the existing PRG.
