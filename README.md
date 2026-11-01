# K10 (MT6765) TWRP — 源码编译

为 **K10 / FATARUS 平板**（MT6765 `k62v1_64_bsp_S30_254_incell_1036_dianshang`，Android 11，
recovery-as-boot，无独立 recovery 分区）从 TWRP 源码构建 recovery。

## 仓库结构

```
twrp_tree/
├── device/k10/k10/          # TWRP 设备树（参数全部来自实机取证）
│   ├── BoardConfig.mk       # boot 头 v2 精确 offsets / 动态分区 / FBE 加密
│   ├── recovery.fstab       # GPT+lpdump 反推
│   ├── twrp_k10.mk          # lunch: twrp_k10-eng
│   ├── prebuilt/            # 原厂内核 Image.gz + dtb.img + dtbo.img
│   └── recovery/root/       # init.recovery.mt6765/6762.rc（USB gadget 拉起）
└── .github/workflows/twrp-build.yml   # GitHub Actions 构建工作流
```

## 构建（GitHub Actions）

Actions 页 → **TWRP Build (K10)** → Run workflow → 全部默认 → Run。

- manifest：`minimal-manifest-twrp/platform_manifest_twrp_aosp` 分支 `twrp-11`
- 目标：`bootimage`（本机无 recovery 分区，TWRP 装进 boot_a）
- 产物：`boot.img`（即 recovery 载荷），Release 页可下载

## 刷入（在已解锁 fastboot 的机器上）

```sh
fastboot flash boot_a boot.img
# 请求下次以 recovery 模式启动（写 BCB 到 para 分区）
fastboot flash para bcb_recovery.bin   # 2048B: "boot-recovery" + 补零
fastboot reboot
```

> 设备进入 TWRP。清 BCB（para 前 2048B 置零）+ 刷回原厂 boot_a 可完全还原 Android。

## 回滚

```sh
fastboot flash boot_a stock_boot_a.img
fastboot flash para bcb_zero.bin
fastboot reboot
```

## 实机参数依据（取证，非推测）

| 项 | 值 |
|---|---|
| SoC | MT6765（8×A53），`ro.boot.hardware=mt6762` |
| boot 头 | v2，page 2048，kernel@0x40080000，ramdisk@0x51b00000，tags/dtb@0x47880000 |
| cmdline | `bootopt=64S3,32N2,64N2 buildvariant=user androidboot.selinux=permissive` |
| 分区 | A/B 伪双槽（boot_b 全零、super B 槽无 extent），boot_a 32MiB |
| super | 7,516,192,768 B，main 组 7,514,095,616 B（system/product/vendor） |
| /data | ext4 + inlinecrypt + FBE v2 + metadata 加密（keydirectory 在 /metadata，实为 md_udc 分区） |
| BCB | `para` 分区前 2048B |
| 屏幕 | 1200×2000 @260dpi，fb0 32bpp |

## 已知风险

- 首次构建由 GitHub 云端完成，若个别 AOSP 包被上游移动会导致 sync 失败——重跑即可。
- 刷机有风险；本仓库不承担设备损坏责任。**绝对不要用 SP Flash Tool 的 Format All**。
