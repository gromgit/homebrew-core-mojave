class Carina < Formula
  desc "Command-line client for Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        tag:      "v2.1.3",
        revision: "2b3ec267e298e095d7c2f81a2d82dc50a720e81c"
  license "Apache-2.0"
  head "https://github.com/getcarina/carina.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "90280ee4749e9e92f90a215418485a9dc1ded4d2ced295f333979f914459dfbf"
    sha256 cellar: :any_skip_relocation, catalina:    "5dbb4ecd46d4ad1c33e7eea143dc2a0e56c85674a5e372e66f80b895375fbf13"
    sha256 cellar: :any_skip_relocation, mojave:      "4db2ef26df674487552ac898f0b844407041b7326925a4d60370e57f81bc6bdb"
    sha256 cellar: :any_skip_relocation, high_sierra: "33040c78e42a9611b87dda596e8a346c028b2ad84d8a4ba5cf2a12800e693ab8"
    sha256 cellar: :any_skip_relocation, sierra:      "ee6c8cdf2eddda983618f7de29bf3bcc7e81d8d9a7085a037d67cd7cdb25377a"
    sha256 cellar: :any_skip_relocation, el_capitan:  "34086f8b3418d96c3ee5c2f50ad5ffc7ee839fd26b36d0e8911c364a8c82586e"
    sha256 cellar: :any_skip_relocation, yosemite:    "0706998cd1dc286030e20382ac69a96c744ec558784685f769aa4276966dcd12"
  end

  disable! date: "2021-02-20", because: :unsupported

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV.prepend_create_path "PATH", buildpath/"bin"

    carinapath = buildpath/"src/github.com/getcarina/carina"
    carinapath.install Dir["{*,.git}"]

    cd carinapath do
      system "make", "get-deps"
      system "make", "local", "VERSION=#{version}"
      bin.install "carina"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/carina", "--version"
  end
end
