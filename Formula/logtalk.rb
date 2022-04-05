class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3540stable.tar.gz"
  version "3.54.0"
  sha256 "6ccb72bd08a44ce28b75fb4a9f74fd34f7a1f4f57a0ba6158b876cf04c0cb34a"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logtalk"
    sha256 cellar: :any_skip_relocation, mojave: "ab3607d4056de827e08863176ce0899a74c54d8f43d0b443e5da278b01406b4a"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
