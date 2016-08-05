# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require 'spec_helper'
require "vagrant-tun/command"

describe VagrantTun::Command do
  # create a fake app and env to pass into the VagrantTun::Command constructor
  let(:app) { lambda { |env| } }
  let(:env) { { :machine => machine,  :ui => ui } }

  # pretend env contains the Vagrant ui element
  let(:ui) do
    double('ui').tap do |ui|
      allow(ui).to receive(:info) { nil }
    end
  end

  # pretend env[:machine].action and .communicate can be called
  let(:machine) do
    double('machine').tap do |machine|
      allow(machine).to receive(:action) { action }
      allow(machine).to receive(:communicate) { communicate }
    end
  end
  let(:action) do
    double('action').tap do |action|
      allow(action).to receive(:reload) { reload }
    end
  end
  let(:reload) { nil }
  let(:communicate) do
    double('communicate').tap do |communicate|
      allow(communicate).to receive(:ready?) { ready }
    end
  end
  let(:ready) { true }

  # Stub all sleeps
  before do
    allow_any_instance_of(Object).to receive(:sleep)
  end

  # Call the method under test after every 'it'. Similar to setUp in Python TestCase
  after do
    subject.reboot(env)
  end

  # instantiate class of which a method is to be tested
  subject { described_class.new(app, env) }

  # the method that we are going to test
  describe "#reboot" do

    context "when machine is rebooted" do
      it "logs the reboot message and reboots the machine" do
        # Check that the reboot message was logged
        expect(ui).to receive(:info).once.with("Rebooting because we couldn't load the tun module. Maybe the kernel was updated?")

        # Check that the reload command was sent
        expect(machine).to receive(:action).once.with(:reload)

        # Check that we block wait until ready
        expect(communicate).to receive(:ready?).once.and_return(false, false, true)
      end
    end
  end
end
