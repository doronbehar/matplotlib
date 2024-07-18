{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        # Use these variables in ./src/_c_internal_utils.cpp
        LIBX11_REPLACEMENT = "${pkgs.xorg.libX11}/lib/libX11.so.6";
        LIBWAYLAND_EPLACEMENT = "${pkgs.wayland}/lib/libwayland-client.so.0";
        nativeBuildInputs = [
          pkgs.python312.pkgs.pytest
          pkgs.python312.pkgs.meson-python
          pkgs.python312.pkgs.pip
          pkgs.ninja
        ]
        ++ pkgs.python312.pkgs.matplotlib.nativeBuildInputs
        ;
        buildInputs = [
        ]
        ++ pkgs.python312.pkgs.matplotlib.buildInputs
        ;
        propagatedBuildInputs = [

        ]
        ++ pkgs.python312.pkgs.matplotlib.propagatedBuildInputs
        ++ pkgs.python312.pkgs.matplotlib.dependencies
        ;
        # Install to this path with (in contrast to upstream's documentation):
        #
        # python -m pip install \
        #   --config-settings=setup-args="-Dsystem-freetype=true" \
        #   --config-settings=setup-args="-Dsystem-qhull=true" \
        #   --config-settings=setup-args="-Db_lto=false" \
        #   --config-settings=builddir=build \
        #   --prefix out \
        #   --no-build-isolation \
        #   ".[dev]" 
        #
        PYTHONPATH="dist/nix/${pkgs.python312.sitePackages}";
      };
    }
  );
}
