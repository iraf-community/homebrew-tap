class IrafXdimsum < Formula
  desc "Deep Infrared Mosaicing Software"
  homepage "https://github.com/iraf-community/iraf-xdimsum"
  url "https://github.com/iraf-community/iraf-xdimsum.git",
      revision: "6dfc2de85f27669c2a2c9a3f0d7934deba461515"
  version "2003.01.24"
  sha256 "1e447c7e0cab3b41be4dbf3e390c7f94095d7b3dd1390269f1c80733d8512c7d"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-xdimsum-2003.01.24"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6906af8a5e88a13e1b4b61522193d5bfd2025757099a955444a838546d4af287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9b9eff59d5a20dafd47bae3d3833aaf5cefae8bf10e842e764284eff55d7e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9cbf5c7ce4e26aecd0453a18bdc6b9e3d30075e2b43f5c466da5dd478905c92"
    sha256 cellar: :any_skip_relocation, tahoe:         "c9db0da02ff1b2514c08f3e984e3eb9dc7ff914b87ed7cba1ce80221ea85aaa0"
    sha256 cellar: :any_skip_relocation, sequoia:       "fec5763267264114ab0cb42c54a264fa8aa03b09c1c29dd9008cf24a903f63b6"
  end

  IRAF_PACKAGE = "xdimsum".freeze

  depends_on "iraf"

  patch :DATA

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE
    system "irafcl", "-c", "softools; mkhelpdb helpdir=lib$root.hd helpdb=lib$helpdb.mip"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/IRAF_PACKAGE).install Dir["*"]
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{lib}/iraf/extern/#{IRAF_PACKAGE}/#{IRAF_PACKAGE}.par  | cut -d\\\" -f2")
    ver = shell_output("irafcl -c #{IRAF_PACKAGE} -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
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

