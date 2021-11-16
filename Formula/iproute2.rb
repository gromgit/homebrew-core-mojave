class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.15.0.tar.xz"
  sha256 "38e3e4a5f9a7f5575c015027a10df097c149111eeb739993128e5b2b35b291ff"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"


  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on :linux

  def install
    system "make", "install",
           "PREFIX=#{prefix}",
           "SBINDIR=#{sbin}",
           "CONFDIR=#{etc}/iproute2",
           "NETNS_RUN_DIR=#{var}/run/netns",
           "NETNS_ETC_DIR=#{etc}/netns",
           "ARPDDIR=#{var}/lib/arpd",
           "KERNEL_INCLUDE=#{include}",
           "DBM_INCLUDE=#{include}"
  end

  test do
    output = shell_output("#{sbin}/ip addr").strip
    assert_match "link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00", output
  end
end
