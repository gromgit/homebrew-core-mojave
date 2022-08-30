class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.15.tar.gz"
  sha256 "4735b1d32e3f91c7a8896741d88a3022e89730a1ee897946decfa0df27039ac6"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mosquitto"
    sha256 mojave: "372f1c963502c1c89729c976b3f33a167b4008cde161e260fba9838e243ffb8f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DWITH_PLUGINS=OFF",
                    "-DWITH_WEBSOCKETS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
  end

  def post_install
    (var/"mosquitto").mkpath
  end

  def caveats
    <<~EOS
      mosquitto has been installed with a default configuration file.
      You can make changes to the configuration by editing:
          #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  service do
    run [opt_sbin/"mosquitto", "-c", etc/"mosquitto/mosquitto.conf"]
    keep_alive false
    working_dir var/"mosquitto"
  end

  test do
    quiet_system "#{sbin}/mosquitto", "-h"
    assert_equal 3, $CHILD_STATUS.exitstatus
    quiet_system "#{bin}/mosquitto_ctrl", "dynsec", "help"
    assert_equal 0, $CHILD_STATUS.exitstatus
    quiet_system "#{bin}/mosquitto_passwd", "-c", "-b", "/tmp/mosquitto.pass", "foo", "bar"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
