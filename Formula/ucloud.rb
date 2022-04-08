class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.37.tar.gz"
  sha256 "91c8153854b102dcd671c58976e35b056b3ed32258a6daea3755c8cb35aed742"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ucloud"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "90c8539f028136421baa277546da2a3b68bbf415d0489b02fefbfc980f28cc9f"
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
