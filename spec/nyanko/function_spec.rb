require "spec_helper"

module Nyanko
  describe Function do
    let(:function) do
      described_class.new(unit, :label) { current_unit }
    end

    let(:unit) do
      Module.new { include Nyanko::Unit }
    end

    let(:context) do
      Class.new do
        def current_unit
          units.last
        end

        def units
          @units ||= []
        end
      end.new
    end

    describe ".invoke" do
      it "invokes block with given context and stacked unit" do
        function.invoke(context).should == unit
      end
    end
  end
end
