module ActionController
  class RoutingError
    def laziness_path
      self.message.match(/".+?"/)[0]
    end
    
    def test
      return "
def test_path_should_be_recognized_as_valid_route
  assert_routing #{laziness_path}, {:controller => 'FIXME', :action => 'FIXME'}
end
"
    end

    def spec
      return "
describe \"Routing\" do
  it \"should recognize #{laziness_path.gsub(/"/, "'")}\" do
    params_from(:#{@method}, #{laziness_path}).should == {:controller => '', :action => ''}
  end
end
"
    end
  end
end
