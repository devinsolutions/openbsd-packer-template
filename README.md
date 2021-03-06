# OpenBSD Packer template

## Goal

Goal of this project is to provide compact OpenBSD Vagrant and GCE images, primarily for testing
Ansible roles.

Vagrant Box is available here: https://app.vagrantup.com/devinsolutions/boxes/openbsd-69-basic

By "basic" we mean that only `bsd`, `bsd.rd`, `base` and `comp` sets are included (plus GCE daemons
and Python needed by them in GCE images). We support only latest stable OpenBSD release. We update
these images with the latest binary patches on a best-effort basis.

## YAML

The template is written in YAML, not in JSON (we want comments and anchors to keep the template
DRY). We use [yacker](https://yacker.readthedocs.io/en/latest/) to invoke Packer.

## Requirements

  - POSIX shell and standard utilities
  - Pipenv (or your preferred way of installing Python dependencies, that are listed in `Pipfile`)
  - Packer
  - VirtualBox
  - `qemu-img` (if building image for GCE)
  - `jq` (if building image for GCE)

## Building

  - Install Python dependencies (`$ pipenv sync --dev`).
  - Decide whether you want to build GCE image or Vagrant Box. You can specify them using `-only`
    flag. See the following sections for prerequisites specific for each builder.
  - Copy `vars.yaml.template` to `vars.yaml` and fill in sections you are interested in.
  - `$ pipenv run build [-only=vbox-gce-builder,vbox-vagrant-builder]`
  - When done, you can remove build artifacts and caches using `$ pipenv run clean`

During build, you may see several errors like `==> vbox-gce-builder: ksh: sudo: not found`. These
are expected and it is safe to ignore them.

### Building and uploading GCE image (`vbox-gce-builder`)

Read and understand how does
[`googlecompute-import`](https://www.packer.io/docs/post-processors/googlecompute-import.html)
post-processor work. Fill-in required info to `vars.yaml`. The resulting image will be named
`openbsd-69-basic`, make sure that image with this name **does not** exist in the target project,
otherwise the import will fail.

### Building and uploading Vagrant image (`vbox-vagrant-builder`)

If you just want to build a Vagrant box locally and not upload it to Vagrant Cloud, comment-out the
`vagrant-cloud` post-processor in `openbsd.yaml`. Otherwise fill-in required variables in
`vars.yaml`, and make sure that box named as specified in variable `image_name` exists in the
Vagrant Cloud target organization, otherwise the import will fail. The import will also fail if
virtualbox provider already exists for version `vagrant_box_version`.

## Updating (new binary patches)

  - Add name of the new binary patch to `openbsd.yaml` variable `openbsd_desired_syspatches`
    (space-separated from the rest).
  - Bump image version (`image_version_patch`).
  - Build and publish, commit and push.
