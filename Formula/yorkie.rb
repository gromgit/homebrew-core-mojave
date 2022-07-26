class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.12",
    revision: "d25124e51efcfc23125cdbba9c231b11cd57cc7a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yorkie"
    sha256 cellar: :any_skip_relocation, mojave: "f8d18e85633e64bf79c7fedea2d06ceeb81555c4c20f9a922c13c5d58f4ec1a3"
  end

  depends_on "go" => :build

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

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
