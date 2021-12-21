class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.2.0.tar.gz"
  sha256 "e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad"
  head "https://github.com/wg/wrk.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wrk"
    sha256 cellar: :any_skip_relocation, mojave: "dbcc4657c85ec23393ab96bda2e99b3c222e8dfa812bedb62d101595bfd8b7ad"
  end

  depends_on "openssl@1.1"

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "makedepend" => :build
    depends_on "pkg-config" => :build
  end

  conflicts_with "wrk-trello", because: "both install `wrk` binaries"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    system "make"
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end
