class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/sphinxsearch/sphinx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sphinx"
    sha256 mojave: "3929be4971f968c3db0c67873f39e4a1ab953ff8143b7e49ebbd162a92489db4"
  end

  # Ref: https://github.com/sphinxsearch/sphinx#sphinx
  deprecate! date: "2022-08-15", because: "is using unsupported v2 and source for v3 is not publicly available"

  depends_on "mysql@5.7"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "manticoresearch", because: "manticoresearch is a fork of sphinx"

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        revision: "9b58e92c965cd7e3208247ace3cc00d173397f3c"
  end

  patch do
    url "https://sources.debian.org/data/main/s/sphinxsearch/2.2.11-8/debian/patches/06-CVE-2020-29050.patch"
    sha256 "a52e065880b7293d95b6278f1013825b7ac52a1f2c28e8a69ed739882a4a5c3a"
  end

  def install
    resource("stemmer").stage do
      system "make", "dist_libstemmer_c"
      system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --localstatedir=#{var}
      --with-libstemmer
      --with-mysql
      --without-pgsql
    ]

    # Security fix: default to localhost
    # https://sources.debian.org/data/main/s/sphinxsearch/2.2.11-8/debian/patches/config-default-to-localhost.patch
    inreplace %w[sphinx-min.conf.in sphinx.conf.in] do |s|
      s.gsub! "9312", "127.0.0.1:9312"
      s.gsub! "9306:mysql41", "127.0.0.1:9306:mysql41"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"searchd", "--help"
  end
end
