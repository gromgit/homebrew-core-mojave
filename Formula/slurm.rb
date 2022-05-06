class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm/wiki/"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.4.tar.gz"
  sha256 "2f846c9aa16f86cc0d3832c5cd1122b9d322a189f9e6acf8e9646dee12f9ac02"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/slurm"
    sha256 cellar: :any_skip_relocation, mojave: "bebd32e3d5c892c82120d1e1396d70dcb6e30e6ec1e3162d16f42c75ba1d2d62"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  uses_from_macos "ncurses"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    net_if = OS.mac? ? "en0" : "eth0"
    output = pipe_output("#{bin}/slurm -i #{net_if}", "q")
    assert_match "slurm", output
  end
end
