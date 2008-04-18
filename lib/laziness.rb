module Laziness
  module ExceptionNotifier
    ::ExceptionNotifier.sections << 'laziness' if File.exists?("#{RAILS_ROOT}/vendor/plugins/exception_notification/init.rb")
  end
  
  module ActionController
    module Rescue
      def rescue_action_locally_with_laziness(exception)
        exception.set_context_data(request, params,  session.instance_variable_get(:@data))
        add_variables_to_assigns
        @template.instance_variable_set("@exception", exception)
        @template.instance_variable_set("@rescues_path", File.dirname(rescues_path("stub")))
        @template.send!(:assign_variables_from_controller)

        contents  = @template.render_file(template_path_for_local_rescue(exception), false)
        test      = "
<h2 style='margin-top:30px;'>Laziness Test</h2>

<pre>
#{exception.exhibit_laziness}
</pre>
"
        
        @template.instance_variable_set("@contents", contents + test)

        response.content_type = Mime::HTML
        render_for_file(rescues_path("layout"), response_code_for_rescue(exception))
      end
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'exceptions', '**', '*.rb')).each {|f| require f} 