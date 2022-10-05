class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.3",
      revision: "12fa410a14b2759617c6df2ff9088bc79b3ee8de"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/serialosc"
    rebuild 1
    sha256 cellar: :any, mojave: "77077e75e59d0eb93fcfe0c5f66d3b5ab04c648cd20df0ecfd8b7eac091e8660"
  end

  depends_on "python@3.10" => :build
  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  on_linux do
    depends_on "avahi"
    depends_on "systemd" # for libudev
  end

  def install
    python3 = "python3.10"
    system python3, "./waf", "configure", "--enable-system-libuv", "--prefix=#{prefix}"
    system python3, "./waf", "build"
    system python3, "./waf", "install"
  end

  service do
    run [opt_bin/"serialoscd"]
    keep_alive true
    log_path var/"log/serialoscd.log"
    error_log_path var/"log/serialoscd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
