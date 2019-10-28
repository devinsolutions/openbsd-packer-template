# OpenBSD Packer template

## Goal

Goal of this project is to provide up-to-date, minimal OpenBSD Vagrnat and GCP images, primarily
for testing Ansible roles.

## YAML

The template is written in YAML, not in JSON (we want comments and anchors to keep the template
DRY). We use [yacker](https://yacker.readthedocs.io/en/latest/) to invoke Packer.

## Building

Make sure that you have Packer and Pipenv installed, then:

```sh
pipenv sync
pipenv run yacker build openbsd.yaml
```
