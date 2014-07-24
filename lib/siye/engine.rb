module Siye
  class Engine < ::Rails::Engine
    isolate_namespace Siye
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
    end
  end
end