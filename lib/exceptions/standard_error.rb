class StandardError
  attr_accessor :test_name, :method, :action, :params, :session, :flash, :controller, :action
  
  def exhibit_laziness
    File.exists?("#{RAILS_ROOT}/spec/spec_helper.rb") ? self.spec : self.test
  end
  
  def set_context_data(request, params = {}, session = {})
    self.controller = params.delete(:controller)
    self.action     = params.delete(:action)
    self.params     = params || {}
    self.flash      = session.delete('flash') || {}
    self.session    = session

    test_name = [self.method, self.controller, self.action, 'should not raise', self.class.name, 'exception'].join(' ')
    self.test_name = test_name.downcase.gsub(/[^\w\d]/, '_').squeeze('_')
  end

  # override these methods in specific exception subclasses
  def test
    return "
def test_#{@test_name}
  assert_nothing_raised(#{self.class.name}) do
    #{@method} :#{@action}, #{@params.inspect}, #{@session.inspect}, #{@flash.inspect}
  end
end
"
  end

  def spec
    return "
describe \"Handling #{@method.upcase} #{@controller} #{@action}\" do
  it \"should not raise #{self.class.name}\" do
    lambda { 
      #{@method} :#{@action}, #{@params.inspect}, #{@session.inspect}, #{@flash.inspect}
    }.should_not raise_error(#{self.class.name})
  end
end
"
  end
end