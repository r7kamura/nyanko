require "spec_helper"

module Nyanko
  describe Loader do
    describe ".load" do
      context "when existent unit name is passed" do
        it "loads unit in units directory and returns the Module" do
          described_class.load(:example_unit).should == ExampleUnit
        end
      end

      context "when non-existent unit name is passed" do
        it "returns nil" do
          described_class.load(:non_existent_unit).should == nil
        end
      end
    end
  end
end
