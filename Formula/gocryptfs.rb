class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.3/gocryptfs_v2.3_src-deps.tar.gz"
  sha256 "945e3287311547f9227f4a5b5d051fd6df8b8b41ce2a65f424de9829cc785129"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f384f63c39b0ce1fabb815e8efb6a14f06cd75d051b7f62ef041058a13fdd369"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "./build.bash"
    bin.install "gocryptfs", "gocryptfs-xray/gocryptfs-xray"
    man1.install "Documentation/gocryptfs.1", "Documentation/gocryptfs-xray.1"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
