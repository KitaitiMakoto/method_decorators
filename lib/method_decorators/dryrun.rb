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
        @output.puts "DRYRUN: #{orig.name}"
        return
      end
      orig.call(*args, &blk)
    end
  end
end
