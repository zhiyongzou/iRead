
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
  spec.resource_bundles = { 'DTCoreText': 'DTCoreText/default.css' }

  spec.subspec 'Accessibility' do |spec|
    spec.source_files = "DTCoreText/Accessibility/*.{h,m}"
  end

  spec.subspec 'Debug' do |spec|
    spec.source_files = "DTCoreText/Debug/*.{h,m}"
  end

  spec.subspec 'HTMLParsing' do |spec|
    spec.source_files = "DTCoreText/HTMLParsing/*.{h,m}", 
    spec.source_files = "DTCoreText/HTMLParsing/DTHTMLElement/*.{h,m}",
    spec.source_files = "DTCoreText/HTMLParsing/DTTextAttachment/*.{h,m}",
    spec.source_files = "DTCoreText/HTMLParsing/DualPlatform/*.{h,m}"
  end

  spec.subspec 'HTMLWriting' do |spec|
    spec.source_files = "DTCoreText/HTMLWriting/*.*"
  end

  spec.subspec 'Layouting' do |spec|
    spec.source_files = "DTCoreText/Layouting/*.{h,m}"
  end

  spec.subspec 'UI' do |spec|
    spec.source_files = "DTCoreText/UI/*.{h,m}"
  end

  spec.subspec 'Utils' do |spec|
    spec.source_files = "DTCoreText/Utils/*.{h,m}"
  end
  
end
