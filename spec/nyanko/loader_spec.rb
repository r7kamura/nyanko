require "spec_helper"

module Nyanko
  describe Loader do
    describe ".load" do
      after do
        described_class.cache.clear
      end

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

      context "when loader has ever loaded specified unit" do
        it "load unit from cache" do
          described_class.any_instance.should_receive(:load_from_file).and_call_original
          described_class.load(:example_unit)
          described_class.load(:example_unit)
        end
      end

      context "when loader has ever loaded specified wrong unit" do
        before do
          described_class.cache.clear
        end

        it "load unit from cache" do
          described_class.any_instance.should_receive(:load_from_file).and_call_original
          described_class.load(:non_existent_unit)
          described_class.load(:non_existent_unit)
        end
      end
    end

    describe ".eager_load" do
      before do
        described_class.cache.clear
      end

      it "pre-loads all units in units directory" do
        described_class.eager_load
        described_class.new(:example_unit).should be_loaded
      end
    end
  end
end
