# Contributing

Thanks for your interest in the **pwshCloudflare Project**! All feedback and contributions are appreciated. Review this document to get started.

## Reporting Bugs/Feature Requests

When filing an issue please check [existing open](https://github.com/connorcarnes/pwshCloudflare/issues) and [recently closed](https://github.com/connorcarnes/pwshCloudflare/issues?q=is%3Aissue+is%3Aclosed) issues to make sure somebody else hasn't already reported it. Include as much information as you can. Details like these are incredibly useful:

    A reproducible test case or series of steps
    The version of code being used (found in the plasterManifest.xml file)
    Any modifications you've made relevant to the bug
    Anything unusual about your environment or deployment

## Pull Requests

Before sending a pull request please ensure that:

1. You are working against the latest source on the *dev* branch.
2. You check existing open, and recently merged, pull requests to make sure someone else hasn't addressed the problem already.
3. You open an issue to discuss any significant work - I'd hate for your time to be wasted.

To send a pull request:

1. Fork the repository.
2. Checkout the *dev* branch
3. Modify the source. Refrain from code styling changes or any other change that's not related to your goal.
4. Ensure local tests pass.
5. Commit to your fork using clear commit messages.
6. Send a pull request, answering any default questions in the pull request interface.

GitHub provides additional document on [forking a repository](https://help.github.com/articles/fork-a-repo/) and
[creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Code of Conduct

This project has a [Code of Conduct](CODE_OF_CONDUCT.md).

## Licensing

See the [LICENSE](LICENSE.txt) file for our project's licensing.

## Development Environment

This document focuses on developing locally using VS Code, Docker and Microsoft's [Development Container specification](https://containers.dev/). Regular local development, [GitHub CodeSpaces](https://docs.github.com/en/codespaces) and other remote development options should work about the same.

### Setup

Fork the repository in GitHub (uncheck the box that says `copy main branch only`) and clone your fork. Open it in VS Code and install the [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers). You can install it individually or via [Microsoft's Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack). VS Code might prompt you to install Docker if you don't have it installed. You can install it by accepting the VS Code prompt or [with the instructions on this page](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers). If you already have Docker installed make sure it's updated to a recent version. At this point VS Code may prompt you to reopen the workspace in a container, do it. If you're not prompted follow these steps:

- Open the VS Code command pallette by hitting `CTRL + SHIFT + P` on your keyboard.
- Start typing "Dev Containers"
- Select "Open workspace in container"

That's it! Create an issue if you have any questions. Check out the [VS Code Dev Container Documentation](https://code.visualstudio.com/docs/devcontainers/containers) too.

### Your First Contribution

If you'd like to validate your dev env follow these steps:

- Create an issue with the title "YourName First Contribution"
- On your local clone switch to the *dev* branch and add your name to the [contributors list](../README.md#contributors)
- Validate local tests are passing after making your change by hitting `CTRL + SHIFT + P`, select `Tasks: Run Test Task` and select the task titled `Test`.
- Git add, commit and push your changes to your fork
- Make a pull request to merge the *dev* branch of your fork to the *dev* branch of the main repo
- Validate all checks pass

