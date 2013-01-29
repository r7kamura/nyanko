require "spec_helper"

module Nyanko
  describe ExceptionHandler do
    let(:exception) do
      exception = Exception.new("error message")
      exception.set_backtrace(20.times.map {|i| "test.rb:#{i + 1}:in `method#{i + 1}'" })
      exception
    end

    let(:lines) do
      <<-EOS.strip_heredoc.split("\n").map {|line| "  #{line}" }
        [Nyanko] Exception - error message
        [Nyanko]   test.rb:1:in `method1'
        [Nyanko]   test.rb:2:in `method2'
        [Nyanko]   test.rb:3:in `method3'
        [Nyanko]   test.rb:4:in `method4'
        [Nyanko]   test.rb:5:in `method5'
        [Nyanko]   test.rb:6:in `method6'
        [Nyanko]   test.rb:7:in `method7'
        [Nyanko]   test.rb:8:in `method8'
        [Nyanko]   test.rb:9:in `method9'
        [Nyanko]   test.rb:10:in `method10'
      EOS
    end

    it "logs exception as debug level" do
      Rails.logger.should_receive(:debug).with(lines.join("\n"))
      described_class.handle(exception)
    end

    context "when Config.raise_error is truthy" do
      around do |example|
        origin, Config.raise_error = Config.raise_error, true
        example.run
        Config.raise_error = origin
      end

      it "raises up error" do
        expect { described_class.handle(exception) }.to raise_error
      end
    end

    describe "when Config.backtrace_limit is configured" do
      around do |example|
        origin, Config.backtrace_limit = Config.backtrace_limit, 5
        example.run
        Config.backtrace_limit = origin
      end

      it "prints backtrace up to configured depth" do
        Rails.logger.should_receive(:debug).with(lines[0..5].join("\n"))
        described_class.handle(exception)
      end
    end

    describe "when Config.enable_logger is false" do
      around do |example|
        origin, Config.enable_logger = Config.enable_logger, false
        example.run
        Config.enable_logger = origin
      end

      it "does not print log" do
        Rails.logger.should_not_receive(:debug)
        described_class.handle(exception)
      end
    end
  end
end
