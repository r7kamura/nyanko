require "spec_helper"

module Nyanko
  describe ExceptionHandler do
    context "when Config.raise_error is truthy" do
      before do
        Config.raise_error = true
      end

      it "raises up error" do
        expect { described_class.handle(Exception.new) }.to raise_error
      end
    end
  end
end
