def gem(*args)
  puts "Ignoring gem method call with #{args}"
end

require 'active_support/test_case'
ActiveSupport::TestCase.test_order = :sorted
