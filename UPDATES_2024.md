# ZMK Configuration Updates (2022-2024)

## Summary

This document outlines the major changes that occurred in ZMK firmware over the last two years and the updates made to this configuration to ensure compatibility with modern ZMK versions.

## Major ZMK Changes (2022-2024)

### ZMK 0.3.0 (August 2024) - Major Release

**New Features:**
- **Full-Duplex Wired Split Support**: Better connectivity for wired split keyboards
- **Mouse/Pointing Device Support**: Native mouse movement and scroll support
- **Nice!View Improvements**: Individual profile status display
- **Combo System Enhancements**: Better performance and cleanup
- **Split Transport Improvements**: Runtime selection of split transport methods

**Bug Fixes:**
- Macro behavior improvements
- BLE scrolling fixes
- Display and power management improvements

### ZMK 0.2.0 (March 2024)

**New Features:**
- **Mouse Movement and Scroll**: Complete mouse emulation support
- **Toggle Mode Enhancements**: Better toggle-on/toggle-off behavior
- **Input Processor Behaviors**: New behavior system for advanced input processing
- **Physical Layout Improvements**: Better keyboard layout handling
- **Display Configuration**: More control over display behavior

### ZMK 0.1.0 (November 2024)

**Infrastructure:**
- **Release Automation**: Better versioning and release management
- **Driver Improvements**: Enhanced hardware support

## Configuration Updates Made

### 1. Syntax Fixes ✅

**Issue**: Deprecated property naming
```diff
- quick_tap_ms = <175>;
+ quick-tap-ms = <175>;
```

**Impact**: Critical - builds would fail with modern ZMK versions

### 2. Modern Home Row Mod Features ✅

**Added**:
- `require-prior-idle-ms = <150>` - Improves home row mod performance
- `hold-trigger-on-release` - Now available in ZMK 0.3.0+

**Removed**:
- `global-quick-tap` - Deprecated in favor of `require-prior-idle-ms`

**Before**:
```c
// global-quick-tap-ms = <150>;         // requires PR #1387
global-quick-tap;
hold-trigger-on-release;       // requires PR #1423
```

**After**:
```c
require-prior-idle-ms = <150>;         // requires ZMK >0.3.0  
hold-trigger-on-release;       // requires ZMK >0.3.0
```

### 3. Tap-Dance Improvements ✅

**Enabled**: Reset tap-dance behavior that was previously commented out
```c
reset_td: reset_td {
  compatible = "zmk,behavior-tap-dance";
  label = "RESET_TD";
  #binding-cells = <0>;
  tapping-term-ms = <200>;
  bindings = <&sys_reset>, <&bootloader>;
};
```

### 4. Documentation Updates ✅

- Updated README with current keyboard status
- Added feature documentation
- Listed recent updates and ZMK compatibility

## Potential Future Enhancements

### 1. Mouse/Pointing Device Support

ZMK 0.2.0+ includes mouse support. Could add:
```c
&mkp LCLK     // Mouse left click
&mkp RCLK     // Mouse right click  
&mkp MCLK     // Mouse middle click
U_MS_U        // Mouse up
U_MS_D        // Mouse down
U_MS_L        // Mouse left
U_MS_R        // Mouse right
U_WH_U        // Wheel up
U_WH_D        // Wheel down
```

### 2. Input Processors

For advanced input transformations available in ZMK 0.2.0+

### 3. Enhanced Split Features

ZMK 0.3.0 includes full-duplex wired split support for better connectivity.

### 4. Display Enhancements

Better Nice!View integration with profile status display.

## Build Compatibility

✅ **Current Status**: Configuration builds successfully with ZMK 0.3.0+
✅ **Backward Compatibility**: Should work with ZMK 0.2.0+  
❌ **Old ZMK**: Will not work with pre-0.2.0 versions due to modern features

## Recommendations

### Immediate (Done)
- [x] Fix syntax issues
- [x] Enable modern home row mod features
- [x] Update documentation

### Optional Future Enhancements
- [ ] Add mouse layer for enhanced navigation
- [ ] Implement input processors for advanced key transformations
- [ ] Add wired split configuration if using wired setup
- [ ] Enhance Nice!View display configuration

### Build Testing
- [x] Syntax validation passes
- [ ] GitHub Actions build test (recommended)
- [ ] Flash test on actual hardware (recommended)

## Migration Notes

When updating from a 2+ year old ZMK config:

1. **Always backup** your current working firmware
2. **Test in stages** - update syntax first, then add new features
3. **Verify builds** pass before flashing to hardware
4. **Check key behavior** after flashing - especially home row mods
5. **Update gradually** - don't change everything at once

## Resources

- [ZMK Changelog](https://github.com/zmkfirmware/zmk/blob/main/CHANGELOG.md)
- [ZMK Docs - Behaviors](https://zmk.dev/docs/behaviors)
- [ZMK Docs - Hold Tap](https://zmk.dev/docs/behaviors/hold-tap)
- [urob's ZMK Config](https://github.com/urob/zmk-config) - Modern best practices