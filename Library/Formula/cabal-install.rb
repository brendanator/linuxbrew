require "formula"

class CabalInstall < Formula
  homepage "http://www.haskell.org/haskellwiki/Cabal-Install"
  url "http://hackage.haskell.org/package/cabal-install-1.20.0.3/cabal-install-1.20.0.3.tar.gz"
  sha1 "444448b0f704420e329e8fc1989b6743c1c8546d"

  bottle do
    cellar :any
    sha1 "98a2b33c24cf095f5647dd294319b2391d88636d" => :mavericks
    sha1 "6de72c12c3d0eaa7e2b0ee4f5227a834ba7c7a5b" => :mountain_lion
    sha1 "7c2d5603cf554037c397a1adfa844caf94cef444" => :lion
  end

  depends_on "ghc"

  conflicts_with "haskell-platform"

  def install
    # use a temporary package database instead of ~/.cabal or ~/.ghc
    pkg_db = "#{Dir.pwd}/package.conf.d"
    system "ghc-pkg", "init", pkg_db
    ENV["EXTRA_CONFIGURE_OPTS"] = "--package-db=#{pkg_db}"
    ENV["PREFIX"] = Dir.pwd
    inreplace "bootstrap.sh", "list --global",
      "list --global --no-user-package-db"

    system "sh", "bootstrap.sh"
    bin.install "bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
