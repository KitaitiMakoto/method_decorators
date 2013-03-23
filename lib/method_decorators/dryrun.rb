require 'method_decorators'

module MethodDecorators
  class Dryrun < Decorator
    DEFAULT_OPTIONS = {
      :predicate => :dryrun?,
      :output    => $stderr
    }

    def initialize(options={})
      options = DEFAULT_OPTIONS.merge(options)
      @predicate = options[:predicate]
      @output =    options[:output]
    end

    def call(orig, this, *args, &blk)
      if this.respond_to? @predicate and this.__send__(@predicate)
        @output.puts "DRYRUN: #{orig.name}"
        return
      end
      orig.call(*args, &blk)
    end
  end
end
