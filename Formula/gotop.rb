class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.3.tar.gz"
  sha256 "c0a02276e718b988d1220dc452063759c8634d42e1c01a04c021486c1e61612d"
  license "BSD-3-Clause"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gotop"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fb99aa322b3467eef65a12dd871a079ccdec164db34c5593fe4590885c9f5872"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.BuildDate=#{time.strftime("%Y%m%dT%H%M%S")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    on_macos do
      assert_predicate testpath/"Library/Application Support/gotop/gotop.conf", :exist?
    end
    on_linux do
      assert_predicate testpath/".config/gotop/gotop.conf", :exist?
    end
  end
end
