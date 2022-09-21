class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.14.0",
      revision: "4db350b05e3f1bcb8de0e039a13c4df6e7d55caa"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bac43c0bbe8da2e4529d3fa86c159296d8903fa49886ada7d5acb64b0d945b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8138c460c3c89fae4ebd1d7ab0e1424c34470446c1543d315dbf2b511bea921c"
    sha256 cellar: :any_skip_relocation, monterey:       "929ee94b5ac4611eb10b7272f853e99c1c07b9a827f4a01993202a2ef8240635"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebfcc191c2a183d093f105a0be12d12d7be6257859805ae7450a3f6811d5d6e5"
    sha256 cellar: :any_skip_relocation, catalina:       "5cbdb95374051a247b58695278983a45ab05d64571c6399a7853aa6b187940c2"
    sha256                               x86_64_linux:   "c0d7cd27e73e5de977d1e8d61cd2ac9283c5249307368ba532eff6cd58a69ad2"
  end

  depends_on xcode: ["11.4", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
