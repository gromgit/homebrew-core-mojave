class Envchain < Formula
  desc "Secure your credentials in environment variables"
  homepage "https://github.com/sorah/envchain"
  url "https://github.com/sorah/envchain/archive/v1.0.1.tar.gz"
  sha256 "09af1fe1cfba3719418f90d59c29c081e1f22b38249f0110305b657bd306e9ae"
  license "MIT"
  head "https://github.com/sorah/envchain.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/envchain"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a621eda3b41da7dcffc3da7f8043ab1351c12e5740943f5435e7a359142efc02"
  end


  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "readline"
  end

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match "envchain version #{version}", shell_output("#{bin}/envchain 2>&1", 2)
  end
end
