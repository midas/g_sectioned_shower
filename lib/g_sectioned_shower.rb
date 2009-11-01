$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'g_sectioned_shower/view_helpers'

module GSectionedShower
  VERSION = '1.0.7'
end

if defined?( ActionView::Base )
  ActionView::Base.send( :include, GSectionedShower::ViewHelpers ) unless ActionView::Base.include?( GSectionedShower::ViewHelpers )
end