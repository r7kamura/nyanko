require "spec_helper"

module Nyanko
  describe Controller do
    describe ".unit_action" do
      let(:controller_class) do
        Class.new(ActionController::Base) do
          include Nyanko::Controller
          unit_action(:example_unit, :test)
          unit_action(:example_unit, :foo, :bar)
        end
      end

      let(:controller) do
        controller_class.new
      end

      it "defines an action to invoke unit function" do
        controller.test.should == "test"
      end

      it "defines 2 actions at one line" do
        controller.foo.should == "foo"
        controller.bar.should == "bar"
      end
    end
  end
end
