# Contributing to jessie

The jessie project team welcomes contributions from the community.

## Contribution Flow

- Fork and clone the repository
- Create a topic branch from where you want to base your work
- Make commits of logical units
- Make sure the tests pass
- Push your changes to a topic branch in your fork of the repository
- Submit a pull request

Example:

``` shell
git remote add upstream git@github.com:f3ath/jessie.git
git checkout -b my-new-feature main
git commit -a
git push origin my-new-feature
```

### Running the Test Suite

The test suite is included as a submodule. To run the tests, you need to initialize the submodule:

``` shell
git submodule update --init
```

Then you can run the tests:

``` shell
dart test
```

### Staying In Sync With Upstream

When your branch gets out of sync with the jsonpath-standard/jessie/main branch, use the following to update:

``` shell
git checkout my-new-feature
git fetch -a
git pull --rebase upstream main
git push --force-with-lease origin my-new-feature
```

### Updating pull requests

If your PR fails to pass CI or needs changes based on code review, you'll most likely want to squash these changes into
existing commits.

If your pull request contains a single commit or your changes are related to the most recent commit, you can simply
amend the commit.

``` shell
git add .
git commit --amend
git push --force-with-lease origin my-new-feature
```

If you need to squash changes into an earlier commit, you can use:

``` shell
git add .
git commit --fixup <commit>
git rebase -i --autosquash main
git push --force-with-lease origin my-new-feature
```
