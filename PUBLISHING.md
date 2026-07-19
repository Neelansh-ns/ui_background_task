# Publishing checklist

Use this checklist after the release pull request has been reviewed and merged.
Publishing to pub.dev is permanent, so do not use `--force` to bypass warnings.

## Prepare the release

- [ ] Start from a clean, up-to-date `master` branch.
- [ ] Confirm `pubspec.yaml` contains the intended semantic version.
- [ ] Keep `ios/ui_background_task.podspec` on the same version.
- [ ] Add the release date and user-facing changes to `CHANGELOG.md`.
- [ ] Recheck package metadata, links, supported versions, README examples, and
      the example application.

## Validate

Run every command from the package root unless a command changes directory:

```console
dart format --output=none --set-exit-if-changed lib test example/lib example/test
flutter analyze
flutter test
cd example && flutter test && cd ..
dart doc --dry-run
cd ios/ui_background_task && swift package dump-package >/dev/null && cd ../..
flutter pub publish --dry-run
```

- [ ] All commands exit successfully.
- [ ] The dry run reports zero warnings.
- [ ] Review the dry run's complete file list for secrets, generated files, or
      internal-only documentation.
- [ ] Build and exercise the example on a physical iPhone.
- [ ] Confirm both CocoaPods and Swift Package Manager consumer integrations.

## Publish

```console
flutter pub publish
```

- [ ] Complete pub.dev authentication and verify the new version appears.
- [ ] Create and push a matching Git tag, for example `v0.3.0`.
- [ ] Verify the README, changelog, example, API documentation, supported
      platforms, and package score on pub.dev.

See the official [Dart publishing guide](https://dart.dev/tools/pub/publishing)
and [Flutter package guide](https://docs.flutter.dev/packages-and-plugins/developing-packages#publishing-your-package).
