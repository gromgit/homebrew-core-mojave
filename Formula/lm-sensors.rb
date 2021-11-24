class LmSensors < Formula
  desc "Tools for monitoring the temperatures, voltages, and fans"
  homepage "https://github.com/groeck/lm-sensors"
  url "https://github.com/lm-sensors/lm-sensors/archive/V3-6-0.tar.gz"
  version "3.6.0"
  sha256 "0591f9fa0339f0d15e75326d0365871c2d4e2ed8aa1ff759b3a55d3734b7d197"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on :linux

  def install
    args = %W[
      PREFIX=#{prefix}
      BUILD_STATIC_LIB=0
      MANDIR=#{man}
      ETCDIR=#{prefix}/etc
    ]
    system "make", *args
    system "make", *args, "install"
  end

  test do
    assert_match("Usage", shell_output("#{bin}/sensors --help"))
  end
end
