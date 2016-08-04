require "vagrant"

module VagrantTun
  class Command

    def initialize(app, env)
      @app = app
      @env = env
    end

    def call(env)
      if env[:machine].config.tun.enabled
	success = verify_adapter(env, true)
	if ! success
	  reboot(env)
	  success = verify_adapter(env, true)
	end
	if success
          env[:ui].info("Ensured the TUN module is loaded into the kernel.")
	else
	  env[:ui].error("Failed to load the TUN/TAP adapter. If you are running a custom kernel make sure you have the tun module enabled.")
	end
      end
      @app.call(env)
    end

    def try_load_tun_kernel_module(env)
      load_tun_module_command = "modprobe tun"
      env[:machine].communicate.sudo(load_tun_module_command, {:error_check => false}) do |type, data|
        return verify_adapter(env, false)
      end
    end

    def try_create_adapter(env)
      env[:ui].info("Trying to create TUN adapter")
      result = false
      create_adapter_command = '(mkdir -p /dev/net && '
      create_adapter_command << 'mknod /dev/net/tun c 10 200 && '
      create_adapter_command << 'chmod 0666 /dev/net/tun) 2>/dev/null'
      env[:machine].communicate.sudo(create_adapter_command, {:error_check => false}) do |type, data|
        result = verify_adapter(env, false)
	if ! result
	  result = try_load_tun_kernel_module(env)
        end
      end
      return result
    end

    def verify_adapter(env, try_create)
      env[:ui].info("Verifying TUN adapter..")
      result = false
      env[:machine].communicate.sudo('cat /dev/net/tun', {:error_check => false}) do |type, data|
        adapter_state = data.to_s.strip
        case adapter_state
        when /\bFile descriptor in bad state\b/
          env[:ui].info("TUN adapter OK!")
          result = true
        when /\bNo such file or directory\b/
	  if try_create
            env[:ui].info("TUN adapter not OK :(")
	    result = try_create_adapter(env)
	  else
	    result = false
	  end
        end
      end
      return result
    end

    def reboot(env)
      env[:ui].info("Rebooting..")
      env[:machine].action(:reload, {'provision_ignore_sentinel' => false})
      begin
        sleep 1
      end until env[:machine].communicate.ready?
    end
  end
end
