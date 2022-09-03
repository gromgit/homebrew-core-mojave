class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/v0.1.40.tar.gz"
  sha256 "fb6cdd5e7291a0439d9ec5cc5403cbfa1b504fa92c576ba7acdfb2d561d92b40"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ucloud"
    sha256 cellar: :any_skip_relocation, mojave: "b9be8bcb0e42179990f709c474d5438e1136d7ce94ee711872d83a335e47697b"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
