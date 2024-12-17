#
# Be sure to run `pod lib lint CodableWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CodableWrapper'
  s.version          = '1.1.1'
  s.summary          = 'A short description of CodableWrapper.'

  s.description      = <<-DESC
    CodableWrapper Pod
                       DESC

  s.homepage         = 'https://github.com/winddpan/CodableWrapper'
  s.author           = { 'winddpan' => 'https://github.com/winddpan' }
  s.source           = { :git => 'git@github.com:winddpan/CodableWrapper.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'Sources/CodableWrapper/*{.swift}'
  # s.preserve_paths = ["Package.swift", "Sources/CodableWrapperMacros", "Tests", "Bin"]


  sources_dir = 'Sources'
  plugin_module = 'CodableWrapperMacros'
  manifest_file = 'Package*.swift'

  script_path = 'Utils/macro_plugin_build.rb'
  preserved_sources = "{#{manifest_file},#{sources_dir}/{#{plugin_module}}/**/*.swift,#{script_path}}"
  inputs = Dir.glob(preserved_sources).map { |path| "$(PODS_TARGET_SRCROOT)/#{path}" }
  build_path = "${PODS_BUILD_DIR}/Macros/#{plugin_module}"
  plugin_path = "#{build_path}/${CONFIGURATION}/#{plugin_module}-tool##{plugin_module}"
  plugin_output = "$(PODS_BUILD_DIR)/Macros/#{plugin_module}/$(CONFIGURATION)/#{plugin_module}"

  script = <<-SCRIPT
  echo "env -i DEVELOPER_DIR=\\"$DEVELOPER_DIR\\" PATH=\\"$PATH\\" SRCROOT=\\"$PODS_TARGET_SRCROOT\\" BUILD_DIR=\\"$PODS_BUILD_DIR\\" TOOLCHAIN=\\"$DT_TOOLCHAIN_DIR\\" CONFIGURATION=\\"$CONFIGURATION\\" \\"${PODS_TARGET_SRCROOT}/#{script_path}\\""
  env -i DEVELOPER_DIR="$DEVELOPER_DIR" PATH="$PATH" SRCROOT="$PODS_TARGET_SRCROOT" BUILD_DIR="$PODS_BUILD_DIR" TOOLCHAIN="$DT_TOOLCHAIN_DIR" CONFIGURATION="$CONFIGURATION" "${PODS_TARGET_SRCROOT}/#{script_path}"
  SCRIPT

  s.preserve_paths = ["*.md", "LICENSE", manifest_file, "#{sources_dir}/#{plugin_module}", script_path, "Tests", "Bin"]

  s.script_phase = {
    :name => 'Build CodableWrapper macro plugin',
    :script => script,
    :input_files => inputs, :output_files => [plugin_output],
    :execution_position => :before_compile
  }

  xcconfig = {
    'OTHER_SWIFT_FLAGS' => "-Xfrontend -load-plugin-executable -Xfrontend #{plugin_path}",
  }
  s.user_target_xcconfig = xcconfig
  s.pod_target_xcconfig = xcconfig
end
