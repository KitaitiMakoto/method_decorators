class Dryrun < MethodDecorator
  def call(orig, this, *args, &blk)
    if this.respond_to? :dryrun? and this.dryrun?
      $stderr.puts "DRYRUN: #{orig.name}"
      return
    end
    orig.call(*args, &blk)
  end
end
