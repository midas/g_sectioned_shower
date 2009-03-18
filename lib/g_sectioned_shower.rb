$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module GSectionedShower
  VERSION = '1.0.2'
end

if defined?( ActionView::Base )
  ActionView::Base.send( :include, GSectionedShower::ViewHelpers ) unless ActionView::Base.include?( GSectionedShower::ViewHelpers )
end