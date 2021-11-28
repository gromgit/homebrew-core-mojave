class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "d360eaf61ad4216ee2c4a4d583d61c8ec7367b5efbe512011d049f73e4f24952"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/librespot"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ec2b2e06dbb5142ec0ca8da6a0bfede8c68bb9cbbc247ac716a9ca0fa3514d27"
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
