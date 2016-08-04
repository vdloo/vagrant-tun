require File.expand_path('../lib/vagrant-tun/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "vagrant-tun"
  spec.version       = Vagrant::Tun::VERSION
  spec.authors       = ["Rick van de Loo"]
  spec.email         = ["rickvandeloo@gmail.com"]
  spec.description   = %q{Make sure the TUN module is loaded into the kernel}
  spec.summary       = %q{Make sure the TUN module is loaded into the kernel}
  spec.homepage      = "https://github.com/vdloo/vagrant-tun"
  spec.license       = "MIT"

  spec.files = `git ls-files`.split("\n")
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
