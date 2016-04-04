require 'higan/engine'
require 'pp'

module Higan
  # module
  autoload :Configuration, 'higan/configuration'
  autoload :Base, 'higan/base'

  # class
  autoload :Target, 'higan/target'
  autoload :Rendered, 'higan/rendered'

  # helper
  autoload :ConfigurationReceiver, 'higan/configuration_receiver'

  include Configuration
  include Base
end
