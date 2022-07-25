class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 6

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oscats"
    sha256 cellar: :any, mojave: "cf9f67522efe3a6a7a654b7bec1aa2b5a01b7c2b575be9d0355a11278c3997ec"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "gsl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Fix issue with conflicting definitions of select on Linux.
  # Patch submitted to discussion group:
  # https://groups.google.com/g/oscats/c/WZ7gRjkxmIk.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples"
    # Fix shim references in examples Makefile.
    if OS.mac?
      inreplace pkgshare/"examples/Makefile",
        Superenv.shims_path/"pkg-config",
        Formula["pkg-config"].opt_bin/"pkg-config"
    else
      inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
    end
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs oscats glib-2.0").chomp.split
    system ENV.cc, pkgshare/"examples/ex01.c", *pkg_config_flags, "-o", "ex01"
    assert_match "Done", shell_output("#{testpath}/ex01")
  end
end

__END__
diff --git a/src/liboscats/algorithms/closest_diff.c b/src/liboscats/algorithms/closest_diff.c
index 86f7f2f..97de5d9 100644
--- a/src/liboscats/algorithms/closest_diff.c
+++ b/src/liboscats/algorithms/closest_diff.c
@@ -175,7 +175,7 @@ static gdouble criterion(const OscatsItem *item, OscatsExaminee *e,
   return oscats_model_distance(model, theta, e->covariates);
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   return oscats_alg_chooser_choose(OSCATS_ALG_CLOSEST_DIFF(alg_data)->chooser,
@@ -194,7 +194,7 @@ static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
   OscatsAlgClosestDiff *self = OSCATS_ALG_CLOSEST_DIFF(alg_data);
   self->chooser->bank = g_object_ref(test->itembank);
   self->chooser->criterion = (OscatsAlgChooserCriterion)criterion;
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
 }
                    
diff --git a/src/liboscats/algorithms/max_fisher.c b/src/liboscats/algorithms/max_fisher.c
index 16c8b39..0835bf6 100644
--- a/src/liboscats/algorithms/max_fisher.c
+++ b/src/liboscats/algorithms/max_fisher.c
@@ -265,7 +265,7 @@ static gdouble criterion(const OscatsItem *item,
     // max det[sum I_j(theta)] <==> min -det[sum I_j(theta)]
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   OscatsAlgMaxFisher *self = OSCATS_ALG_MAX_FISHER(alg_data);
@@ -298,7 +298,7 @@ static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
 
   g_signal_connect_data(test, "initialize", G_CALLBACK(initialize),
                         alg_data, oscats_algorithm_closure_finalize, 0);
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
   g_object_ref(alg_data);
 }
diff --git a/src/liboscats/algorithms/max_kl.c b/src/liboscats/algorithms/max_kl.c
index ac9a53e..95c74a3 100644
--- a/src/liboscats/algorithms/max_kl.c
+++ b/src/liboscats/algorithms/max_kl.c
@@ -623,7 +623,7 @@ static gdouble criterion(const OscatsItem *item,
                                  alg_data);
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   OscatsAlgMaxKl *self = OSCATS_ALG_MAX_KL(alg_data);
@@ -661,7 +661,7 @@ static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
 
   g_signal_connect_data(test, "initialize", G_CALLBACK(initialize),
                         alg_data, oscats_algorithm_closure_finalize, 0);
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
   g_object_ref(alg_data);
 }
diff --git a/src/liboscats/algorithms/pick_rand.c b/src/liboscats/algorithms/pick_rand.c
index 1e66758..ef6234c 100644
--- a/src/liboscats/algorithms/pick_rand.c
+++ b/src/liboscats/algorithms/pick_rand.c
@@ -35,7 +35,7 @@ static void oscats_alg_pick_rand_init (OscatsAlgPickRand *self)
 {
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   guint i, item = 0;
@@ -55,7 +55,7 @@ static gint select (OscatsTest *test, OscatsExaminee *e,
  */
 static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
 {
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
 }
                    
