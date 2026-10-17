{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.hardware.disable-intel-amt.enable = lib.mkEnableOption "common.hardware.disable-intel-amt";

    config = lib.mkIf config.modules.common.hardware.disable-intel-amt.enable {

        boot.kernelParams = [ 
            # 1. Keep intel_idle restricted so it doesn't drop too deep
            "intel_idle.max_cstate=1" 

            # 2. Restrict ACPI C-states safely to state 1 (allows normal frequency scaling 
            # and cooling, but blocks the deepest, most unstable power-saving sleep states)
            "processor.max_cstate=1" 

            # 3. Disable PCIe Active State Power Management (ASPM). 
            # This is the #1 cause of random low-load crashes on Linux servers. It stops 
            # your NVMe drives, network cards, and chipset links from aggressively dropping 
            # into low-power states and failing to wake up when traffic is low (~12%).
            "pcie_aspm=off" 

            # 4. Prevent SATA/AHCI link power management from cutting power to drives during idle
            "libata.force=noncq,nonscq" # (Optional, or use driver defaults, but keep link PM in mind)
        ];

        boot.blacklistedKernelModules = [ "mei" "mei_me" "mei_hdcp" ];

        powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    };
}
