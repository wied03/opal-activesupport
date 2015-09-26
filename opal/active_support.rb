module ActiveSupport
  module Autoload
    def eager_autoload
    end
  end
end

# this is in stdlib, but we can't get around it, seems to be mimic'ing a hash, so do this for now
class ThreadSafe
  class Cache < Hash
  end
end
