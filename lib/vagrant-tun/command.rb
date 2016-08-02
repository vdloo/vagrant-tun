# coding: utf-8
# vim: set fileencoding=utf-8

require "vagrant"

module VagrantTun
  class Command

    def initialize(app, env)
      @app = app
      @env = env
    end

    def call(env)
      if env[:machine].config.tun.enabled
	reboot(env)
        env[:ui].info("Ensured the TUN module is loaded into the kernel.")
      end
      @app.call(env)
    end

    def reboot(env)
      simple_reboot = Vagrant::Action::Builder.new.tap do |b|
        b.use Vagrant::Action::Builtin::Call, Vagrant::Action::Builtin::GracefulHalt, :poweroff, :running do |env2, b2|
          if !env2[:result]
            b2.use VagrantPlugins::ProviderVirtualBox::Action::ForcedHalt
          end
        end
        b.use VagrantPlugins::ProviderVirtualBox::Action::Boot
        if defined?(Vagrant::Action::Builtin::WaitForCommunicator)
          b.use Vagrant::Action::Builtin::WaitForCommunicator, [:starting, :running]
        end
      end
      env[:action_runner].run(simple_reboot, env)
    end
  end
end
