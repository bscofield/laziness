require File.join(File.dirname(__FILE__), 'lib', 'laziness')

ActionController::Rescue.send(:include, Laziness::ActionController::Rescue)
ActionController::Rescue.send(:alias_method_chain, :rescue_action_locally, :laziness)
