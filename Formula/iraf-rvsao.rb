class IrafRvsao < Formula
  desc "IRAF package to obtain radial velocities from spectra"
  homepage "https://github.com/iraf-community/iraf-rvsao"
  url "http://tdc-www.harvard.edu/iraf/rvsao/rvsao-2.8.5.tar.gz"
  sha256 "0ccd06a4ff4ba5a344787406145f1348ba0cfbaf7771e51e0356ce8e93979b1a"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-rvsao-2.8.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3019764443f04b4656c8f0e0042419b43cfca20785e883b86e03b29d5a4ac8e1"
    sha256 cellar: :any_skip_relocation, sequoia:     "4406414d0c68acaa902d8cf3606b5af6be1f5c9659be23b8e39d3c986a566c42"
  end

  depends_on "iraf"

  patch :DATA

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["rvsao"] = "#{buildpath}/"
    system "mkpkg", "-p", "rvsao"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"rvsao").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      rvsao
      =version
      logout
    EOF
    assert_match "RVSAO 2.8.5, March 15, 2022", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end

__END__
diff --git a/mkpkg b/mkpkg
index c6a6e1c..5f5cb9a 100644
--- a/mkpkg
+++ b/mkpkg
@@ -14,8 +14,7 @@ install:
 	;
 
 relink:
-#	!mkpkg -p noao -p rvsao nrelink
-	!mkpkg nrelink
+	!mkpkg -p noao nrelink
 	;
  
 nrelink:
