class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3510stable.tar.gz"
  version "3.51.0"
  sha256 "6ac6aed12c6d26e8a6b06f995a95ad24a9f2d29db021c050812db2da4e61196e"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logtalk"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "04fbbd64c5ec6392153a313d455155b58e7f008d056d333484223f34c441483a"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
