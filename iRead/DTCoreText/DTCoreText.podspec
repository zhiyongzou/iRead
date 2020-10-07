
Pod::Spec.new do |spec|

  spec.name         = "DTCoreText"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of DTCoreText."
  spec.author       = { "zzyong" => "zouzhiyong@corp.netease.com" }
  spec.homepage     = "https://github.com/zhiyongzou"
  spec.source       = { :git => "https://github.com/zhiyongzou", :tag => spec.version.to_s }
  spec.source_files = "DTCoreText/*.{h,m}"
  spec.dependency 'DTFoundation'
  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true
  
  spec.subspec 'NSAttributedString' do |spec|
    spec.source_files = "DTCoreText/NSAttributedString/*.{h,m}"
  end
  
end
