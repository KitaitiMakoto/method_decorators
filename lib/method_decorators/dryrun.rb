require 'method_decorators'

module MethodDecorators
  class Dryrun < Decorator
    DEFAULT_OPTIONS = {
      :when   => :dryrun?,
      :output => $stderr
    }

    def initialize(options={})
      options = DEFAULT_OPTIONS.merge(options)
      @when   = options[:when]
      @output = options[:output]
    end

    def call(orig, this, *args, &blk)
      if this.respond_to? @when and this.__send__(@when)
        message = "DRYRUN: #{orig.name}"
        if @output.respond_to? :puts
          @output.puts message
        elsif @output.respond_to? :info
          @output.info message
        else
          warn "Unsupported type of output: #{@output.class}"
          $stderr.puts message
        end
        return
      end
      orig.call(*args, &blk)
    end
  end
end
