class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.4.tar.gz"
  sha256 "a3bf118a8e871b989358cb598746efd6ff4e304cba02fd2960fe35404a586ed5"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kepubify"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7aa0efb8c160ed1985bc871889a29d1fbec620eeec4858affac429630bdfe53b"
  end

  depends_on "go" => :build

  def install
    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", *std_go_args(output: bin/p, ldflags: "-s -w -X main.version=#{version}"), "./cmd/#{p}"
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", test_fixtures("test.epub")
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
