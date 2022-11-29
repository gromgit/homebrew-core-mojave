class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "7ab7785a277f96acd8b645dc70769adf0cc92546dac356639852bff1d708275f"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ksh93"
    sha256 cellar: :any_skip_relocation, mojave: "27466ddc80bda0ce8f13a5710fb59cd49aa1b8ef4db06372fc8ca49b002ab30c"
  end

  def install
    system "bin/package", "verbose", "make"
    system "bin/package", "verbose", "install", prefix
    %w[ksh93 rksh rksh93].each do |alt|
      bin.install_symlink "ksh" => alt
      man1.install_symlink "ksh.1" => "#{alt}.1"
    end
    doc.install "ANNOUNCE"
    doc.install %w[COMPATIBILITY README RELEASE TYPES].map { |f| "src/cmd/ksh93/#{f}" }
  end

  test do
    system "#{bin}/ksh93 -c 'A=$(((1./3)+(2./3)));test $A -eq 1'"
  end
end
