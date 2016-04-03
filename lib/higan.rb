require 'higan/engine'
require 'pp'

module Higan
  # module
  autoload :Configuration, 'higan/configuration'
  autoload :Renderer, 'higan/renderer'
  autoload :Connector, 'higan/connector'
  autoload :Presenter, 'higan/presenter'

  # class
  autoload :Target, 'higan/target'
  autoload :Rendered, 'higan/rendered'

  # helper
  autoload :ConfigurationReceiver, 'higan/configuration_receiver'

  include Configuration
  include Renderer
  include Connector
  include Presenter
end
