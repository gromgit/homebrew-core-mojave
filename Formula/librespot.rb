class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "cc8cb81bdbaa5abf366170dec5e6b8c0ecf570a7cb68f04483e9f7eed338ca61"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/librespot"
    sha256 cellar: :any_skip_relocation, mojave: "a736bfd3951905b47d1c69ef8e750ef53e09fad4aa8cbdfe6de0eb1069936cc3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s if OS.mac?
    system "cargo", "install", "--no-default-features", "--features", "rodio-backend,with-dns-sd", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    Open3.popen3({ "RUST_LOG" => "DEBUG" }, "#{bin}/librespot", "-v") do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include? "Zeroconf server listening"
        end
      end
    ensure
      Process.kill("INT", wait_thr.pid)
    end
  end
end
