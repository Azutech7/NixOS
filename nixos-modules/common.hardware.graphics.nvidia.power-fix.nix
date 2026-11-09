{ inputs, pkgs, lib, host, config, ... }: {

	options.modules.common.hardware.graphics.nvidia.power-fix.enable = lib.mkEnableOption "common.hardware.graphics.nvidia.power-fix";

	config = lib.mkIf config.modules.common.hardware.graphics.nvidia.power-fix.enable {

        systemd.services.nvidia-power-fix = {
            description = "Lock NVIDIA GPU clocks to prevent Xid 79 crashes";
            wantedBy = [ "multi-user.target" ];
            after = [ "display-manager.service" ];
            serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = [
                    # Let Nix evaluate the exact absolute path to the nvidia-smi binary
                    "${config.boot.kernelPackages.nvidiaPackages.stable.bin}/bin/nvidia-smi -pm 1"
                    "${config.boot.kernelPackages.nvidiaPackages.stable.bin}/bin/nvidia-smi --lock-gpu-clocks=1000,1800"
                ];
            };
        };

        boot.kernelParams = [ 
            "nvidia-drm.modeset=1" 
            "nvidia-drm.fbdev=1"
            "pcie_aspm=off" 
            "pci=noaer" 
        ];
		
        hardware.nvidia = {
            powerManagement.enable = true;
            powerManagement.finegrained = false;
	    };

	};
}
