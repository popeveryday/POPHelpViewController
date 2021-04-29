Pod::Spec.new do |s|
s.name             = "POPHelpViewController"
s.version          = "0.2.3"
s.summary          = "POPFormTable is cutom UITableViewController that support generate some common input field for Object-c project."
s.homepage         = "https://github.com/popeveryday/POPHelpViewController"
s.license          = 'MIT'
s.author           = { "popeveryday" => "popeveryday@gmail.com" }
s.source           = { :git => "https://github.com/popeveryday/POPHelpViewController.git", :tag => s.version.to_s }
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'Pod/Classes/**/*.{h,m,c}'
s.dependency 'POPLib', '~> 0.1'
s.dependency 'POPAppRater', '~> 0.1'
s.dependency 'POPOrientationNavigationVC', '~> 0.1'
s.dependency 'AFNetworking', '~> 2.5'
end
