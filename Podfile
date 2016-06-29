# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'ChatProject' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for ChatProject
  # 提示框
  pod 'SVProgressHUD', '2.0.3'
  
  # 融云聊天
  pod 'RongCloudIMKit', '2.6.2'
  
  #Mob
  pod 'MOBFoundation_IDFA', '2.0.1' #Mob产品公共库
  pod 'SMSSDK', '2.0.4' #SMSSDK必须
  
  # 网络访问
  pod 'AFNetworking', '~>2.0'
  
  # 朋友圈
  pod 'DFCommon', '1.3.9'

  target 'ChatProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ChatProjectUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
