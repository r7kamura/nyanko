require "spec_helper"

module Nyanko
  describe Invoker do
    before do
      Loader.stub(:fetch) {|unit_name| send(unit_name) }
    end

    let(:unit) do
      Module.new do
        include Nyanko::Unit

        scope(:view) do
          function(:test) do
            "test"
          end

          function(:self) do
            self
          end

          function(:locals) do
            key
          end
        end
      end
    end

    let(:inactive_unit) do
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
        view.invoke(:unit, :test).should == "test"
      end

      it "invokes in the same context with receiver" do
        view.invoke(:unit, :self).should == view
      end

      it "invokes with locals option" do
        expect { view.invoke(:unit, :locals) }.to raise_error(NameError)
        view.invoke(:unit, :locals, :locals => { :key => "value" }).should == "value"
      end

      it "invokes with short-hand style locals option" do
        view.invoke(:unit, :locals, :key => "value").should == "value"
      end

      context "when dependent unit is inactive" do
        it "does nothing" do
          view.invoke(:unit, :test, :if => :inactive_unit).should == nil
        end
      end
    end
  end
end
