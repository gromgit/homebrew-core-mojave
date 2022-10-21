class Pwsafe < Formula
  desc "Generate passwords and manage encrypted password databases"
  homepage "https://github.com/nsd20463/pwsafe"
  url "https://src.fedoraproject.org/repo/pkgs/pwsafe/pwsafe-0.2.0.tar.gz/4bb36538a2772ecbf1a542bc7d4746c0/pwsafe-0.2.0.tar.gz"
  sha256 "61e91dc5114fe014a49afabd574eda5ff49b36c81a6d492c03fcb10ba6af47b7"
  license "GPL-2.0"
  revision 4

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/pwsafe/"
    regex(/href=.*?pwsafe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pwsafe"
    rebuild 1
    sha256 cellar: :any, mojave: "01ed5e0251f63f1ca0302dbe02ad610bddf1da39ca3e9f159a1bdb6d1931f887"
  end

  head do
    url "https://github.com/nsd20463/pwsafe.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"
  depends_on "readline"

  # A password database for testing is provided upstream. How nice!
  resource "test-pwsafe-db" do
    url "https://raw.githubusercontent.com/nsd20463/pwsafe/208de3a94339df36b6e9cd8aeb7e0be0a67fd3d7/test.dat"
    sha256 "7ecff955871e6e58e55e0794d21dfdea44a962ff5925c2cd0683875667fbcc79"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--without-x"
    system "make", "install"
  end

  test do
    test_db_passphrase = "abc"
    test_account_name = "testing"
    test_account_pass = "sg1rIWHL?WTOV=d#q~DmxiQq%_j-$f__U7EU"

    resource("test-pwsafe-db").stage do
      Utils.popen(
        "#{bin}/pwsafe -f test.dat -p #{test_account_name}", "r+"
      ) do |pipe|
        pipe.puts test_db_passphrase
        assert_match(/^#{Regexp.escape(test_account_pass)}$/, pipe.read)
      end
    end
  end
end
