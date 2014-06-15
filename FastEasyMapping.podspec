Pod::Spec.new do |s|
  s.name         = "FastEasyMapping"
  s.version      = "0.3.0"
  s.summary      = "Fast mapping from JSON to NSObject / NSManagedObject and back"
  s.homepage     = "https://github.com/Yalantis/FastEasyMapping"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Dmitriy Shemet" => "dmitriy.shemet@yalantis.com" }

  s.source       = { :git => "https://github.com/Yalantis/FastEasyMapping.git", :tag => "0.3.0" }

  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.frameworks = 'CoreData'

  s.source_files = 'FastEasyMapping/Source/**/*.{h,m}'

end
