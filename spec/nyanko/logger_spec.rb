require "spec_helper"
require "stringio"

module Nyanko
  describe Logger do
    around do |example|
      origin, Rails.logger = Rails.logger, ::Logger.new(io)
      example.run
      Rails.logger = origin
    end

    let(:io) do
      StringIO.new
    end

    let(:log) do
      io.string.rstrip
    end

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

    context "when Config.enable_logger is true" do
      around do |example|
        origin, Config.enable_logger = Config.enable_logger, true
        example.run
        Config.enable_logger = origin
      end

      context "when given Exception" do
        it "parses and logs it" do
          described_class.debug(exception)
          log.should == lines.join("\n")
        end

        context "when Config.backtrace_limit is configured" do
          around do |example|
            origin, Config.backtrace_limit = Config.backtrace_limit, 5
            example.run
            Config.backtrace_limit = origin
          end

          it "prints backtrace up to configured depth" do
            described_class.debug(exception)
            log.should == lines[0..5].join("\n")
          end
        end
      end

      context "when given String" do
        it "adds prefix" do
          described_class.debug("test")
          log.should == "  [Nyanko] test"
        end
      end
    end

    context "when Config.enable_logger is false" do
      around do |example|
        origin, Config.enable_logger = Config.enable_logger, false
        example.run
        Config.enable_logger = origin
      end

      it "logs nothing" do
        described_class.debug("test")
        log.should == ""
      end
    end
  end
end
