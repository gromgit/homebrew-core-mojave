class Dosfstools < Formula
  desc "Tools to create, check and label file systems of the FAT family"
  homepage "https://github.com/dosfstools"
  url "https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz"
  sha256 "64926eebf90092dca21b14259a5301b7b98e7b1943e8a201c7d726084809b527"
  license "GPL-3.0-or-later"
  head "https://github.com/dosfstools/dosfstools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dosfstools"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "30208e7eef516fa86196f31e0aed61f5e225d1fd2e21c1443ee25d9cc45bd9fb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  # remove in next release
  # https://github.com/dosfstools/dosfstools/pull/158
  patch do
    url "https://github.com/dosfstools/dosfstools/commit/8a917ed2afb2dd2a165a93812b6f52b9060eec5f.patch?full_index=1"
    sha256 "73019e3f7852158bfe47a0105eb605b4df4a10ca50befc02adf50aed11bd4445"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--without-udev",
                          "--enable-compat-symlinks"
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=test.bin", "bs=512", "count=1024"
    system "#{sbin}/mkfs.fat", "test.bin", "-n", "HOMEBREW", "-v"
    system "#{sbin}/fatlabel", "test.bin"
    system "#{sbin}/fsck.fat", "-v", "test.bin"
  end
end
