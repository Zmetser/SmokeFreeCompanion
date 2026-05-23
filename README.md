# Smoke Free Companion

Smoke Free Companion is your personal companion on the journey to a smoke-free life. Keep track of your progress, celebrate milestones, and stay motivated with real-time updates on how long it's been since your last cigarette, the number of cigarettes not smoked, and the money saved. With QuitTracker, take control of your health and embrace a fresh start.

## Build

[Monkey C Visual Studio Code Extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/)

## Contributing

- **Set up the dev environment** — see [docs/setup.md](./docs/setup.md). After that, `make build` and `make test` are the daily commands.
- **Run the widget in the simulator** — `make run` builds and launches the simulator with the bundled app settings.
- **Test on a real device** — see [docs/device-testing.md](./docs/device-testing.md) for the USB sideload flow on fenix 6/7.
- **Conventions** — `.mc` and `.xml` files use 2-space indent (see `.editorconfig`). Anything reachable from the glance view needs the `(:glance)` annotation. Tests live next to the code they cover as `*.tests.mc`.
- **Pull requests** — open against `main`. The `make test` suite must pass; UI work should be smoke-tested on a real device when possible.

## License

Smoke Free Companion is licensed under the terms of the [GPL-3.0](./LICENSE.txt) license.

Smoke Free Companion also contains code from open source projects. See [ATTRIBUTIONS.md](./ATTRIBUTIONS.md) for a list.
