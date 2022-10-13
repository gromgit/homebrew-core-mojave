class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3580stable.tar.gz"
  version "3.58.0"
  sha256 "ac2c9dcbacdcd24ffe411cfa2dbbbab10e6b2a6075dc49f6ed19c534dd79c38e"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logtalk"
    sha256 cellar: :any_skip_relocation, mojave: "499fe3deac24fc533aae0ab4956e0119cecce96c5440037a59c7c30a7d235205"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
