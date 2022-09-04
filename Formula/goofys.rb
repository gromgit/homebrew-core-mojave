class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      tag:      "v0.24.0",
      revision: "45b8d78375af1b24604439d2e60c567654bcdf88"
  license "Apache-2.0"
  head "https://github.com/kahing/goofys.git", branch: "master"

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on "go" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kahing/goofys").install buildpath.children

    cd "src/github.com/kahing/goofys" do
      system "go", "build", "-o", "goofys", "-ldflags", "-X main.Version=#{Utils.git_head}"
      bin.install "goofys"
      prefix.install_metafiles
    end
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
    system bin/"goofys", "--version"
  end
end
