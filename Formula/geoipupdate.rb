class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.9.0.tar.gz"
  sha256 "43195d457a372dc07be593d815212d6ea21e499a37a6111058efa3296759cba9"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/geoipupdate"
    rebuild 1
    sha256 mojave: "bc1907a73b8bd9cb25720f4de21975610f273e95e25d55daf6667d87c8da7152"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
