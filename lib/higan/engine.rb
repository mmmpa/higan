module Higan
  class Engine < ::Rails::Engine
    isolate_namespace Higan

    config.generators do |g|
      g.assets false
      g.helper false
      g.view false

      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false
      g.fixture_replacement :factory_girl,
                            dir: 'spec/factories'
    end

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
