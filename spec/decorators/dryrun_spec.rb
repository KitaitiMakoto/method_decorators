require 'spec_helper'
require 'method_decorators/dryrun'

describe MethodDecorators::Dryrun do
  let(:output) { StringIO.new }
  before :each do
    $stderr = output
    MethodDecorators::Dryrun::DEFAULT_OPTIONS[:output] = output
  end

  describe "#call" do
    let(:method) { double(:method, :call => true, :name => :method) }
    subject { MethodDecorators::Dryrun.new }

    context "when this.dryrun? is false" do
      let(:this) { double(:this, :dryrun? => false) }

      it "executes the method" do
        method.should_receive(:call).once
        subject.call(method, this)
      end
    end

    context "when this.dryrun? is true" do
      let(:this) { double(:this, :dryrun? => true) }

      it "doesn't execute the method" do
        method.should_not_receive(:call)
        subject.call(method, this)
      end

      it "outputs to $stderr the message that executing dryrun" do
        output.should_receive(:puts).with("DRYRUN: method")
        subject.call(method, this)
      end
    end

    context "when the object does not respond to #dryrun?" do
      let(:this) { Object.new }

      it "executes the method" do
        method.should_receive(:call).once
        subject.call(method, this)
      end
    end

  end

  describe "acceptance" do
    let(:return_value) { "This procedure destructs something!" }
    let(:klass) do
      Class.new Base do
        +MethodDecorators::Dryrun
        def destructive_procedure
          "This procedure destructs something!"
        end
      end
    end
    subject { klass.new }

    context "when the #dryrun? is false" do
      it "executes decorated method" do
        subject.stub(:dryrun?).and_return(false)
        expect(subject.destructive_procedure).to eq(return_value)
      end
    end

    context "when the #dryrun? is true" do
      it "does not executes decorated method" do
        subject.stub(:dryrun?).and_return(true)
        expect(subject.destructive_procedure).not_to eq(return_value)
      end

      it "output dry run message to $stderr" do
        subject.stub(:dryrun?).and_return(true)
        subject.destructive_procedure
        output.rewind
        expect(output.read).to eq("DRYRUN: destructive_procedure\n")
      end
    end

    context "when the object does not respond to #dryrun?" do
      it "executes decorated method" do
        expect(subject.destructive_procedure).to eq(return_value)
      end
    end
  end
end
