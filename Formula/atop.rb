class Atop < Formula
  desc "Advanced system and process monitor for Linux using process events"
  homepage "https://www.atoptool.nl"
  url "https://github.com/Atoptool/atop/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "7b8800757a491e962897cc16172a8f5afc7f7f35d80a36c137d2b637d9f8635d"
  license "GPL-2.0-or-later"
  head "https://github.com/Atoptool/atop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c71e2895dadf8776c08590290c3a24e589a849dc96eba7e0a3539699d450915"
  end

  depends_on :linux
  depends_on "linux-headers@5.15"
  depends_on "ncurses"
  depends_on "zlib"

  def install
    if build.head?
      inreplace "version.h" do |s|
        s.sub!(/"$/, "-#{Utils.git_short_head}\"")
      end
    end
    # As this project does not use configrue, we have to configure manually:
    ENV["BINPATH"] = bin.to_s
    ENV["SBINPATH"] = bin.to_s
    ENV["MAN1PATH"] = man1.to_s
    ENV["MAN5PATH"] = man5.to_s
    ENV["MAN8PATH"] = man8.to_s
    ENV["DEFPATH"] = "prev"
    ENV["LOGPATH"] = "prev"
    # It would try to install some files suid, which is not good for users:
    inreplace "Makefile", "chmod", "true"
    # RPM and Debian packages do not use the Makefile for users, but it ensures we forget nothing:
    system "make", "-e", "genericinstall"
  end

  test do
    assert_match "Version:", shell_output("#{bin}/atop -V")
    system "#{bin}/atop", "1", "1"
    system "#{bin}/atop", "-w", "atop.raw", "1", "1"
    system "#{bin}/atop", "-r", "atop.raw", "-PCPU,DSK"
  end
end
