require "vagrant"
require "vagrant-tun/command"

module VagrantTun
  class Plugin < Vagrant.plugin("2")
    name "tun"
    description <<-DESC
    Make sure the tun module is loaded into the kernel
    DESC

    config 'tun' do
      require File.expand_path("../vagrant-tun/config", __FILE__)
      Config
    end

    action_hook(:VagrantTun) do |hook|
      hook.before(Vagrant::Action::Builtin::Provision, VagrantTun::Command)
    end
  end
end
