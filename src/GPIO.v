//************************************************************************
//**                          Status CPLD								**
//**                          GPIO.v									**
//************************************************************************

//**********************      ChangeList      *****************************

//`include "../SRC/status_define.v"
`timescale 1ns / 1ns
module GPIO # (
              parameter GPIOE_0          =    "TRUE",
			  parameter GPIOE_1          =    "TRUE",
			  parameter GPIOE_2          =    "TRUE",
			  parameter GPIOE_3          =    "TRUE",
              parameter GPIOE_4          =    "TRUE",
			  parameter GPIOE_5          =    "TRUE",
			  parameter GPIOE_6          =    "TRUE",
			  parameter GPIOE_7          =    "TRUE",
              parameter GPIOE_8          =    "TRUE",
			  parameter GPIOE_9          =    "TRUE",
			  parameter GPIOE_A          =    "TRUE",
			  parameter GPIOE_B          =    "TRUE",
              parameter GPIOE_C          =    "TRUE",
			  parameter GPIOE_D          =    "TRUE",
			  parameter GPIOE_E          =    "TRUE",
			  parameter GPIOE_F          =    "TRUE",
			  parameter GPO_DFT_VAL      =    8'h0
           )
           (
              input	     		SYSCLK,		 	//System clock
              input	     		RESET_N,		//Reset signal
                         
              input	     		PORT_CS,		//PORT select signal
              input	     [15:0]	OFFSET_SEL,	    //Address offset selection
              input	     		RD_WR,			//I2C read/write signal, 1 means read, 0 means write
                         
              input	     [7:0]	DIN,
              output reg [7:0]	DOUT,			//Output data when I2C read operation
              
              output	     [7:0]	GPIO_0,
              output	     [7:0]	GPIO_1,
              output	     [7:0]	GPIO_2,
              output	     [7:0]	GPIO_3,
              output	     [7:0]	GPIO_4,
              output	     [7:0]	GPIO_5,
              output	     [7:0]	GPIO_6,
              output	     [7:0]	GPIO_7,
              output	     [7:0]	GPIO_8,
              output	     [7:0]	GPIO_9,
              output	     [7:0]	GPIO_A,
              output	     [7:0]	GPIO_B,
              output	     [7:0]	GPIO_C,
              output	     [7:0]	GPIO_D,
              output	     [7:0]	GPIO_E,
              output	     [7:0]	GPIO_F,
			  
			  input          [7:0]  URT_INTERCONN_OUT,
			  input          [7:0]  URT_KEY_DISABLE_OUT
            );


reg	    [7:0]	GPO_0;
reg	    [7:0]	GPO_1;
reg	    [7:0]	GPO_2;
reg	    [7:0]	GPO_3;
reg	    [7:0]	GPO_4;
reg	    [7:0]	GPO_5;
reg	    [7:0]	GPO_6;
reg	    [7:0]	GPO_7;
reg	    [7:0]	GPO_8;
reg	    [7:0]	GPO_9;
reg	    [7:0]	GPO_A;
reg	    [7:0]	GPO_B;
reg	    [7:0]	GPO_C;
reg	    [7:0]	GPO_D;
reg	    [7:0]	GPO_E;
reg	    [7:0]	GPO_F;

wire    [7:0]	DOUT_W =  (
							({8{OFFSET_SEL[0]}}  & GPIO_0)		|
							({8{OFFSET_SEL[1]}}  & GPIO_1)		|
							({8{OFFSET_SEL[2]}}  & GPIO_2)		|
							({8{OFFSET_SEL[3]}}  & GPIO_3)		|
							({8{OFFSET_SEL[4]}}  & GPIO_4)		|
							({8{OFFSET_SEL[5]}}  & URT_INTERCONN_OUT)		|
							({8{OFFSET_SEL[6]}}  & URT_KEY_DISABLE_OUT)		|
							({8{OFFSET_SEL[7]}}  & GPIO_7)		|
							({8{OFFSET_SEL[8]}}  & GPIO_8)		|
							({8{OFFSET_SEL[9]}}  & GPIO_9)		|
							({8{OFFSET_SEL[10]}} & GPIO_A)		|
							({8{OFFSET_SEL[11]}} & GPIO_B)		|
							({8{OFFSET_SEL[12]}} & GPIO_C)		|
							({8{OFFSET_SEL[13]}} & GPIO_D)		|
							({8{OFFSET_SEL[14]}} & GPIO_E)		|
							({8{OFFSET_SEL[15]}} & GPIO_F)
                          );

//READ
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				DOUT <= 8'h0;
			end
		else
			begin
				DOUT <= (PORT_CS & RD_WR)? DOUT_W : DOUT;			
			end
	end

//WRITE
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				GPO_0	<= GPO_DFT_VAL;
				GPO_1	<= GPO_DFT_VAL;
				GPO_2	<= GPO_DFT_VAL;
				GPO_3	<= GPO_DFT_VAL;
				GPO_4	<= GPO_DFT_VAL;
				GPO_5	<= GPO_DFT_VAL;
				GPO_6	<= GPO_DFT_VAL;
				GPO_7	<= GPO_DFT_VAL;
				GPO_8	<= GPO_DFT_VAL;
				GPO_9	<= GPO_DFT_VAL;
				GPO_A	<= GPO_DFT_VAL;
				GPO_B	<= GPO_DFT_VAL;
				GPO_C	<= GPO_DFT_VAL;
				GPO_D	<= GPO_DFT_VAL;
				GPO_E	<= GPO_DFT_VAL;
				GPO_F	<= GPO_DFT_VAL;
			end
		else
			begin
				GPO_0	<= (PORT_CS & OFFSET_SEL[0]  & ~RD_WR)? DIN :  GPO_0;
				GPO_1	<= (PORT_CS & OFFSET_SEL[1]  & ~RD_WR)? DIN :  GPO_1;
				GPO_2	<= (PORT_CS & OFFSET_SEL[2]  & ~RD_WR)? DIN :  GPO_2;
				GPO_3	<= (PORT_CS & OFFSET_SEL[3]  & ~RD_WR)? DIN :  GPO_3;
				GPO_4	<= (PORT_CS & OFFSET_SEL[4]  & ~RD_WR)? DIN :  GPO_4;
				GPO_5	<= (PORT_CS & OFFSET_SEL[5]  & ~RD_WR)? DIN :  GPO_5;
				GPO_6	<= (PORT_CS & OFFSET_SEL[6]  & ~RD_WR)? DIN :  GPO_6;
				GPO_7	<= (PORT_CS & OFFSET_SEL[7]  & ~RD_WR)? DIN :  GPO_7;
				GPO_8	<= (PORT_CS & OFFSET_SEL[8]  & ~RD_WR)? DIN :  GPO_8;
				GPO_9	<= (PORT_CS & OFFSET_SEL[9]  & ~RD_WR)? DIN :  GPO_9;
				GPO_A	<= (PORT_CS & OFFSET_SEL[10] & ~RD_WR)? DIN :  GPO_A;
				GPO_B	<= (PORT_CS & OFFSET_SEL[11] & ~RD_WR)? DIN :  GPO_B;
				GPO_C	<= (PORT_CS & OFFSET_SEL[12] & ~RD_WR)? DIN :  GPO_C;
				GPO_D	<= (PORT_CS & OFFSET_SEL[13] & ~RD_WR)? DIN :  GPO_D;
				GPO_E	<= (PORT_CS & OFFSET_SEL[14] & ~RD_WR)? DIN :  GPO_E;
				GPO_F	<= (PORT_CS & OFFSET_SEL[15] & ~RD_WR)? DIN :  GPO_F;
			end
	end

assign    GPIO_0  =  GPO_0;
assign    GPIO_1  =  GPO_1;
assign    GPIO_2  =  GPO_2;
assign    GPIO_3  =  GPO_3;
assign    GPIO_4  =  GPO_4;
assign    GPIO_5  =  GPO_5;
assign    GPIO_6  =  GPO_6;
assign    GPIO_7  =  GPO_7;
assign    GPIO_8  =  GPO_8;
assign    GPIO_9  =  GPO_9;
assign    GPIO_A  =  GPO_A;
assign    GPIO_B  =  GPO_B;
assign    GPIO_C  =  GPO_C;
assign    GPIO_D  =  GPO_D;
assign    GPIO_E  =  GPO_E;
assign    GPIO_F  =  GPO_F;

endmodule