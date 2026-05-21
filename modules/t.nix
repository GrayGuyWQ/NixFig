{
  services.v2ray = {
    enable = false;
    config = {
      log = {
        loglevel = "warning";
    };


    inbounds = [
      {
      port = 1086;  # // SOCKS proxy port, you need to configure the proxy in the browser and point to this port
      listen = "127.0.0.1";
      protocol = "socks";
      settings = {
        udp = true;
          };
        }
    ];
    outbounds = [
        {
      protocol = "vmess";
      settings = {
        vnext = [
          {
            address = "140.238.210.117"; # // server address, please modify it to your own server ip or domain name
            port = 1086; # // server port
            users = [
              {
                id = "f6416127-a91d-0cad-b7e4-a756579ada96";
              }
            ];
          }
        ];
      };
    }
    {
      protocol = "freedom";
      tag = "direct";
      }
    ];
    routing = {
      domainStrategy = "IPOnDemand";
      rules = [
        {
          type = "field";
          ip = [
              "geoip:private"
              "100.64.0.0/10"
          ];
          outboundTag = "direct";
        }
      ];
    };
  };
  };  


