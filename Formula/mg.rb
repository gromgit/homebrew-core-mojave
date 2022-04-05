class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-7.0/mg-7.0.tar.gz"
  sha256 "650dbdf9c9a72ec1922486ce07112d6181fc88a30770913d71d5c99c57fb2ac5"
  license all_of: [:public_domain, "ISC", :cannot_represent]
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mg"
    sha256 cellar: :any_skip_relocation, mojave: "a4b09993a42d733861a7fbb1315eb4833b4ec56aca20e0c46b061fe3801ee728"
  end

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"command.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS

    system "expect", "-f", "command.exp"
  end
end
