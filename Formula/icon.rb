class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.22c.tar.gz"
  version "9.5.22c"
  sha256 "d3f9fd75994cfc7419c6ed1d872d0cc334dab3e20f6494776abd48b7cda43022"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/icon"
    sha256 cellar: :any_skip_relocation, mojave: "6fa0b1bf8af2c7a03df6d68fc363f5cfed9e61afeacc6e1286cdd0ac3d876bf2"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "posix"
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
