class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.2.tar.gz"
  sha256 "73924c22993baa98ed9310f9c4f7a004b3bf565a3a9b031f003f2d50ba662fda"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/caire"
    sha256 cellar: :any_skip_relocation, mojave: "c74e746da1cd7e7badc29a72dc8b67242ead6187ccd704011100371f53df56c4"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    pid = fork do
      system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
            "-width=1", "-height=1", "-perc=1"
      assert_predicate testpath/"test_out.png", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  ensure
    Process.kill("HUP", pid)
  end
end
