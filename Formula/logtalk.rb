class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3560stable.tar.gz"
  version "3.56.0"
  sha256 "6ae4dd335fbccc8a86c20ff84d2156608ddf5e6d9c0582934bb606ec065fc56b"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logtalk"
    sha256 cellar: :any_skip_relocation, mojave: "c559f4c1b4dd5f693f75030e847e4dde4e6c05f987c47f91bfe2d0a37c95d11a"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
