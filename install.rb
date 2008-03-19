require 'fileutils'

root_path = File.dirname(__FILE__)
puts IO.read(File.join(root_path, 'README'))

if File.exists?(File.join(root_path, '..', 'exception_notification', 'views', 'exception_notifier', 'exception_notification.rhtml'))
  # copy laziness partial into exception notifier directory
  laziness_view_path  = File.join(root_path, 'views', '_laziness.rhtml')
  notifier_views_path = File.join(root_path, '..', 'exception_notification', 'views', 'exception_notifier', '_laziness.rhtml')
  FileUtils.copy laziness_view_path, notifier_views_path
end