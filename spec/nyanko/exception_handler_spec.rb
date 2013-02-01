require "spec_helper"

module Nyanko
  describe ExceptionHandler do
    let(:sensitive_unit) do
      Loader.load(:sensitive_unit)
    end

    let(:insensitive_unit) do
      Loader.load(:insensitive_unit)
    end

    let(:error) do
      Exception.new
    end

    context "when Config.raise_error is false" do
      it "raises up no error" do
        expect { described_class.handle(error, insensitive_unit) }.not_to raise_error
      end
    end

    context "when Config.raise_error is true" do
      before do
        Config.raise_error = true
      end

      it "raises up error" do
        expect { described_class.handle(error, insensitive_unit) }.to raise_error
      end
    end

    context "when unit.raise_error is configured" do
      it "raises up error" do
        expect { described_class.handle(error, sensitive_unit) }.to raise_error
      end
    end
  end
end
