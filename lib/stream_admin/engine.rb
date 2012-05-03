module StreamAdmin
  class Engine < ::Rails::Engine
    isolate_namespace StreamAdmin
    
    config.streamadmin = ActiveSupport::OrderedOptions.new
  end
end
