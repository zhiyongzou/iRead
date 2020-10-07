
Pod::Spec.new do |spec|

  spec.name         = "DTFoundation"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of DTFoundation."
  spec.author       = { "zzyong" => "zouzhiyong@corp.netease.com" }
  spec.homepage     = "https://github.com/zhiyongzou"
  spec.source       = { :git => "https://github.com/zhiyongzou", :tag => spec.version.to_s }
  spec.source_files = "DTFoundation/*.{h,m}"
  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true
  
  spec.subspec 'DTHTMLParser' do |spec|
    spec.source_files = "DTFoundation/DTHTMLParser/*.{h,m}"
  end
  
end
