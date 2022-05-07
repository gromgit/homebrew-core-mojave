class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.21.1/znapzend-0.21.1.tar.gz"
  sha256 "1b438816a9a647a5bb3282ad26a6a8cd3ecce0a874f2fb506cbc156527e188f7"
  license "GPL-3.0-or-later"
  head "https://github.com/oetiker/znapzend.git", branch: "master"

  # The `stable` URL uses a download from the GitHub release, so the release
  # needs to exist before the formula can be version bumped. It's more
  # appropriate to check the GitHub releases instead of tags in this context.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/znapzend"
    sha256 cellar: :any_skip_relocation, mojave: "d63d23bebd1bbbd200180d686f7967356baa9bf3c7f752c068fc9aaf588b29eb"
  end

  uses_from_macos "perl", since: :big_sur

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var/"log/znapzend").mkpath
    (var/"run/znapzend").mkpath
  end

  plist_options startup: true
  service do
    run [opt_bin/"znapzend", "--connectTimeout=120", "--logto=#{var}/log/znapzend/znapzend.log"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/znapzend.err.log"
    log_path var/"log/znapzend.out.log"
    working_dir var/"run/znapzend"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~EOS
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end
