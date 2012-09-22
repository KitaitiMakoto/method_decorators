class Dryrun < MethodDecorator
  DEFAULT_OPTIONS = {
    :output    => $stderr
  }

  def initialize(options={})
    options = DEFAULT_OPTIONS.merge(options)
    @output =    options[:output]
  end

  def call(orig, this, *args, &blk)
    if this.respond_to? :dryrun? and this.dryrun?
      @output.puts "DRYRUN: #{orig.name}"
      return
    end
    orig.call(*args, &blk)
  end
end
