# Contributing
Before making a contribution, please read the relevant section of this document
to learn how we handle them.

Thanks for making `catoolbox` better!

* [Code of conduct](#code-of-conduct)
* Ask/say something
  * [Request support](#request-support)
  * [Report a bug](#report-a-bug)
  * [Request a feature](#request-a-feature)
* Make something
  * [Project setup](#project-setup)
  * [Commit guidelines](#commit-guidelines)
  * [Contribute documentation](#contribute-documentation)
  * [Contribute code](#contribute-code)

## Code of conduct
This project is governed by a [code of conduct](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Request support
Since (at the time of writing) there are no discussion boards, should you have
any questions, just send an e-mail to @AlessandroMenti (his address is in [his
GitHub profile](https://github.com/AlessandroMenti)). *Please note that, since
his free time is extremely limited, it might take him some time to reply.*

**Please do not file an issue to ask a question**; use the bug tracker only for
bug reports and feature requests.

## Report a bug
1. Make sure you are running either the latest release of the project, or the
   Git development version, as we will only accept reports made against them.
   Whenever possible, test against the latest development version.
2. [Search the bug tracker](https://github.com/catoolbox/catoolbox/issues).
   If the issue was already reported and you have further details to add,
   just leave a comment in the existing bug report; please do not open
   duplicates or add `+1` comments to the reports.
3. If the issue was not reported, [create a new one](https://github.com/catoolbox/catoolbox/issues/new).
   Give all the information required by the issue template.
   **As an exception, if you are reporting a security bug, DO NOT create an
   issue on the bug tracker - doing so will cause more damage than help.
   Instead, send an e-mail to @AlessandroMenti (his e-mail address is in [his
   GitHub profile](https://github.com/AlessandroMenti)); if possible, encrypt
   it using [his GPG key](https://www.alessandromenti.it/downloads/pubkey-0xBF334213F5C5CA03.asc).**

Once the bug report is filed, we will try to reproduce the issue by following
the steps you provided.

Should we need some clarification about your report, we will leave a comment
asking you to provide the required details; if you don't respond within 30 days,
the issue will be closed. If you wish to come back to it, just reply (once)
and we'll reopen it.

After our preliminary analysis:

* if the report is *confirmed* (the bug indeed exists in the latest version and
  has not been fixed yet), we will label it `bug`;
* if the report is *invalid* (we were unable to reproduce the bug, or it was
  already fixed), we will label it `invalid` and close it;
* if the report is a *duplicate* (another bug report for the same issue
  exists), we will label it `duplicate` and close it;
* if the report is confirmed, but there are strong, valid technical reasons
  that make solving the issue impossible or extremely difficult, we will
  explain our reasoning, then label the report `wontfix` and close it.

Confirmed reports will be automatically closed by GitHub once a commit that
fixes the issue is published. Occasionally, we might ask you for additional
details/clarifications.

## Request a feature
If the project doesn't do something you need or want it to do:

1. Make sure the feature is not already present in the Git development version.
2. [Search the bug tracker](https://github.com/catoolbox/catoolbox/issues).
   If the feature was already requested and you have further details to add,
   just leave a comment in the existing bug report; please do not open
   duplicates or add `+1` comments to the reports.
3. If the feature was not requested, [create a new issue](https://github.com/catoolbox/catoolbox/issues/new).
   Give all the information required by the issue template; provide as much
   context as you can about what you are running into and try to be clear
   about why existing features/alternative would not work.

Once the feature request is filed, we will label it `enhancement` and, if
needed, ask you more questions to understand its purpose and any relevant
requirements.

If we decide not to implement the feature, we will close the issue, convey our
reasoning and suggest an alternative path forward; otherwise, the issue will be
automatically closed by GitHub once a commit that implements the feature is
published.

## Project setup
Follow these steps to set up a copy of this project on your computer to start
contributing code/documentation:

1. [Read up on how to fork a GitHub project and file a PR](https://guides.github.com/activities/forking).
2. [Fork the project](https://guides.github.com/activities/forking/#fork).
3. [Clone your fork locally](https://help.github.com/articles/cloning-a-repository/).

## Commit guidelines
Please follow these guidelines when committing.

* Ensure that every function is documented properly (including examples).
* Make sure that the test suite passes; add new test cases each time you fix a
  code issue or introduce a new functionality.
* Follow the code style of the project (1TBS, indent with four spaces). If your
  IDE supports [.editorconfig files](http://editorconfig.org/), you can have it
  pick the `.editorconfig` file stored in the root directory to use the correct
  indentation settings automatically. If you use `indent`, call it with the
  following flags to reformat your code: `-kr -nut -c0 -cd0 -cp0`.
* Make your commits self-contained (each one should contain one, and only one,
  enhancement/fix).
* Use the following format for your commit messages:

  ```
  A short description of your commit (~50 characters long)

  If needed, add a second paragraph (wrapped at 80 characters) that describes
  your change in more detail. Use the imperative tense in both the short
  description and the detailed description of the commit; also, make sure to
  start the short description with a capital letter and not to end it with a
  dot. Should the commit fix an issue, include "Fixes" followed by the issue
  number(s), as follows:

  Fixes #1, fixes #2
  ```

  Read [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
  for an in-depth explanation of the rationale.
* If possible, [sign your commits using GPG](https://help.github.com/articles/signing-commits-using-gpg/).

## Contribute documentation
We store documentation and examples as Doxygen comments in the source code.

To contribute documentation:

* [Set up the project](#project-setup).
* Edit or add any relevant documentation.
* Make sure your changes are formatted correctly and consistently with the
  rest of the documentation. Re-read what you wrote, and run a spellchecker on
  it to make sure you didn't miss anything.
* Commit your changes to your fork - make sure to follow the
  [commit guidelines](#commit-guidelines).
* [Open a pull request with your changes](https://github.com/catoolbox/catoolbox/pulls).

Once you have filed the pull request:

* We will review your changes using GitHub's review feature.
* If we ask for any edits, make them and push them to your repository, so that
  we can perform another review.
* If your pull request looks good, we will merge it.
* From time to time, it might happen that we need to pass on your PR; in that
  case, we will explain why we will not be accepting the changes. We still
  really appreciate you taking the time to do it, and we don't take that
  lightly.

## Contribute code
To contribute code:

* [Set up the project](#project-setup).
* If the change you would like to make is major, [open an issue](#request-a-feature)
  to discuss it with us first.
* Make any necessary changes to the source code.
* Include any [additional documentation](#contribute-documentation) the changes might need.
* Write tests that verify that your contribution works as expected.
* Commit your changes to your fork - make sure to follow the
  [commit guidelines](#commit-guidelines).
* [Open a pull request with your changes](https://github.com/catoolbox/catoolbox/pulls).

Once you have filed the pull request:

* The continuous integration system will automatically run the test suite and
  the code style checker. Barring exceptional circumstances, we will not
  review pull requests until all checks pass; in case a test fails, please
  have a look at the relevant log, fix the error and push your changes again.
* We will review your changes using GitHub's review feature.
* If we ask for any edits, make them and push them to your repository, so that
  we can perform another review.
* If your pull request looks good, we will merge it.
* From time to time, it might happen that we need to pass on your PR; in that
  case, we will explain why we will not be accepting the changes. We still
  really appreciate you taking the time to do it, and we don't take that
  lightly.

## Attribution
This guide is based on the template provided by
[the WeAllJS `CONTRIBUTING.md` generator](https://npm.im/weallcontribute).

Some sections were inspired by [the JHipster `CONTRIBUTING.md`](https://github.com/jhipster/generator-jhipster/blob/master/CONTRIBUTING.md) and by [Wrangling Web Contributions: How to Build
a CONTRIBUTING.md](https://mozillascience.github.io/working-open-workshop/contributing/).
