# Contributing

We appreciate all kinds of contributions. As a contributor, here are the guidelines we would like you to follow:

 - [Issues and Bugs](#issue)
 - [Submission Guidelines](#submit-pr)
 - [Commit Message Guidelines](#commit)

## <a name="issue"></a> Found an Issue?
If you find a mistake or unclear formulation in the documentation (sources @ [/docs](/docs) folder), you can help us by [submitting an issue](#submit-issue) to our [GitHub Repository][github]. Including an improvement suggestion helps the team understand the desired change.

You can help the team even more and [submit a Pull Request](#submit-pr) with a concrete improvement or bugfix.

### <a name="submit-issue"></a> Submitting an Issue
If your issue appears to be a bug, and hasn't been reported, open a new issue.
Providing the following information will increase the chances of your issue being dealt with quickly:

* **Motivation for change or Use Case** - explain what are you trying to do and why the current state does not fit your needs
* **Related Issues** - has a similar issue been reported before?
* **Suggest a Fix** - if you can't fix the bug yourself, perhaps you can point to what might be wrong.

You can file new issues by providing the above information [here](https://github.com/SchweizerischeBundesbahnen/api-principles/issues/new).

### <a name="submit-pr"></a> Submitting a Pull Request (PR)
Before you submit your Pull Request (PR) consider the following guidelines:

* Make your changes in a new git branch:

     ```shell
     git checkout -b my-fix-branch master
     ```
     
* Write the changes in english and check the documents against an english spell-checker (e.g. [grammarly](https://app.grammarly.com))
* Commit your changes using a descriptive commit message that follows our [commit message conventions](#commit).

     ```shell
     git commit -a
     ```
  Note: the optional commit `-a` command line option will automatically "add" and "rm" edited files.

* Push your branch to GitHub:

    ```shell
    git push my-fork my-fix-branch
    ```

* In GitHub, send a pull request to `api-principles:master`.

## <a name="commit"></a> Commit Message Guidelines

This project uses [Conventional Commits](https://www.conventionalcommits.org/) to generate the changelog.

### Commit Message Format
```
docs: <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

Any line of the commit message cannot be longer 100 characters! This allows the message to be easier
to read on GitHub as well as in various git tools.
