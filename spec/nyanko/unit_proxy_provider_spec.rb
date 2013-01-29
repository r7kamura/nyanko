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

      context "when Config.proxy_method_name is configured" do
        around do |example|
          origin, Config.proxy_method_name = Config.proxy_method_name, :proxy
          example.run
          Config.proxy_method_name = origin
        end

        it "change this method name with it" do
          proxy = view.proxy(:example_unit)
          proxy.should be_a UnitProxy
          view.should be_respond_to(:proxy)
        end
      end
    end
  end
end
