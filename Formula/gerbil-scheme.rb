class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.17.tar.gz"
  sha256 "1e81265aba7e9022432649eb26b2e5c85a2bb631a315e4fa840b14cf336b2483"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/vyzo/gerbil.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gerbil-scheme"
    rebuild 1
    sha256 mojave: "2828d6a5b3c122c4aecf9766a0577ef1e948cad31306a8ad5d62a6b0a1bd1f9f"
  end

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@1.1"

  def install
    cd "src" do
      ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
      system "./configure", "--prefix=#{prefix}",
                            "--with-gambit=#{Formula["gambit-scheme"].opt_prefix}/current",
                            "--enable-leveldb",
                            "--enable-libxml",
                            "--enable-libyaml",
                            "--enable-lmdb"
      system "./build.sh"
      system "./install"

      mv "#{share}/emacs/site-lisp/gerbil", "#{share}/emacs/site-lisp/gerbil-scheme"
    end
  end

  test do
    assert_equal "0123456789", shell_output("gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
