class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.1.tar.gz"
  sha256 "be619fe870249e74f52076d16020808b6020fedf2b98685f7c14145a291a2fe7"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/berglas"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9c6d325897ff96f3395e7981bbee8f8a8a48469c626f6e02af104151cedefe97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
