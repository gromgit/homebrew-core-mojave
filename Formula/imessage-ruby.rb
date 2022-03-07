class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/imessage-ruby"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cb12f32d6e4c5a6195129bca47077ea8a4eab673949e4c3f545363df649f5d48"
  end

  depends_on :macos

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
