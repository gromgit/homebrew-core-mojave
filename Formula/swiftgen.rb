class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen/archive/6.5.1.tar.gz"
  sha256 "bcd52ddc581eea94070eaaab7b94218971f7424b7800696f6be0a1accfc7a0a9"
  license "MIT"
  head "https://github.com/SwiftGen/SwiftGen/archive/develop.tar.gz"

  depends_on "ruby" => :build if MacOS.version <= :sierra
  depends_on xcode: ["13.0", :build]
  depends_on :macos

  resource("testdata") do
    url "https://github.com/SwiftGen/SwiftGen/archive/6.5.1.tar.gz"
    sha256 "bcd52ddc581eea94070eaaab7b94218971f7424b7800696f6be0a1accfc7a0a9"
  end

  def install
    # Install bundler (needed for our rake tasks)
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development", "release"

    # Disable linting
    ENV["NO_CODE_LINT"] = "1"

    # Install SwiftGen in `libexec` (because of our resource bundle)
    # Then create a script to invoke it
    system "bundle", "exec", "rake", "cli:install[#{libexec}]"
    bin.write_exec_script "#{libexec}/swiftgen"
  end

  test do
    # prepare test data
    resource("testdata").stage testpath
    fixtures = testpath/"Sources/TestUtils/Fixtures"
    test_command = lambda { |command, template, resource_group, generated, fixture, params = nil|
      assert_equal(
        (fixtures/"Generated/#{resource_group}/#{template}/#{generated}").read.strip,
        shell_output("#{bin}/swiftgen run #{command} " \
                     "--templateName #{template} #{params} #{fixtures}/Resources/#{resource_group}/#{fixture}").strip,
        "swiftgen run #{command} failed",
      )
    }

    system bin/"swiftgen", "--version"

    #                 command     template             rsrc_group  generated            fixture & params
    test_command.call "colors",   "swift5",            "Colors",   "defaults.swift",    "colors.xml"
    test_command.call "coredata", "swift5",            "CoreData", "defaults.swift",    "Model.xcdatamodeld"
    test_command.call "files",    "structured-swift5", "Files",    "defaults.swift",    ""
    test_command.call "fonts",    "swift5",            "Fonts",    "defaults.swift",    ""
    test_command.call "ib",       "scenes-swift5",     "IB-iOS",   "all.swift",         "", "--param module=SwiftGen"
    test_command.call "json",     "runtime-swift5",    "JSON",     "all.swift",         ""
    test_command.call "plist",    "runtime-swift5",    "Plist",    "all.swift",         "good"
    test_command.call "strings",  "structured-swift5", "Strings",  "localizable.swift", "Localizable.strings"
    test_command.call "xcassets", "swift5",            "XCAssets", "all.swift",         ""
    test_command.call "yaml",     "inline-swift5",     "YAML",     "all.swift",         "good"
  end
end
