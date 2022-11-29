class Fcrackzip < Formula
  desc "Zip password cracker"
  homepage "http://oldhome.schmorp.de/marc/fcrackzip.html"
  url "http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz"
  sha256 "4a58c8cb98177514ba17ee30d28d4927918bf0bdc3c94d260adfee44d2d43850"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://oldhome.schmorp.de/marc/data/"
    regex(/href=.*?fcrackzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fcrackzip"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "229417920494e035c248a2faf922c2973cbff9880cd586a5601bb473a881a520"
  end

  uses_from_macos "zip" => :test

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    # Avoid conflict with `unzip` on Linux and shadowing `/usr/bin/zipinfo` on macOS
    bin.install bin/"zipinfo" => "fcrackzipinfo"
  end

  test do
    (testpath/"secret").write "homebrew"
    system "zip", "-qe", "-P", "a", "secret.zip", "secret"
    assert_match "possible pw found: a ()",
                 shell_output("#{bin}/fcrackzip -c a -l 1 secret.zip").strip
  end
end
