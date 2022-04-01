class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpio"
    sha256 mojave: "3f2619bd6e9fac2b58323cfe99d1234fb9a50aa30f310e5c2ac81fafce4faa4c"
  end

  keg_only :shadowed_by_macos, "macOS provides cpio"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    return if OS.mac?

    # Delete rmt, which causes conflict with `gnu-tar`
    (libexec/"rmt").unlink
    (man8/"rmt.8").unlink
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
    EOS
    system "ls #{testpath} | #{bin}/cpio -ov > #{testpath}/directory.cpio"
    assert_path_exists "#{testpath}/directory.cpio"
  end
end
