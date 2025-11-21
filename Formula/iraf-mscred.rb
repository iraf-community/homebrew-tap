class IrafMscred < Formula
  desc "Mosaic CCD reduction package"
  homepage "https://github.com/iraf-community/iraf-mscred"
  url "https://github.com/iraf-community/iraf-mscred.git", revision: "244319d"
  version "5.05+20250915"
  sha256 "1e447c7e0cab3b41be4dbf3e390c7f94095d7b3dd1390269f1c80733d8512c7d"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-mscred-5.05+20250915"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ae6e44f756339b167f7ae7c86a1e4eb75a6d1a6b740832176ea5c59b8cfb4fc0"
    sha256 cellar: :any_skip_relocation, sequoia:     "0f6589435bd9560fec0662d08b60032485fb72b4f3fd7550f6886591b480f5c6"
  end

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV["mscred"] = "#{buildpath}/"
    system "mkpkg", "-p", "mscred"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"mscred").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      mscred
      =version
      logout
    EOF
    assert_match "V5.05: 2018.07.09", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end
