require "spec_helper"
require "nyanko/test"

module Nyanko
  describe Test do
    let(:view) do
      Class.new(ActionView::Base) do
        include Nyanko::Invoker
        include Nyanko::Helper
        include Nyanko::UnitProxyProvider
      end.new
    end

    describe "#enable_unit" do
      it "forces to enable specified unit" do
        enable_unit(:inactive_unit)
        view.invoke(:inactive_unit, :inactive, :type => :plain).should == "inactive"
      end
    end

    describe "#disable_unit" do
      it "forces to disable specified unit" do
        disable_unit(:example_unit)
        view.invoke(:example_unit, :test).should == nil
      end
    end
  end
end
