class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.4.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.4.tar.gz"
  sha256 "9020396ff933693e310b479b641e86f1783d9819d60d1d907752ad8d24a60c31"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"


  depends_on "gnu-sed" => :build

  # fixed for next version with https://github.com/hashcat/hashcat/pull/3030
  patch :DATA if Hardware::CPU.arm?

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0 -D 1,2 -w 2"
  end
end

__END__
diff --git a/src/backend.c b/src/backend.c
index 5de908202..6d0ba4695 100644
--- a/src/backend.c
+++ b/src/backend.c
@@ -10531,6 +10531,7 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
 
       int CL_rc;
 
+/*
       cl_program p1 = NULL;
 
       if (hc_clCreateProgramWithSource (hashcat_ctx, device_param->opencl_context, 1, (const char **) kernel_sources, NULL, &p1) == -1) return false;
@@ -10538,6 +10539,15 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
       CL_rc = hc_clCompileProgram (hashcat_ctx, p1, 1, &device_param->opencl_device, build_options_buf, 0, NULL, NULL, NULL, NULL);
 
       hc_clGetProgramBuildInfo (hashcat_ctx, p1, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, 0, NULL, &build_log_size);
+*/
+
+      if (hc_clCreateProgramWithSource (hashcat_ctx, device_param->opencl_context, 1, (const char **) kernel_sources, NULL, opencl_program) == -1) return false;
+
+      CL_rc = hc_clBuildProgram (hashcat_ctx, *opencl_program, 1, &device_param->opencl_device, build_options_buf, NULL, NULL);
+
+      if (CL_rc == -1) return -1;
+
+      hc_clGetProgramBuildInfo (hashcat_ctx, *opencl_program, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, 0, NULL, &build_log_size);
 
       #if defined (DEBUG)
       if ((build_log_size > 1) || (CL_rc == -1))
@@ -10547,7 +10557,9 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
       {
         char *build_log = (char *) hcmalloc (build_log_size + 1);
 
-        const int rc_clGetProgramBuildInfo = hc_clGetProgramBuildInfo (hashcat_ctx, p1, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, build_log_size, build_log, NULL);
+//        const int rc_clGetProgramBuildInfo = hc_clGetProgramBuildInfo (hashcat_ctx, p1, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, build_log_size, build_log, NULL);
+
+        const int rc_clGetProgramBuildInfo = hc_clGetProgramBuildInfo (hashcat_ctx, *opencl_program, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, build_log_size, build_log, NULL);
 
         if (rc_clGetProgramBuildInfo == -1)
         {
@@ -10565,6 +10577,7 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
 
       if (CL_rc == -1) return false;
 
+/*
       cl_program t2[1];
 
       t2[0] = p1;
@@ -10579,7 +10592,7 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
       *opencl_program = fin;
 
       hc_clReleaseProgram (hashcat_ctx, p1);
-
+*/
       if (cache_disable == false)
       {
         size_t binary_size;
