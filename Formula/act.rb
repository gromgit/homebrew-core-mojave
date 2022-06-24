class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.28.tar.gz"
  sha256 "010b9f02d2c431d9e09f5be1cf3099bd3fbab49043c53e34aa92b99bba8da3d1"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/act"
    sha256 cellar: :any_skip_relocation, mojave: "acf3d4932f7786b53b8f65a2c7012ecd3eb7d816d968abbeb62902173ca59bc5"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end
