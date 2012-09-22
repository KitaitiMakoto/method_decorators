class Dryrun < MethodDecorator
  class << self
    attr_accessor :current_instance
  end

  attr_accessor :method_name

  def initialize
    self.class.current_instance = self
  end

  def call(orig, this, *args, &blk)
    if this.respond_to? :dryrun? and this.dryrun?
      $stderr.puts "DRYRUN: #{method_name}"
      return
    end
    orig.call(*args, &blk)
  end
end

module MethodDecorators
  alias method_decorators_method_added method_added
  def method_added(name)
    method_decorators_method_added(name)
    Dryrun.current_instance.method_name = name if Dryrun.current_instance
  end
end
