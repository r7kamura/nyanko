require "spec_helper"

module Nyanko
  describe Unit do
    let(:unit) do
      Module.new { include Nyanko::Unit }
    end

    describe ".scope" do
      specify "given scope is recorded to used scope list" do
        unit.scope(:view) { }
        unit.scopes.keys.should == [ActionView::Base]
      end

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
        unit.scopes[ActionView::Base][:test].call.should == "test"
      end
    end

    describe ".shared" do
      it "stroes given block with given label" do
        unit.shared(:test) do
          "test"
        end
        unit.shared_methods[:test].call.should == "test"
      end
    end
  end
end
