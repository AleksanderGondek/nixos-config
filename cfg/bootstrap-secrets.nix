{
  config,
  pkgs,
  ...
}: {
  config = {
    sops.age.sshKeyPaths = ["/root/.ssh/id_ed25519"];
    sops.age.keyFile = "/root/.config/sops/age/keys.txt";
    sops.age.generateKey = true;
  };
}
