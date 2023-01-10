class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "https://www.acme.com/software/http_load/"
  url "https://www.acme.com/software/http_load/http_load-09Mar2016.tar.gz"
  version "20160309"
  sha256 "5a7b00688680e3fca8726dc836fd3f94f403fde831c71d73d9a1537f215b4587"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?http_load[._-]v?(\d+[a-z]+\d+)\.t/i)
    strategy :page_match do |page, regex|
      # Convert date-based version from 09Mar2016 format to 20160309
      page.scan(regex).map do |match|
        date_str = match&.first
        date_str ? Date.parse(date_str)&.strftime("%Y%m%d") : nil
      end
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/http_load"
    rebuild 1
    sha256 cellar: :any, mojave: "5505011209d637489b324d9201f48c09cd1fd8871ebdb7baa04fd0359a529ceb"
  end

  depends_on "openssl@3"

  def install
    bin.mkpath
    man1.mkpath

    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
      SSL_TREE=#{Formula["openssl@3"].opt_prefix}
    ]

    inreplace "Makefile", "#SSL_", "SSL_"
    system "make", "install", *args
  end

  test do
    (testpath/"urls").write "https://brew.sh/"
    system "#{bin}/http_load", "-rate", "1", "-fetches", "1", "urls"
  end
end
