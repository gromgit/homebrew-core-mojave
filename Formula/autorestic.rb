class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.3.tar.gz"
  sha256 "2e8aea01135de1e671fa1a089da227cc8f10c1dbdb9458b5c9348f99e9e360d4"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/autorestic"
    sha256 cellar: :any_skip_relocation, mojave: "9242210c50940f06bbcb95a52dfcead6081de447087481827e663f96a8f03233"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2
    File.write(testpath/".autorestic.yml", config.to_yaml)
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
