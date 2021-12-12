class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.2.tar.gz"
  sha256 "f6bf7065ec99e48766f60a126590e021f5bd4fac19754ecb2d90eaf106f4e39b"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kepubify"
    sha256 cellar: :any_skip_relocation, mojave: "4a56eab3076231d28e70c600e7890d9b27633421011ee90b9046b576b131359c"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
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
