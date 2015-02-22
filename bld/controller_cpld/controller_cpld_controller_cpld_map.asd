[ActiveSupport MAP]
Device = LCMXO2-1200ZE;
Package = CSBGA132;
Performance = 2;
LUTS_avail = 1280;
LUTS_used = 550;
FF_avail = 1385;
FF_used = 339;
INPUT_LVCMOS33 = 2;
OUTPUT_LVCMOS25 = 1;
BIDI_LVCMOS25 = 2;
BIDI_LVCMOS33 = 1;
IO_avail = 105;
IO_used = 6;
EBR_avail = 7;
EBR_used = 1;
; Begin EBR Section
Instance_Name = i_efb_ufm_top/UUT/inst2/USR_MEM_0_0_0_0;
Type = DP8KC;
Width_A = 8;
Width_B = 8;
Depth_A = 32;
Depth_B = 4;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
RESETMODE = ASYNC;
ASYNC_RESET_RELEASE = SYNC;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = INIT_ALL_0s;
MEM_LPC_FILE = USR_MEM.lpc;
; End EBR Section
;
; start of EFB statistics
I2C = 1;
SPI = 0;
TimerCounter = 0;
UFM = 1;
PLL = 0;
; end of EFB statistics
;
