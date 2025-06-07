This repository is home to the nix code that builds my systems for Some Single Board Computers(SBCs).
Once again heavily based on [https://github.com/ryan4yin/nixos-config-sbc](nixos-config-sbc) repo.

See [./hosts](./hosts) for details of each host.

## Why a separate repository for SBCs?

It is troublesome to update nixpkgs on aarch64/riscv64 SBCs, which can easily cause various problems
such as kernel compilation failure and boot failure caused by uboot/edk2 incompatibility. So it
feels like a good idea to create separate flakes for SBCs and have them updated separately.

## References

- [walter-melon/nix-config](https://github.com/walter-melon/nix-config/)
- [ryan4yin/nixos-config-sbc](https://github.com/ryan4yin/nixos-config-sbc/)