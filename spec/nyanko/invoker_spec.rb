require "spec_helper"

module Nyanko
  describe Invoker do
    before do
      Loader.stub(:fetch) do |unit_name|
        case unit_name
        when :unit_a
          unit_a
        when :unit_b
          unit_b
        end
      end
    end

    let(:unit_a) do
      Module.new do
        include Nyanko::Unit

        scope(:view) do
          function(:test) do
            "test"
          end

          function(:self) do
            self
          end
        end
      end
    end

    let(:unit_b) do
      Module.new do
        include Nyanko::Unit
        active_if { false }
      end
    end

    let(:view) do
      Class.new(ActionView::Base) { include Nyanko::Invoker }.new
    end

    describe "#invoke" do
      it "invokes defined function for current context" do
        view.invoke(:unit_a, :test).should == "test"
      end

      it "invokes in the same context with receiver" do
        view.invoke(:unit_a, :self).should == view
      end

      context "when dependent unit is inactive" do
        it "does nothing" do
          view.invoke(:unit_a, :test, :if => :unit_b).should == nil
        end
      end
    end
  end
end
