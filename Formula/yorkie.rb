class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.17",
    revision: "109ed36d485c92f123186e5e704a3946ca6c7db6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yorkie"
    sha256 cellar: :any_skip_relocation, mojave: "0f2267a3e56fedfa4954434bd738cc290064dd11a80d8765097fa079a90c3201"
  end

  # Doesn't build with latest go
  # See https://github.com/yorkie-team/yorkie/issues/378
  depends_on "go@1.18" => :build

  def install
    system "make", "build"
    prefix.install "bin"
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
