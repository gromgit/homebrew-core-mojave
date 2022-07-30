class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3570stable.tar.gz"
  version "3.57.0"
  sha256 "6ab16f5a5aca15ac638a5eeca24ec3489a7388d1961fc0de483b315c1b45c942"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logtalk"
    sha256 cellar: :any_skip_relocation, mojave: "73975750033dc259d4e1efbdd8138cff66335dcbf13b11dd9fea5a86f5dff790"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
