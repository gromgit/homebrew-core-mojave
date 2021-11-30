class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.67.0.tar.gz"
  sha256 "97c9ee6f28efd621f04ff4bafa269d4f7f6632f5884178f443a22cb610e086a7"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/doctl"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9c37ec663b12a3b07228fe4ef4d56fd8cc5b7748b5d760555d5820daf780303d"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
