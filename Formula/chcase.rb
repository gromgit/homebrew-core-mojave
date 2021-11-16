class Chcase < Formula
  desc "Perl file-renaming script"
  homepage "http://www.primaledge.ca/chcase.html"
  url "http://www.primaledge.ca/chcase"
  version "2.0"
  sha256 "386e6f294157957adbd433a10591d9d78cd54d13e1347fb15a19e70f03319ed3"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1ac32a52434724c8df47fe8ba642f69f58b55c8df2dd3a5a8bc62b4cdb07758"
  end

  # add a shebang so that brew properly sets it executable
  patch :DATA

  def install
    bin.install "chcase"
  end

  test do
    system bin/"chcase", "-e"
  end
end

__END__
diff --git a/chcase b/chcase
index 689fc79..93efae8
--- a/chcase
+++ b/chcase
@@ -1,3 +1,4 @@
+#!/bin/sh -- # -*- perl -*-
 eval 'exec perl $0 ${1+"$@"}'
 if 0;
 # don't modify below here
