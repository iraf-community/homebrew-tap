class IrafXdimsum < Formula
  desc "Deep Infrared Mosaicing Software"
  homepage "https://github.com/iraf-community/iraf-xdimsum"
  url "https://github.com/iraf-community/iraf-xdimsum.git",
      revision: "6dfc2de85f27669c2a2c9a3f0d7934deba461515"
  version "2003.01.24"
  sha256 "1e447c7e0cab3b41be4dbf3e390c7f94095d7b3dd1390269f1c80733d8512c7d"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-xdimsum-2003.01.24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "64b6467a50e453eefb95b6e5bc4467ed07a9630d910e85a5d0ab874b4b8e824c"
    sha256 cellar: :any_skip_relocation, sequoia:     "3009824a4299709309cb93ac5ec4e7b0f61311683d11d5d7c5c597d0660f860f"
  end

  depends_on "iraf"

  patch :DATA

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["xdimsum"] = "#{buildpath}/"
    system "mkpkg", "-p", "xdimsum"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"xdimsum").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      xdimsum
      =version
      logout
    EOF
    assert_match "January 24, 2003", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end

__END__
diff --git a/xdimsum.cl b/xdimsum.cl
index acdb50f..701d9bd 100644
--- a/xdimsum.cl
+++ b/xdimsum.cl
@@ -1,4 +1,4 @@
-# { XDIMSUM -- Package definition script for the XDIMSUM IR array imaging
+#{ XDIMSUM -- Package definition script for the XDIMSUM IR array imaging
 # reduction package.
 
 # Load necessary packages.
@@ -55,7 +55,7 @@ task maskinterp 	= "xdimsum$src/x_xdimsum.e"
 task minv		= "xdimsum$src/minv.cl"
 task xaddmask		= "xdimsum$src/xaddmask.cl"
 
-hidetask addcomment avshift fileroot maskinterp minv xaddmask
+hidetask addcomment, avshift, fileroot, maskinterp, minv, xaddmask
 
 
 # Demos
@@ -67,6 +67,6 @@ task	demos	= "demos$demos.cl"
 # to go through and eventually replace some of these calls, e.g. replace
 # imgets with hselect, etc.
 
-cache sections fileroot imgets minmax iterstat miterstat maskstat xaddmask
+cache sections, fileroot, imgets, minmax, iterstat, miterstat, maskstat, xaddmask
 
 clbye()
-- 
2.51.0

