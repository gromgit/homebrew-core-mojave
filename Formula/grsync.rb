class Grsync < Formula
  desc "GUI for rsync"
  homepage "https://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.3.0.tar.gz"
  sha256 "b7c7c6a62e05302d8317c38741e7d71ef9ab4639ee5bff2622a383b2043a35fc"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grsync"
    sha256 mojave: "ec749303600ac33a8774d36000059023d554cc31f2262bb847a71b5bafb097e7"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  uses_from_macos "perl" => :build

  # Fix build with Clang.
  # https://sourceforge.net/p/grsync/code/174/
  # Remove with the next release.
  patch :DATA

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"
    chmod "+x", "install-sh"
    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert_predicate bin/"grsync", :exist?
  end
end

__END__
--- a/src/callbacks.c
+++ b/src/callbacks.c
@@ -40,12 +40,13 @@
 gboolean more = FALSE, first = TRUE;
 
 
+void _set_label_selectable(gpointer data, gpointer user_data) {
+	GtkWidget *widget = GTK_WIDGET(data);
+	if (GTK_IS_LABEL(widget)) gtk_label_set_selectable(GTK_LABEL(widget), TRUE);
+}
+
+
 void dialog_set_labels_selectable(GtkWidget *dialog) {
-	void _set_label_selectable(gpointer data, gpointer user_data) {
-		GtkWidget *widget = GTK_WIDGET(data);
-		if (GTK_IS_LABEL(widget)) gtk_label_set_selectable(GTK_LABEL(widget), TRUE);
-	}
-
 	GtkWidget *area = gtk_message_dialog_get_message_area(GTK_MESSAGE_DIALOG(dialog));
 	GtkContainer *box = (GtkContainer *) area;
 	GList *children = gtk_container_get_children(box);
