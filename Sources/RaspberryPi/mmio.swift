#if RASPI4
    let mmioBase: UInt = 0xFE00_0000
#elseif RASPI3 || RASPI2
    let mmioBase: UInt = 0x3F00_0000
#else
    let mmioBase: UInt = 0x2000_0000
#endif
