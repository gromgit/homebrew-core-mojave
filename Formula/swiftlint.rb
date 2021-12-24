class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.41.0",
      revision: "d91c2179bb55111790e7053c039d5d7a600dfa3d"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/swiftlint"
    sha256 cellar: :any_skip_relocation, mojave: "06959689b326f242240e1043efe75fb134fa70d7f4e5172f0998224d0d82db73"
  end

  depends_on xcode: ["10.2", :build]
  depends_on xcode: "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline. (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
