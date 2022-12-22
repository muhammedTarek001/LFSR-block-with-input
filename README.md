# LFSR-block-with-input

Specification
1. All registers are cleared using asynchronous active low reset
2. All outputs are registered
3. DATA serial bit length vary from 1 byte to 4 bytes
4. ACTIVE input signal is high signal during data transmission, low
otherwise.
5. CRC 8 bits are shifted serially through CRC output port
6. Valid signal is high during CRC bits transmission, otherwise low.


Operation:
1. Initialize the shift registers (R7 – R0) to zeros
2. Shift the data bits into the LFSR in the order of LSB first.
3. After the last data bit is shifted into the LFSR, the registers contain
the CRC bits
4. Shift out the CRC bits in the (R7 – R0) in order, R0 contains the LSB
