class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.16.4.tar.gz"
  sha256 "245ba47a6b8ae8e9a9df1c055e90f22f944a7d1219416cb30268881d0c0d377b"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xmrig"
    sha256 mojave: "28588809c8d672ed1e70c2467aa451cbb45c54b79418ec388fb8a2f535abcbf1"
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_CN_GPU=OFF", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    require "pty"
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server = "donotexist.localhost:65535"
    output = ""
    args = %W[
      --no-color
      --max-cpu-usage=1
      --print-time=1
      --threads=1
      --retries=1
      --url=#{test_server}
    ]
    PTY.spawn(bin/"xmrig", *args) do |r, _w, pid|
      sleep 5
      Process.kill("SIGINT", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match(/POOL #1\s+#{Regexp.escape(test_server)} algo auto/, output)
    pattern = "#{test_server} DNS error: \"unknown node or service\""
    if OS.mac?
      assert_match pattern, output
    else
      assert_match Regexp.union(pattern, "#{test_server} connect error: \"connection refused\""), output
    end
  end
end
