class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.1.tar.gz"
  sha256 "2676d646c4a9b75d3734ac49e4c27d62008bd889aad0297874d34906a526e8cc"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/caire"
    sha256 cellar: :any_skip_relocation, mojave: "cb2146930dc1d346cb1571d72f51dce0b4173f289cb52ac5000b7c89ba374ce2"
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
