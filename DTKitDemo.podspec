Pod::Spec.new do |s|
    s.name         = 'DTKit'
    s.version      = '1.0'
    s.summary      = 'An small framework'
    s.homepage     = 'https://github.com/veamia/DTKit'
    s.license      = 'MIT'
    s.authors      = {'veamia' => 'veamia@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/veamia/DTKit.git', :tag => s.version}
    s.source_files = 'DTKit/**/*.{h,m}'
    s.requires_arc = true
end
