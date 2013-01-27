require "spec_helper"

module Nyanko
  describe Invoker do
    let(:view) do
      Class.new(ActionView::Base) do
        include Nyanko::Invoker
        include Nyanko::Helper
        include Nyanko::UnitProxyProvider
      end.new
    end

    let(:controller) do
      Class.new(ActionController::Base) do
        include Nyanko::Invoker
        include Nyanko::Helper
        include Nyanko::UnitProxyProvider
      end.new
    end

    describe "#invoke" do
      it "invokes defined function for current context" do
        view.invoke(:example_unit, :test).should == "test"
      end

      it "invokes in the same context with receiver" do
        view.invoke(:example_unit, :self).should == view
      end

      it "invokes with locals option" do
        view.invoke(:example_unit, :locals, :locals => { :key => "value" }).should == "value"
      end

      it "invokes with short-hand style locals option" do
        view.invoke(:example_unit, :locals, :key => "value").should == "value"
      end

      it "invokes with shared method" do
        view.invoke(:example_unit, :shared).should == "shared args"
      end

      it "invokes with helper method in view context" do
        view.invoke(:example_unit, :helper).should == "helper"
      end

      context "when non-existent unit is specified" do
        it "does nothing" do
          view.invoke(:non_existent_unit, :test).should == nil
        end
      end

      context "when dependent unit is inactive" do
        it "does nothing" do
          view.invoke(:example_unit, :test, :if => :inactive_unit).should == nil
        end
      end

      context "when 2 functions are specified" do
        it "invokes first active function" do
          view.invoke([:inactive_unit, :inactive], [:example_unit, :test]).should == "test"
        end
      end

      context "when an error is raised in invoking" do
        context "when block is given" do
          context "when context is a view" do
            it "captures given block as a fallback" do
              view.should_receive(:capture).and_call_original
              view.invoke(:example_unit, :error) { "error" }.should == "error"
            end
          end

          context "when context is not a view" do
            it "calls given block as a fallback" do
              controller.should_not_receive(:capture)
              controller.invoke(:example_unit, :error) { "error" }.should == "error"
            end
          end
        end

        context "when no block is given" do
          it "rescues the error and does nothing" do
            view.invoke(:example_unit, :error).should == nil
          end
        end
      end
    end
  end
end
