class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17.4/aide-0.17.4.tar.gz"
  sha256 "c81505246f3ffc2e76036d43a77212ae82895b5881d9b9e25c1361b1a9b7a846"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aide"
    sha256 cellar: :any, mojave: "d45c73e602e3905a18109334e8c9b688a60c8b65313ea15defaf21a1451caeef"
  end

  head do
    url "https://github.com/aide/aide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-lfs
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
      --prefix=#{prefix}
    ]

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<~EOS
      database_in = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      report_summarize_changes = yes
      report_grouped = yes
      log_level = info
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
