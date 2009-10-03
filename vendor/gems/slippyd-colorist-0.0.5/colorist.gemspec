# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'colorist'
  s.version = '0.0.5'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh", "oleg dashevskii", "Slippy Douglas"]
  s.date = '2009-10-03'
  s.description = %q{Colorist is a library built to handle the easy conversion and manipulation of colors with a special emphasis on W3C standards and CSS-style hex color notation.}
  s.email = %q<michael@intridea.com>
  s.extra_rdoc_files = [
    "MIT_LICENSE.rdoc",
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
    "CHANGELOG.rdoc",
    "MIT_LICENSE.rdoc",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "colorist.gemspec",
    "lib/colorist.rb",
    "lib/colorist/color.rb",
    "lib/colorist/core_extensions.rb"
  ]
  s.homepage = %q<http://github.com/slippyd/colorist>
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = '1.3.3'
  s.summary = %q{A library built to handle the easy conversion and simple manipulation of colors.}
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 4
    
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
