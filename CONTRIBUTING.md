# Contributing

For general contribution and community guidelines, please see the [community repo](https://github.com/cyberark/community).

## Table of Contents

- [Releasing](#releasing)
- [Contributing](#contributing)

Majority of the instructions on how to build, develop, and run the code in
this repo is located in the main [README.md](README.md) but this file adds
any additional information for contributing code to this project.

## Releases

Releases should be created by maintainers only. To create and promote a release, follow the instructions in this section.

### Update the changelog

**NOTE:** If the Changelog is already up-to-date, skip this
step and promote the desired release build from the main branch.

1. Create a new branch for the version bump.
1. Based on the changelog content, determine the new version number and update.
1. Review the git log and ensure the [changelog](CHANGELOG.md) contains all
   relevant recent changes with references to GitHub issues or PRs, if possible.
1. Commit these changes - `Bump version to x.y.z` is an acceptable commit
   message - and open a PR for review.

### Release and Promote

1. Merging into the main branch will automatically trigger a release build.
   If successful, this release can be promoted at a later time.
1. Jenkins build parameters can be utilized to promote a successful release
   or manually trigger aditional releases as needed.
1. Reference the [internal automated release doc](https://github.com/conjurinc/docs/blob/master/reference/infrastructure/automated_releases.md#release-and-promotion-process)
for releasing and promoting.
1. **After promotion add the chart to our public [Helm charts repo](https://github.com/cyberark/helm-charts)**

## Contributing

1. [Fork the project](https://help.github.com/en/github/getting-started-with-github/fork-a-repo)
2. [Clone your fork](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository)
3. Make local changes to your fork by editing files
3. [Commit your changes](https://help.github.com/en/github/managing-files-in-a-repository/adding-a-file-to-a-repository-using-the-command-line)
4. [Push your local changes to the remote server](https://help.github.com/en/github/using-git/pushing-commits-to-a-remote-repository)
5. [Create new Pull Request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork)
