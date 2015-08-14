Gem::Specification.new do |s|
  s.name = 'password_feedback'
  s.version = '1.0'
  s.authors = ['Martin Tournoij']
  s.email = ['martin@arp242.net']
  s.license = 'MIT'
  s.homepage = 'https://github.com/bluerail/password_feedback'
  s.summary = "Better password feedback"

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'README.markdown']

  s.add_dependency 'coffee-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'sugar-rails'
  s.add_dependency 'sass'
  s.add_dependency 'formtastic'
  s.add_dependency 'formtastic-bootstrap'
end
