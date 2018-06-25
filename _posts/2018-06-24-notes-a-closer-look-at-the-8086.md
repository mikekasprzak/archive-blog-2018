---
title: 'Notes: A closer look at the 8086'
layout: post
---

Intel terms: [https://stackoverflow.com/a/41616657/5678759](https://stackoverflow.com/a/41616657/5678759)

Cheat Sheet: [http://www.jegerlehner.ch/intel/](http://www.jegerlehner.ch/intel/)

## Effective Address

`[base_reg + index_reg*scale + displacement]`

Reference: [https://stackoverflow.com/a/36704482/5678759](https://stackoverflow.com/a/36704482/5678759)

## Segment Registers
The 8086 CPU has 4 segment registers (later CPUs gained 2 more). These registers are used to workaround the 64k address space limitations of the 16bit registers by letting you freely relocate your base address (i.e. zero).

* **CS** - Code Segment (works with the **IP** Instruction Pointer register)
* **DS** - Data Segment
* **SS** - Stack Segment (works with the **SP** Stack Pointer register)
* **ES** - Extra Segment

### CS



### ES (with DI and DF)
The **ES** or Extra Segment register is like the name suggests: an extra or spare segment you can use for whatever you want... as long as what you want is to write/compare with memory. There are only a handful of instructions supported by the `ES` register.

* **SCASB** - Compare bytes in **ES:[DI]** and **AL**
* **SCASW** - Compare words in **ES:[DI]** and **AX**
* **CMPSB** - Compare bytes **ES:[DI]** and **DS:[SI]**
* **CMPSW** - Compare words **ES:[DI]** and **DS:[SI]**
* **STOSB** - Copy byte to **ES:[DI]** from **AL**, and increment (or decrement) **DI**
* **STOSW** - Copy word to **ES:[DI]** from **AX**, and increment (or decrement) **DI** by 2
* **MOVSB** - Copy byte to **ES:[DI]** from **DS:[EI]**, and increment (or decrement) **DI** and **SI**
* **MOVSW** - Copy word to **ES:[DI]** from **DS:[EI]**, and increment (or decrement) **DI** and **SI** by 2 each

So in general, **ES** is used primarily as an output segment. It can be used in tandem with **DS** (Data Segment), or with **AL** (byte) and **AX** (word).

**ES** is always used with the **DI** Destination Index register and the **DF** Direction Flag register. 

The value of **DI** is automatically changed when used (incremented or decremented). In addition, **DI** can be modified with any instruction that can affect a **reg16**.

The direction can be controlled with a pair of instructions.

* **CLD** - Clear Direction Flag (i.e. **increment**)
* **STD** - Set Direction Flag (i.e. **decrement**)

**IMPORTANT:** you cannot independently pick directions for the **DI** and **SI** registers.