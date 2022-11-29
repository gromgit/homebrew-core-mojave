class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.22e.tar.gz"
  version "9.5.22e"
  sha256 "e09ab5a7d4f10196be0e7ca12624c011cd749fc93e50ad4ed87bd132d927c983"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/icon"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a0ae25e55f0d0f20b281496e37b123541bba5eaef43da856537161863b9f86e2"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "macintosh"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
