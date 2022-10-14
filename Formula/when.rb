class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.44.tar.gz"
  sha256 "de8334d97a106b9e3aad42d0a169e46e276db0935b3e4239403730eadcb41cbb"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/when"
    sha256 cellar: :any_skip_relocation, mojave: "63155f7606d0225a1c48c8d801dc8f48201da7cd7fe1c723c7fd9e108acae0bf"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
