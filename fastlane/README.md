fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios generate_project

```sh
[bundle exec] fastlane ios generate_project
```



### ios test

```sh
[bundle exec] fastlane ios test
```

Run tests

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app for development

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Setup certificates and provisioning profiles

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and archive the app for App Store

### ios beta_upload

```sh
[bundle exec] fastlane ios beta_upload
```

Upload to TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Deploy to App Store

### ios increment_build

```sh
[bundle exec] fastlane ios increment_build
```

Increment build number

### ios increment_version

```sh
[bundle exec] fastlane ios increment_version
```

Increment version and build

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
