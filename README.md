## rdp_session

I did not manage to make [WINAPPS](https://github.com/Fmstrat/winapps) work on my machine™, so this is something very similar, with `xfreerdp` parameters that I find create the most comfortable connection (even when used wit a tiling WM).

### Usage

```bash
sudo chmod +x rdp_session.sh
rdp_session.sh vm-connect <IP ADDR> [APP]
rdp_session.sh vm-disconnect
rdp_session.sh remote-connect <IP ADDR> 
```

In case of `vm-connect` a Windows VM with RDP enabled is necessary 

