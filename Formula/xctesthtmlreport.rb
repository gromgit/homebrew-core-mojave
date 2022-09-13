class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.2.3.tar.gz"
  sha256 "675c46efa869b1b6d21dce5c58d740999a65e2ab0c8a0dd3762988080f4e709d"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb73c9527f1127b456a979cd86abc91f03268f0edd17a4482b25de82d955f846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46760c2f0606a76cdb739c58d8f3561eb44983fcaef7b4dbd7f8d680ee657ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "a973866444d0edc34188722f4fea8dc7d65cf030a5f3cee0fb5ea7e1b51d8bc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1e9a9758be2f30d19d96d29e79d5287bd28c89dbc30cd39bd696b622511681"
  end

  depends_on :macos
  depends_on xcode: "13.0"
  uses_from_macos "swift"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/tylervick/XCTestHTMLReport/sanity-xcresult/Tests/XCTestHTMLReportTests/Resources/SanityResults.xcresult.tar.gz"
    sha256 "ce574435d6fc4de6e581fa190a8e77a3999f93c4714582226297e11c07d8fb66"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
  end

  test do
    resource("homebrew-testdata").stage("SanityResult.xcresult")
    # It will generate an index.html file
    system "#{bin}/xchtmlreport", "-r", "SanityResult.xcresult"
    assert_predicate testpath/"index.html", :exist?
  end
end
