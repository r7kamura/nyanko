require "spec_helper"

module Nyanko
  describe ExceptionHandler do
    context "when Config.raise_error is truthy" do
      around do |example|
        origin, Config.raise_error = Config.raise_error, true
        example.run
        Config.raise_error = origin
      end

      it "raises up error" do
        expect { described_class.handle(Exception.new) }.to raise_error
      end
    end
  end
end
