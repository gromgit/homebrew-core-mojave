class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.20/krb5-1.20.1.tar.gz"
  sha256 "704aed49b19eb5a7178b34b2873620ec299db08752d6a8574f95d41879ab8851"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/krb5"
    sha256 cellar: :any_skip_relocation, mojave: "57bbccb7c046a45c59452666d5ff7837b53862517cda8e2b87b0b0471b47bed6"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "libedit"

  def install
    cd "src" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-nls",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
