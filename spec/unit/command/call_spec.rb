# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require 'spec_helper'
require "vagrant-tun/command"

describe VagrantTun::Command do
  # create a fake app and env to pass into the VagrantTun::Command constructor
  let(:app) { lambda { |env| } }
  let(:env) { { :machine => machine,  :ui => ui } }

  # pretend env contains the Vagrant ui element
  let(:ui) { { } }

  # pretend env[:machine].config.tun.enabled is false
  let(:machine) do
    double('machine').tap do |machine|
      allow(machine).to receive(:config) { config }
    end
  end
  let(:config) do
    double('config').tap do |config|
      allow(config).to receive(:tun) { tun }
    end
  end
  let(:tun) do
    double('tun').tap do |config|
      allow(config).to receive(:enabled) { enabled }
    end
  end
  let(:enabled) { false }


  # Call the method under test after every 'it'. Similar to setUp in Python TestCase
  after do
    subject.call(env)
  end

  # instantiate class of which a method is to be tested
  subject { described_class.new(app, env) }

  # the method that we are going to test
  describe "#call" do

    context "when config tun disabled (default)" do
      it "does nothing but call the super" do
        # check ensure_tun_available is not called when plugin is disabled
        expect(subject).to receive(:ensure_tun_available).never
        # check super is still called when plugin is disabled
        expect(app).to receive(:call).with(env)
      end
    end

    context "when config tun enabled" do
      # pretend env[:machine].config.tun.enabled is true
      let(:enabled) { true }

      it "ensures the tun adapter is available" do
        # check ensure_tun_available is called when plugin is enabled
        expect(subject).to receive(:ensure_tun_available).with(env)
        # check super is also called when plugin is enabled
        expect(app).to receive(:call).with(env)
      end
    end
  end
end

