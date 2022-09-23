class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.9.0.tar.gz"
  sha256 "f7bd2dbcf41b27f67797c2b51291245f64dcf4aef243df205aed22f6f321c4d7"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/run"
    sha256 cellar: :any_skip_relocation, mojave: "597042a8a1810ff01cb201084be5ae277f19e80fc32d02e269518c6f9884c62c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
