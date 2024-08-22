{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./agondek
    ./drone
    ./viewer
  ];
}
