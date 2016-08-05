# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require 'spec_helper'
require "vagrant-tun/command"

describe VagrantTun::Command do
  # create a fake app and env to pass into the VagrantTun::Command constructor
  let(:app) { lambda { |env| } }
  let(:env) { { } }

  # Call the method under test after every 'it'. Similar to setUp in Python TestCase
  after do
    subject.ensure_tun_available(env)
  end

  # instantiate class of which a method is to be tested
  subject { described_class.new(app, env) }

  # the method that we are going to test
  describe "#ensure_tun_available" do

    context "when ensuring tun available" do
      it "tries all the strategies to get the TUN adapter in an available state and can fail" do
        # check if iter_verify_adapter is called and pretend it returned false
        expect(subject).to receive(:iter_verify_adapter).with(env).and_return(false)
        # check log_success_or_fail_message is called
        expect(subject).to receive(:log_success_or_fail_message).with(env, false)
      end

      it "tries all the strategies to get the TUN adapter in an available state and can succeed" do
        # check if iter_verify_adapter is called and pretend it returned true
        expect(subject).to receive(:iter_verify_adapter).with(env).and_return(true)
        # check log_success_or_fail_message is called
        expect(subject).to receive(:log_success_or_fail_message).with(env, true)
      end
    end
  end
end

