module Laziness
  module ExceptionNotifier
    ::ExceptionNotifier.sections << 'laziness' if File.exists?("#{RAILS_ROOT}/vendor/plugins/exception_notification/init.rb")
  end
  
  module ActionController
    module Rescue
      def rescue_action_locally_with_laziness(exception)
        add_variables_to_assigns
        @template.instance_variable_set("@exception", exception)
        @template.instance_variable_set("@rescues_path", File.dirname(rescues_path("stub")))
        @template.send!(:assign_variables_from_controller)

        contents  = @template.render_file(template_path_for_local_rescue(exception), false)
        test      = "
<h2 style='margin-top:30px;'>Laziness Test</h2>

<pre>
#{Laziness.generate_test(exception, request.method.to_s, params, session.instance_variable_get(:@data), cookies)}
</pre>
"
        
        @template.instance_variable_set("@contents", contents + test)

        response.content_type = Mime::HTML
        render_for_file(rescues_path("layout"), response_code_for_rescue(exception))
      end
    end
  end

  def self.generate_test(exception, method, params = {}, session = {}, cookies = {})
    controller = params.delete(:controller)
    action     = params.delete(:action)
    params     = params || {}
    flash      = session.delete('flash') || {}
    
    test_name = [method, controller, action, 'should not raise', exception.class.name, 'exception'].join(' ')
    test_name = test_name.downcase.gsub(/[^\w\d]/, '_').squeeze('_')

    if File.exists?("#{RAILS_ROOT}/spec/spec_helper.rb")
      return "
describe \"Handling #{method.upcase} #{controller} #{action}\" do
  it \"should not raise #{exception.class.name}\" do
    lambda { 
      #{method} :#{action}, #{params.inspect}, #{session.inspect}, #{flash.inspect}
    }.should_not raise_error(#{exception.class.name})
  end
end
"
    else
      return "
def test_#{test_name}
  assert_nothing_raised(#{exception.class.name}) do
    #{method} :#{action}, #{params.inspect}, #{session.inspect}, #{flash.inspect}
  end
end
"
    end
  end
end