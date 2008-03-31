module Laziness
  module Exceptions
    module ActionController
      class RoutingError
        def self.test(exception, method, params, session)
          path = exception.message.match(/".+?"/)[0]
          if File.exists?("#{RAILS_ROOT}/spec/spec_helper.rb")
            return "
describe \"Routing\" do
  it \"should recognize #{path.gsub(/"/, "'")}\" do
    params_from(:#{method}, #{path}).should == {:controller => '', :action => ''}
  end
end
" 
          else
            return "
def test_path_should_be_recognized_as_valid_route
  assert_routing #{path}, {:controller => '', :action => ''}
end
"
          end
        end
      end
    end
  end
end