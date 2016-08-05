# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require 'spec_helper'
require "vagrant-tun/command"

describe VagrantTun::Command do
  # create a fake app and env to pass into the VagrantTun::Command constructor
  let(:app) { lambda { |env| } }
  let(:env) { { } }

  # instantiate class of which a method is to be tested
  subject { described_class.new(app, env) }

  # the method that we are going to test
  describe "#iter_verify_adapter" do

    context "iterating over all strategies" do
      it "verifies the adapter with try create and succeeds" do
	# check if verify_adapter is called once and pretend it returned true
        expect(subject).to receive(:verify_adapter).once.with(env, true).and_return(true)
	# check that the machine is not rebooted
        expect(subject).to receive(:reboot).never
	# check if iter_verify_adapter returned true
	expect( subject.iter_verify_adapter(env) ).to eq(true)
      end

      it "verifies the adapter with try create and fails the first time" do
	# check if verify_adapter is called twice and pretend it returned true
        expect(subject).to receive(:verify_adapter).twice.with(env, true).and_return(false, true)
	# check that the machine is rebooted
        expect(subject).to receive(:reboot).once.with(env)
	# check if iter_verify_adapter returned true
	expect( subject.iter_verify_adapter(env) ).to eq(true)
      end

      it "verifies the adapter with try create and fails both times" do
	# check if verify_adapter is called twice and pretend it returned true
        expect(subject).to receive(:verify_adapter).twice.with(env, true).and_return(false, false)
	# check that the machine is rebooted
        expect(subject).to receive(:reboot).once.with(env)
	# check if iter_verify_adapter returned false
	expect( subject.iter_verify_adapter(env) ).to eq(false)
      end
    end
  end
end
