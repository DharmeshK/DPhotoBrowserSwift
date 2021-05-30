Pod::Spec.new do |s|
  s.name             = 'DPhotoBrowserSwift'
  s.version          = '1.0'
  s.summary          = 'A simple iOS photo and video browser with optional grid view, captions and selections.'
  
  s.description      = <<-DESC
                        DPhotoBrowserSwift can display one or more images or videos by providing either UIImage
                        objects, PHAsset objects, web images/videos or local files.
                        The photo browser handles the downloading and caching of photos from the web seamlessly.
                        Photos can be zoomed and panned, and optional (customisable) captions can be displayed.
                       DESC

  s.homepage         = 'https://github.com/DharmeshK/DPhotoBrowserSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DK' => 'jdbtechs@gmail.com' }
  s.source           = { :git => 'https://github.com/DharmeshK/DPhotoBrowserSwift.git', :tag => s.version }

  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.1', '5.2', '5.3']
  s.source_files = 'DPhotoBrowserSwift/Classes/**/*'
  
   s.resource_bundles = {
     'DPhotoBrowserSwift' => ['DPhotoBrowserSwift/Assets/*.png']
   }
   s.requires_arc = true
   
   s.frameworks = 'UIKit'
   s.dependency 'MBProgressHUD'
   s.dependency 'SDWebImage'
   s.dependency 'DACircularProgress'
#   s.dependency 'MapleBacon'
   
end
