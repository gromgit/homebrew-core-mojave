class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3550stable.tar.gz"
  version "3.55.0"
  sha256 "401158167d18b2f6f48f1e2fa953f6398e8b7ec315c40cb42e290b33c3e0121f"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logtalk"
    sha256 cellar: :any_skip_relocation, mojave: "066ee1a60870185b40c6b5c141c5d00b58fec3d665a216abfe4c5a469e17ae4e"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
