class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.1.0.tar.gz"
  sha256 "5af8f1111f9ec1da9a818978eb1f013dfd50ad4311c79d95b0e62ad428ac1c59"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hut"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7e798cd20d8d2c3c6d61fd857aec37d8761dc23bdc6db9fce6b48752f9127f7a"
  end

  depends_on "coreutils" => :build # Needed for GNU install in 0.1.0, remove in next release
  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall"
  end

  test do
    (testpath/"config").write <<~EOS
      instance "sr.ht" {
          access-token "some_fake_access_token"
      }
    EOS
    assert_match "Authentication error: Invalid OAuth bearer token",
      shell_output("#{bin}/hut --config #{testpath}/config todo list 2>&1", 1)
  end
end
