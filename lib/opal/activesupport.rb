require 'opal'
require 'opal/activesupport/version'

# Just register our opal code path with opal build tools
Opal.append_path File.expand_path('../../../opal', __FILE__)
Opal.append_path File.expand_path('../../../rails/activesupport/lib', __FILE__)

[
    # not in opal stdlib
    'mutex_m',
    'thread_safe',
    'logger',
    'i18n',
    # unicode/incompatible regex
    'active_support/core_ext/string/output_safety',
    'tempfile',
    'bigdecimal', # not in opal stdlib yet, GEMs use C extensions
    'bigdecimal/util',
    'tzinfo',
    # Uses mutex
    'active_support/notifications/fanout',
    # see above
    'active_support/notifications',
    # no i18n stdlib
    'active_support/i18n',
    # Uses kernel.caller and backtrace line #, etc.
    'active_support/deprecation'
].each do |stub|
  Opal::Processor.stub_file stub
end

# TODO: Bundle if it changes a lot
Opal.use_gem 'rubysl-rational'
