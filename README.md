# vagrant-tun

## Purpose

This Vagrant plugin makes sure that there is a TUN/TAP device in a usable state.

There are a couple of reasons why `/dev/net/tun` could be unavailable after provisioning. One of them is that it could be that the base image you are using does not have the `tun` module loaded by default. Another is that updating and upgrading the machine during the provisioning stage has installed a new kernel and requires a reboot for the `tun` module to be successfully loaded. This plugin tries to automate all of that.

1. Check if the TUN adapter exists and is in a usable state

2. If not, create it with ```mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 0666 /dev/net/tun```

3. If it still is not in a usable state, try to load the `tun` module into the kernel and check again

4. If it is still not in a usable state, reboot the machine and check again


## Usage

### Install the plugin

```
$ vagrant plugin install vagrant-tun
```

Enable the plugin in your Vagrantfile
```
Vagrant.configure('2') do |config|
        config.tun.enabled = true
```

## Development

### Install the build deps

```
sudo gem install bundler rake rspec simplecov coveralls
```

### Run the tests
```
$ make test
```

### Create the gemfile (package)

```
$ make
rake build
vagrant-tun 0.0.1 built to pkg/vagrant-tun-0.0.1.gem.
```

### Install the built gemfile
```
$ make install
find pkg/ -name '*.gem' | head -n 1 | xargs vagrant plugin install
Installing the 'pkg/vagrant-tun-0.0.1.gem' plugin. This can take a few minutes...
Installed the plugin 'vagrant-tun (0.0.1)'!
```
