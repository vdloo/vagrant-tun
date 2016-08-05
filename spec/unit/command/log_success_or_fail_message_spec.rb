# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require 'spec_helper'
require "vagrant-tun/command"

describe VagrantTun::Command do
  # create a fake app and env to pass into the VagrantTun::Command constructor
  let(:app) { lambda { |env| } }
  let(:env) { { :ui => ui } }

  # pretend env contains the Vagrant ui element
  let(:ui) do
    double('ui').tap do |ui|
      allow(ui).to receive(:info) { nil }
      allow(ui).to receive(:error) { nil }
    end
  end

  # instantiate class of which a method is to be tested
  subject { described_class.new(app, env) }

  # the method that we are going to test
  describe "#log_success_or_fail_message" do

    context "when success is true" do
      it "logs the success message" do
        # Check that the success message was logged
        expect(ui).to receive(:info).once.with("Ensured the TUN module is loaded into the kernel.")

	# Check that the failure message was not logged
        expect(ui).to receive(:error).never

        # perform the success call
        subject.log_success_or_fail_message(env, true)
      end
    end

    context "when success is false" do
      it "logs the failure message" do
        # Check that the failure message was logged
        expect(ui).to receive(:error).once.with("Failed to load the TUN/TAP adapter. If you are running a custom kernel make sure you have the tun module enabled.")

	# Check that the success message was not logged
        expect(ui).to receive(:info).never

        # perform the failure call
        subject.log_success_or_fail_message(env, false)
      end
    end
  end
end
