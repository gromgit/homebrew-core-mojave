class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.13.3.tar.gz"
  sha256 "817dad2f25303d835789c889bf2fac5e141ad2442b9f75da7b164650f0de3fee"
  license "MIT"
  head "https://github.com/Masterminds/glide.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glide"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c8ffda24daab4c5a1cac238803111f0d64504e4eb20a0137bdd65c9d8d33659b"
  end

  # See: https://github.com/Masterminds/glide/commit/c64b14592409a83052f7735a01d203ff1bab0983
  deprecate! date: "2021-01-02", because: :deprecated_upstream

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    glidepath = buildpath/"src/github.com/Masterminds/glide"
    glidepath.install buildpath.children

    cd glidepath do
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glide --version")
    system bin/"glide", "create", "--non-interactive", "--skip-import"
    assert_predicate testpath/"glide.yaml", :exist?
  end
end
