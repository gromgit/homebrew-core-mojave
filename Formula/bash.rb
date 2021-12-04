class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.1.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.1.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.1.tar.gz"
    sha256 "cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa"
    version "5.1.12"

    %w[
      001 ebb07b3dbadd98598f078125d0ae0d699295978a5cdaef6282fe19adef45b5fa
      002 15ea6121a801e48e658ceee712ea9b88d4ded022046a6147550790caf04f5dbe
      003 22f2cc262f056b22966281babf4b0a2f84cb7dd2223422e5dcd013c3dcbab6b1
      004 9aaeb65664ef0d28c0067e47ba5652b518298b3b92d33327d84b98b28d873c86
      005 cccbb5e9e6763915d232d29c713007a62b06e65126e3dd2d1128a0dc5ef46da5
      006 75e17d937de862615c6375def40a7574462210dce88cf741f660e2cc29473d14
      007 acfcb8c7e9f73457c0fb12324afb613785e0c9cef3315c9bbab4be702f40393a
      008 f22cf3c51a28f084a25aef28950e8777489072628f972b12643b4534a17ed2d1
      009 e45cda953ab4b4b4bde6dc34d0d8ca40d1cc502046eb28070c9ebcd47e33c3ee
      010 a2c8d7b2704eeceff7b1503b7ad9500ea1cb6e9393faebdb3acd2afdd7aeae2a
      011 58191f164934200746f48459a05bca34d1aec1180b08ca2deeee3bb29622027b
      012 10f189c8367c4a15c7392e7bf70d0ff6953f78c9b312ed7622303a779273ab98
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.1-patches/bash51-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.1-patches/bash51-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.1-patches/bash51-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.1-patches/bash51-#{p}"
        sha256 checksum
      end
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url "https://ftp.gnu.org/gnu/bash/?C=M&O=D"
    regex(/href=.*?bash[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :gnu do |page, regex|
      # Match versions from files
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v) }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Simply return the found versions if there isn't a patches directory
      # for the "newest" version
      patches_directory = page.match(%r{href=.*?(bash[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, patches_directory[1]).to_s)
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?bash[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bash"
    rebuild 1
    sha256 mojave: "8cdb64e214b0e22b08e02da5a4f28785abd62857b980bba7e5928c9d22844fa4"
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
