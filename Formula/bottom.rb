class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.8.tar.gz"
  sha256 "4e4eb251972a7af8c46dd36bcf1335fea334fb670569434fbfd594208905b2d9"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bottom"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "754a2ccf146f69abe71a789837f5d685990821683861333a86c860a44dd727ec"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/bottom-*/out"].first
    bash_completion.install "#{out_dir}/btm.bash"
    fish_completion.install "#{out_dir}/btm.fish"
    zsh_completion.install "#{out_dir}/_btm"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: Found argument '--invalid'", shell_output(bin/"btm --invalid 2>&1", 1)

    fork do
      exec bin/"btm", "--config", "nonexistent-file"
    end
    sleep 1
    assert_predicate testpath/"nonexistent-file", :exist?
  end
end
