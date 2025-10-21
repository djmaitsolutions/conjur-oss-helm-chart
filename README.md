# conjur-oss-helm-chart

[Helm](https://github.com/helm/helm) chart for [Conjur Open Source](https://www.conjur.org).

[![GitHub release](https://img.shields.io/github/release/cyberark/conjur-oss-helm-chart.svg)](https://github.com/cyberark/conjur-oss-helm-chart/releases/latest)
[![pipeline status](https://gitlab.com/cyberark/conjur-oss-helm-chart/badges/master/pipeline.svg)](https://gitlab.com/cyberark/conjur-oss-helm-chart/pipelines)

[![Github commits (since latest release)](https://img.shields.io/github/commits-since/cyberark/conjur-oss-helm-chart/latest.svg)](https://github.com/cyberark/conjur-oss-helm-chart/commits/master)

---

## Using conjur-oss-helm-chart with Conjur Open Source 

See [./conjur-oss](conjur-oss) for Chart files and instructions.

We **strongly** recommend choosing the version of this project to use from the latest [Conjur OSS 
suite release](https://docs.conjur.org/Latest/en/Content/Overview/Conjur-OSS-Suite-Overview.html). 
Conjur maintainers perform additional testing on the suite release versions to ensure 
compatibility. When possible, upgrade your Conjur version to match the 
[latest suite release](https://docs.conjur.org/Latest/en/Content/ReleaseNotes/ConjurOSS-suite-RN.htm); 
when using integrations, choose the latest suite release that matches your Conjur version. For any 
questions, please contact us on [Discourse](https://discuss.cyberarkcommons.org/c/conjur/5).


## Requirements

This chart requires Helm v3+. The chart may work with older versions of Helm
but that deployment isn't specifically supported.

## Contributing

We store instructions for development and guidelines for how to build and test this
project in the [CONTRIBUTING.md](CONTRIBUTING.md) - please refer to that document
if you would like to contribute.

## Testing

There is a complete set of unit tests for the chart which are executed using [Helm unittest plugin](https://github.com/helm-unittest/helm-unittest/tree/main) from this root folder. For example:

```bash
helm unittest conjur-oss
```

As snapshots of the default rendered templates are used for many of the tests, if you make template changes that affect the defaults you will need to update the snapshots like so:

```bash
helm unittest conjur-oss -u
```

_NOTE:_ if you do update the snapshot files you will need to also add the commit fingerprint to the `.gitleaksignore` file to prevent a Gitleaks security scan error.
 
This repository includes basic smoke testing on GKE. The Conjur OSS Helm Chart is also exercised more thoroughly by the [cyberark/conjur-authn-k8s-client](https://github.com/cyberark/conjur-authn-k8s-client) project, which clones the OSS Helm Chart repo and uses it while testing across several versions of Kubernetes and OpenShift.

## License

This repository is licensed under Apache License 2.0 - see [`LICENSE`](LICENSE) for more details.
