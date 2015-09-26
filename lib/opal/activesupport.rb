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
    'tempfile'
].each do |stub|
  Opal::Processor.stub_file stub
end

