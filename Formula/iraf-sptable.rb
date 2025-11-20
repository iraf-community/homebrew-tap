class IrafSptable < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-sptable"
  url "https://github.com/iraf-community/iraf-sptable/archive/refs/tags/1.0.pre20180612.tar.gz"
  sha256 "c241f936cd8ebb3fe45d22e6d72a78b0802b5aacd3673e6eab4f764a50fffc33"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-sptable-1.0.pre20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "bf6e76c295fdd734318371e3f257ddfd83bb3b854c35acd4c29cd3b47fc46af0"
    sha256 cellar: :any_skip_relocation, sequoia:     "3a3d86e6ccccd98e0420ce7aedc4b359545df03dc4c44eafd989f553b0c60e07"
  end

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["sptable"] = "#{buildpath}/"
    system "mkpkg", "-p", "sptable"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"sptable").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      sptable
      =version
      logout
    EOF
    assert_match "V1.0: 20180612", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end
