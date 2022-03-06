# testappio plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-testappio)
- [testappio plugin](#testappio-plugin)
  - [Getting Started](#getting-started)
  - [TestAppIO Actions](#testappio-actions)
    - [Action **upload_to_testappio**](#action-upload_to_testappio)
  - [Issues and Feedback](#issues-and-feedback)
  - [Troubleshooting](#troubleshooting)
  - [Using _fastlane_ Plugins](#using-fastlane-plugins)
  - [About _fastlane_](#about-fastlane)
## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-testappio`, add it to your project by running:

```bash
fastlane add_plugin testappio
```

## TestAppIO Actions

Actions provided by the CLI: [ta-cli](https://github.com/testappio/cli)

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

To upload after the fastlane `gym` action:
```ruby
  lane :development do
    match(type: "development")
    gym(export_method: "development")
    upload_to_testappio(
      api_token: "your api token",
      app_id: "your app id",
      release_notes: "release notes go here",
      notify: "false"
    )
  end
```

### Action **upload_to_testappio**
Upload ipa/apk packages to TestApp.io and notify your team members.
 
|Key|Description|Env Var(s)| Default |
|---|---|---|---|
| api_token| API Token for UploadToTestappioAction        | FL_UPLOAD_TO_TESTAPPIO_API_TOKEN ||
| app_id   | You can get it from your app page in https://portal.testapp.io/apps | FL_UPLOAD_TO_TESTAPPIO_APP_ID    ||
| release  | It can be either both or android or ios      | FL_UPLOAD_TO_TESTAPPIO_RELEASE   ||
| apk_file | Path to the android apk file        |       ||
| ipa_file | Path to the ios ipa file   |       ||
| release_notes     | Manually add the release notes to be displayed for the testers|       ||
| git_release_notes | Collect release notes from the latest git commit      |       | true    |
| | message to be displayed for the testers: true or false|       ||
| git_commit_id     | Include the last commit ID in the release notes       |       | false   |
| | (works with both release notes option): true or false |       ||
| notify   | Send notificaitons to your team members about this    |       | false   |
| | release: true or false     |       ||


## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
