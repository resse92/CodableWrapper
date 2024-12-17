#!/usr/bin/env ruby

SDK = `xcrun --show-sdk-path`.strip!
CONFIGURATION = ENV['CONFIGURATION'].downcase
TOOLCHAIN = ENV['TOOLCHAIN']
SRCROOT = ENV['SRCROOT']
BUILD_DIR = ENV['BUILD_DIR']

puts "swift build --configuration #{CONFIGURATION} --product CodableWrapperMacros --sdk \"#{SDK}\" --toolchain \"#{TOOLCHAIN}\" --package-path \"#{SRCROOT}\" --scratch-path \"#{BUILD_DIR}/Macros/CodableWrapperMacros\""

system("swift build --configuration #{CONFIGURATION} --product CodableWrapperMacros --sdk \"#{SDK}\" --toolchain \"#{TOOLCHAIN}\" --package-path \"#{SRCROOT}\" --scratch-path \"#{BUILD_DIR}/Macros/CodableWrapperMacros\"")
