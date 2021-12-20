class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.4.3.tar.xz"
  sha256 "488729eb93190336b6bca10de0d78ecb7919f77fcab105debc0a644aa7d0a506"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/knot-resolver"
    sha256 mojave: "dd61bd867b6ce0f18783ea039b179aa141cd48ba1f1ade63516b3fc168f35328"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit-openresty"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = std_meson_args + ["--default-library=static"]
    args << "-Dsystemd_files=enabled" if OS.linux?

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  plist_options startup: true
  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    working_dir var/"knot-resolver"
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
