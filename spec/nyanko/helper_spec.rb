require "spec_helper"

module Nyanko
  describe Helper do
    describe ".define" do
      after do
        described_class.class_eval do
          remove_method :__example_unit_test rescue nil
        end
      end

      let(:view) do
        Class.new { include Nyanko::Helper }.new
      end

      it "defines helper methods with special prefix" do
        described_class.define(:example_unit) do
          def test
            "test"
          end
        end
        view.__example_unit_test.should == "test"
      end
    end
  end
end
