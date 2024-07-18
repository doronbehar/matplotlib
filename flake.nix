{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3;
    in
    {
      devShell = pkgs.mkShell {
        # Use these variables in ./src/_c_internal_utils.cpp
        LIBX11_REPLACEMENT = "${pkgs.xorg.libX11}/lib/libX11.so.6";
        LIBWAYLAND_EPLACEMENT = "${pkgs.wayland}/lib/libwayland-client.so.0";
        nativeBuildInputs = [
          python.pkgs.pytest
          python.pkgs.meson-python
          python.pkgs.pip
          python.pkgs.mypy
          python.pkgs.flake8
          pkgs.ninja
        ]
        ++ python.pkgs.matplotlib.nativeBuildInputs
        ;
        buildInputs = [
        ]
        ++ python.pkgs.matplotlib.buildInputs
        ;
        propagatedBuildInputs = [
        ]
        ++ python.pkgs.matplotlib.propagatedBuildInputs
        ++ python.pkgs.matplotlib.dependencies
        ;
        # Install to this path with (in contrast to upstream's documentation):
        #
        # python -m pip install \
        #   --config-settings=setup-args="-Dsystem-freetype=true" \
        #   --config-settings=setup-args="-Dsystem-qhull=true" \
        #   --config-settings=setup-args="-Db_lto=false" \
        #   --config-settings=builddir=build \
        #   --prefix dist/nix \
        #   --no-build-isolation \
        #   ".[dev]" 
        #
        #
        # Run test(s) with (e.g):
        #
        #   pytest \
        #     --import-mode=append \
        #     --showlocals \
        #     $INSTALLDIR/matplotlib/tests/test_ticker.py \
        #     -k 'TestLogFormatterMathtext'
        INSTALLDIR = "dist/nix/${python.sitePackages}";
      };
    }
  );
}
