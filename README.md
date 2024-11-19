# Introduction
[![builds.sr.ht status](https://builds.sr.ht/~dkm/stm32f0x2_hal-ada/commits/main/.build.yml.svg)](https://builds.sr.ht/~dkm/stm32f0x2_hal-ada/commits/main/.build.yml?)

The main repository is on [SourceHut](https://builds.sr.ht/~dkm/stm32f0x2_hal-ada/).

This repository contains drivers for the STM32F0*2 familly microcontrolers.
It is based on the [Ada_Driver_Library](https://github.com/AdaCore/Ada_Drivers_Library).

# Current support

The software has been developped for a specific case and thus hasn't been tested
for anything else. The peripherals used by the F0 familly being very close to
the ones in others familly (and in particular the F4), it's really easy to add
support for others.

My current focus is:
 * UART
 * SPI
 * TIMERS
 * USB
 * GPIO

# License

All files coming from the original
[Ada_Driver_Library](https://github.com/AdaCore/Ada_Drivers_Library) are covered
by the corresponding license (namely 3-clause Berkely Software Distribution
(BSD)).

All files entirely written by me are covered by the GPL-3.

See [`LICENSE`](LICENSE) for more details.
