class IrafFitsutil < Formula
  desc "IRAF external package for FITS utilities"
  homepage "https://github.com/iraf-community/iraf-fitsutil"
  url "https://github.com/iraf-community/iraf-fitsutil/archive/refs/tags/v2024.07.06.tar.gz"
  sha256 "6f58744669a84e021a3c931f448645053d2ceb65213412f0688e11f48e2b5769"

  depends_on "cfitsio"
  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["fitsutil"] = "#{buildpath}/"
    system "mkpkg", "-p", "fitsutil"

    libexec.install Dir["*"]
  end

  def post_install
    iraf_extern = HOMEBREW_PREFIX/"lib/iraf-extern"
    mkdir_p iraf_extern
    iraf_extern.install_symlink libexec => "fitsutil"
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
