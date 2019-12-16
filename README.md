# Packer Docker Vagrant box

A Packer project that builds a basic Vagrant box for VirtualBox provider with Docker Engine - Community installed.

## Prerequisites

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Make sure to install a version supported by Vagrant as described [here](https://www.vagrantup.com/docs/virtualbox/).
* Install [Vagrant](https://www.vagrantup.com/downloads.html).
* Install [Packer](https://www.packer.io/downloads.html).

## Building the box

1. Set Packer template variables. Available variables are:
   * `base_box` - the base box to use. It should be a Vagrant box with Ubuntu OS installed on it. Default: `slavrd/bionic64`.
   * `skip_add` - if the base box should be added to Vagrant. Set to `true` to avoid Vagrant re-adding (re-downloading) the base box. Default: `true`.
   * `build_name` - The name of the packer build. Should not be touched unless you have a specific reason. Default: `ubuntu-1804-docker`.

    Help on setting Packer variables can be found [here](https://www.packer.io/docs/templates/user-variables.html#setting-variables).

2. Run packer:
   
   ```BASH
   packer validate template.json
   packer build template.json
   ```
The created box will be in `./output-ubuntu-1804-docker/package.box`.

## Testing with KitchenCI

The project includes a KitchenCI configuration which can be used to run `inspec` tests on the created Vagrant box.

### Prerequisites

* Ruby, version `2.6.x` where `x >= 5`. It is recommended to use a ruby versions manager e.g. [rbenv](https://github.com/rbenv/rbenv).
* Install the required Ruby gems using bundler:
  * `gem install bundler` - run if [bundler](https://bundler.io/) is not installed.
  * `bundle install` - to install required gems, defined in `Gemfile`.
  
### Running tests

Tests are run after Packer successfully generated the Vagrant box. 

Make sure that box with name `ubuntu-docker-virtualbox-test` is not already added to vagrant. Run `vagrant box list` to view added boxes. If this box exists run the last, optional command to remove it.

* `bundle exec kitchen converge` - will add the generated box to Vagrant and will start the VM.
* `bundle exec kitchen verify` - will run the `inspec` tests in the VM.
* `bundle exec kitchen destroy` - will destroy the VM but will not remove the box from Vagrant.
* (optional) `vagrant box remove ubuntu-docker-virtualbox-test` - remove the tested box from Vagrant.

## Uploading the box to Vagrant cloud

You can use the `vagrant upload` [command](https://www.vagrantup.com/docs/cli/upload.html) to upload the box to Vagrant cloud.

The project contains a bash script `vagrant_cloud_upload.sh`, which is wrapper for the `vagrant upload` command.

The following variables need to be se inside the script in case their defaults are not appropriate:
  * `BOX` - name of the Vagrant Cloud box to which the script will upload
  * `BOX_PATH` - path to the box package to upload. Default should be correct if the `build_name` packer variable is default as well.
  * `BOX_DESC` - description for the Vagrant box and the created version.

The script will accept the version of the Vagrant box which will be created as an argument. If not provided it will default to the current date.

The variable `VAGRANT_CLOUD_TOKEN` can be set with a token to authenticate to Vagrant Cloud.

Example use: `./vagrant_cloud_upload.sh slavrd/docker 19.03.5`
