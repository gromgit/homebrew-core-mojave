class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "https://infozip.sourceforge.io/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  license "Info-ZIP"
  revision 8

  livecheck do
    url :stable
    regex(%r{url=.*?(?:%20)?v?(\d+(?:\.\d+)+)/unzip\d+\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unzip"
    sha256 cellar: :any_skip_relocation, mojave: "aa7d2f05db310d61bf5f35c4401c0193c13a6e676bb571bdfa5989bde1046c74"
  end

  keg_only :provided_by_macos

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

  # Upstream is unmaintained so we use the Ubuntu patchset:
  # https://packages.ubuntu.com/kinetic/unzip
  patch do
    url "http://archive.ubuntu.com/ubuntu/pool/main/u/unzip/unzip_6.0-27ubuntu1.debian.tar.xz"
    sha256 "9249780437220a5dc81518f2e4c5213b502bf56899c03992572cf9bb5caf724e"
    apply %w[
      patches/01-manpages-in-section-1-not-in-section-1l.patch
      patches/02-this-is-debian-unzip.patch
      patches/03-include-unistd-for-kfreebsd.patch
      patches/04-handle-pkware-verification-bit.patch
      patches/05-fix-uid-gid-handling.patch
      patches/06-initialize-the-symlink-flag.patch
      patches/07-increase-size-of-cfactorstr.patch
      patches/08-allow-greater-hostver-values.patch
      patches/09-cve-2014-8139-crc-overflow.patch
      patches/10-cve-2014-8140-test-compr-eb.patch
      patches/11-cve-2014-8141-getzip64data.patch
      patches/12-cve-2014-9636-test-compr-eb.patch
      patches/13-remove-build-date.patch
      patches/14-cve-2015-7696.patch
      patches/15-cve-2015-7697.patch
      patches/16-fix-integer-underflow-csiz-decrypted.patch
      patches/17-restore-unix-timestamps-accurately.patch
      patches/18-cve-2014-9913-unzip-buffer-overflow.patch
      patches/19-cve-2016-9844-zipinfo-buffer-overflow.patch
      patches/20-cve-2018-1000035-unzip-buffer-overflow.patch
      patches/20-unzip60-alt-iconv-utf8.patch
      patches/21-fix-warning-messages-on-big-files.patch
      patches/22-cve-2019-13232-fix-bug-in-undefer-input.patch
      patches/23-cve-2019-13232-zip-bomb-with-overlapped-entries.patch
      patches/24-cve-2019-13232-do-not-raise-alert-for-misplaced-central-directory.patch
      patches/25-cve-2019-13232-fix-bug-in-uzbunzip2.patch
      patches/26-cve-2019-13232-fix-bug-in-uzinflate.patch
      patches/27-zipgrep-avoid-test-errors.patch
      patches/28-cve-2022-0529-and-cve-2022-0530.patch
    ]
  end

  def install
    # These macros also follow Ubuntu, and are required:
    # - to correctly handle large archives (> 4GB)
    # - extract & print archive contents with non-latin characters
    loc_macros = %w[
      -DLARGE_FILE_SUPPORT
      -DUNICODE_SUPPORT
      -DUNICODE_WCHAR
      -DUTF8_MAYBE_NATIVE
      -DNO_WORKING_ISPRINT
    ]
    args = %W[
      CC=#{ENV.cc}
      LOC=#{loc_macros.join(" ")}
      D_USE_BZ2=-DUSE_BZIP2
      L_BZ2=-lbz2
      macosx
    ]
    args << "LFLAGS1=-liconv" if OS.mac?
    system "make", "-f", "unix/Makefile", *args
    system "make", "prefix=#{prefix}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    if OS.mac?
      system "/usr/bin/zip", "test.zip", "test1", "test2", "test3"
    else
      system Formula["zip"].bin/"zip", "test.zip", "test1", "test2", "test3"
    end
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system bin/"unzip", "test.zip"
    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_match "Hello!", File.read(testpath/"test1")
    assert_match "Bonjour!", File.read(testpath/"test2")
    assert_match "Hej!", File.read(testpath/"test3")
  end
end
