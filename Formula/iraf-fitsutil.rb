class IrafFitsutil < Formula
  desc "IRAF external package for FITS utilities"
  homepage "https://github.com/iraf-community/iraf-fitsutil"
  url "https://github.com/iraf-community/iraf-fitsutil/archive/refs/tags/v2024.07.06.tar.gz"
  sha256 "6f58744669a84e021a3c931f448645053d2ceb65213412f0688e11f48e2b5769"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-fitsutil-2024.07.06"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "8043f36647ef044d1f058ade3d5bee1f554be316f11f5a0b73f190f3bf850531"
  end

  depends_on "cfitsio"
  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["fitsutil"] = "#{buildpath}/"
    system "mkpkg", "-p", "fitsutil"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"fitsutil").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      fitsutil
      =version
      logout
    EOF
    assert_match "2018.07.06", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end
