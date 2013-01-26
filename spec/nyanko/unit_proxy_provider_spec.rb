require "spec_helper"

module Nyanko
  describe UnitProxyProvider do
    let(:view) do
      Class.new { include Nyanko::UnitProxyProvider }.new
    end

    describe "#unit" do
      context "when given unit name" do
        it "returns proxy for specified unit" do
          proxy = view.unit(:example_unit)
          proxy.should be_a UnitProxy
          proxy.unit.should == ExampleUnit
        end

        context "when unit is not found" do
          it "raises NoUnitError" do
            expect { view.unit(:non_existent_unit) }.to raise_error(described_class::NoUnitError)
          end
        end
      end

      context "when given no unit name" do
        before do
          Function.units << Loader.load(:example_unit)
        end

        after do
          Function.units.pop
        end

        it "returns proxy for the top unit of current unit stack" do
          proxy = view.unit
          proxy.unit.should == ExampleUnit
        end
      end
    end
  end
end
