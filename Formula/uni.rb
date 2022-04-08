class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.4.0.tar.gz"
  sha256 "d9caa7753983a42588beb3e7016987928fe8cd1e1d8c3728dc1e441dc27abba7"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uni"
    sha256 cellar: :any_skip_relocation, mojave: "a40259521498bedb3c5cfdf2384c5c73165ec6043d48c31db9c78fca492c48c9"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
