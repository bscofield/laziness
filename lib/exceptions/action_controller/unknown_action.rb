module ActionController
  class UnknownAction
    def test
      return "
def test_#{@controller}_should_have_the_action_#{@action}
  assert @controller.action_methods.include?('#{@action}')
end
"
    end

    def spec
      return "
describe #{@controller} do
  it \"should have the action #{@action}\" do
    @controller.action_methods.should include('#{@action}')
  end
end
"
    end
  end
end
