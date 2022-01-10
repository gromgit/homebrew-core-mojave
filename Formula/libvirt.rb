class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-7.10.0.tar.xz"
  sha256 "cb318014af097327928c6e3d72922e3be02a3e6401247b2aa52d9ab8e0b480f9"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libvirt"
    sha256 mojave: "b2163b6efd00e892f299ec51a26a66aaa7aafa33e4dc11328cd2aa28ab79964b"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "libtirpc"
  end

  # Don't generate accelerator command line on macOS
  #
  # This makes it once again possible to use the
  #
  #   <qemu:commandline>
  #     <qemu:arg value='-machine'/>
  #     <qemu:arg value='q35,accel=hvf'/>
  #   </qemu:commandline>
  #
  # workaround to enable hardware acceleration.
  #
  # Drop once proper HVF support is added to libvirt.
  #
  # https://gitlab.com/libvirt/libvirt/-/issues/147
  patch do
    url "https://gitlab.com/abologna/libvirt/-/commit/da138afc3609a92d473fddcffa54b2020759f986.diff"
    sha256 "4eb3c9f0ca140a4d8eb5002acde0b6f1234011f82df7d8cc85252be35e8a5cff"
  end

  def install
    mkdir "build" do
      args = %W[
        --localstatedir=#{var}
        --mandir=#{man}
        --sysconfdir=#{etc}
        -Ddriver_esx=enabled
        -Ddriver_qemu=enabled
        -Ddriver_network=enabled
        -Dinit_script=none
        -Dqemu_datadir=#{Formula["qemu"].opt_pkgshare}
      ]
      system "meson", *std_meson_args, *args, ".."
      system "meson", "compile"
      system "meson", "install"
    end
  end

  service do
    run [opt_sbin/"libvirtd", "-f", etc/"libvirt/libvirtd.conf"]
    keep_alive true
    environment_variables PATH: HOMEBREW_PREFIX/"bin"
  end

  test do
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
