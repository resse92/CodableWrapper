#!/usr/bin/env ruby

SDK = `xcrun --show-sdk-path`.strip!
CONFIGURATION = ENV['CONFIGURATION'].downcase
TOOLCHAIN = ENV['TOOLCHAIN']
SRCROOT = ENV['SRCROOT']
BUILD_DIR = ENV['BUILD_DIR']

PRODUCT_NAME = "CodableWrapperMacros"
SCRATCH_PATH = "#{BUILD_DIR}/Macros/CodableWrapperMacros"
puts "swift build --configuration #{CONFIGURATION} --product #{PRODUCT_NAME} --sdk \"#{SDK}\" --toolchain \"#{TOOLCHAIN}\" --package-path \"#{SRCROOT}\" --scratch-path \"#{SCRATCH_PATH}\""

system("swift build --configuration #{CONFIGURATION} --product #{PRODUCT_NAME} --sdk \"#{SDK}\" --toolchain \"#{TOOLCHAIN}\" --package-path \"#{SRCROOT}\" --scratch-path \"#{SCRATCH_PATH}\"")

PLUGIN_PATH = "#{SCRATCH_PATH}/#{CONFIGURATION}/#{PRODUCT_NAME}"
# 如果plugin_path不存在，找${plugin_path}-tool
if !File.exist?(PLUGIN_PATH)
    TOOL_PLUGIN_PATH = "#{PLUGIN_PATH}-tool"
    if File.exist?(TOOL_PLUGIN_PATH)
        # create a symbolic link to the plugin
        system("ln -s #{TOOL_PLUGIN_PATH} #{PLUGIN_PATH}")
    end
end
