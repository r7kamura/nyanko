require "spec_helper"

module Nyanko
  describe Unit do
    let(:unit) do
      Module.new { include Nyanko::Unit }
    end

    describe ".scope" do
      context "in the scoped block" do
        specify "current_scope returns given scope" do
          unit.scope(:view) do
            unit.current_scope.should == ActionView::Base
          end
        end
      end

      context "out of the scoped block" do
        specify "current_scope returns nil" do
          unit.scope(:view) { }
          unit.current_scope.should == nil
        end
      end
    end

    describe ".function" do
      it "stores given block with current_scope and given label" do
        unit.scope(:view) do
          unit.function(:test) do
            "test"
          end
        end
        unit.functions[ActionView::Base][:test].call.should == "test"
      end
    end
  end
end
