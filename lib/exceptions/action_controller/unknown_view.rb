module Laziness
  module Exceptions
    module ActionController
      class UnknownAction
        def self.test(exception, method, params, session)
          controller = params.delete(:controller)
          controller_class = "#{controller}_controller".classify
          action     = params.delete(:action)

          if File.exists?("#{RAILS_ROOT}/spec/spec_helper.rb")
# TODO: validate that this spec works as expected
            return "
describe \"Lazy #{controller_class}\" do
  it \"should have the action #{action}\" do
    #{controller_class}.action_methods.should include('#{action}')
  end
end
" 
          else
            return "
def test_#{controller_class.downcase}_should_have_the_action_#{action}
  assert #{controller_class}.action_methods.include?('#{action}')
end
"

# TODO: add extra tests around routing and recognition?
          end
        end
      end
    end
  end
end