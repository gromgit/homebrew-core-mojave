class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.2.0.tar.gz"
  sha256 "2a4e49458a2cb129055f1db3b835e111a89583f47d4d917110205113863492b9"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hut"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ffe191cc986e2e9c7723e428d7e46605287424896358cd2328c01249e93792c7"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
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
