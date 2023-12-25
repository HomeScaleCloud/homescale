{ config, pkgs, lib, ... }: {
  imports = [
    ../base.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  environment.systemPackages = with pkgs; [ cloudflared teleport ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 4022 ];
  networking = {
    hostName = "srv-access-01";
    domain = "morrislan.net";
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
       address = "10.1.240.5";
       prefixLength = 24;
      }];
    };
    defaultGateway = "10.1.240.1";
    nameservers = [ "10.1.240.3" ];
  };

  users.users = {
    cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
  };
  users.groups.cloudflared = { };

  systemd.services.cloudflared = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=MORRISLAN_TUNNEL_TOKEN";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };

  services.teleport = {
    enable = true;
    settings = {
      teleport = {
        nodename = config.networking.hostName;
      };
      auth_service = {
        enabled = true;
        listen_addr = "127.0.0.1:3025";
        cluster_name = "access.morrislan.net";
        authentication = {
          type = "github";
          local_auth = false;
        };
      };
      proxy_service = {
        enabled = true;
        web_listen_addr = "127.0.0.1:443";
        public_addr = "access.morrislan.net:443";
        https_keypairs = {
          key_file = "/etc/teleport/key.pem";
          cert_file = "/etc/teleport/cert.pem";
        };
      };
      ssh_service = {
        enabled = true;
      };
    };
  };

  environment.etc."teleport/key.pem".text = ''
    ${pkgs.openssl}/bin/openssl genpkey -algorithm RSA -out /etc/teleport/key.pem
  '';

  environment.etc."teleport/cert.pem".text = ''
    ${pkgs.openssl}/bin/openssl req -new -x509 -key /etc/teleport/key.pem -out /etc/teleport/cert.pem -days 3650 -subj "/CN=access.morrislan.net"
    '';

  systemd.services.teleport-sso = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      script = ''
        #!/bin/sh
        # Commands to configure GitHub SSO for Teleport
        ${pkgs.teleport}/bin/tctl sso configure github --id=TP_GH_CLIENT_ID --secret=TP_GH_CLIENT_SECRET --teams-to-roles=morrislan,admins,auditor,access,editor > github.yaml
        ${pkgs.teleport}/bin/tctl create -f github.yaml
        systemctl disable teleport-sso.service
        rm /etc/nixos/teleport-sso.sh
      '';
    };
  };

  system.stateVersion = "23.11";
}
