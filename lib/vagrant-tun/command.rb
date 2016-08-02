# coding: utf-8
# vim: set fileencoding=utf-8

module VagrantTun
  class Command

    def initialize(app, env)
      @app = app
      @env = env
    end

    def call(env)
      if env[:machine].config.tunn.enabled
	reboot(env)
        env[:ui].info("Ensured the TUN module is loaded into the kernel.")
      end
      @app.call(env)
    end

    def reboot(env)
        @env[:action_runner].run(Vagrant::Action::VM::Halt, @env)
        @env[:action_runner].run(Vagrant::Action::VM::Boot, @env)
    end
end
