//************************************************************************
//**                          Status CPLD								**
//**                          HEADER.v									**
//************************************************************************

//**********************      ChangeList      *****************************
`timescale 1ns / 1ns
//`include "../SRC/status_define.v"
`define DEVICE_ID_MSB   8'h20
`define DEVICE_ID_LSB   8'h14
`define CPLD_MAJ_VER    8'hf0
`define CPLD_MIN_VER    8'h00
`define CPLD_TEST_VER   8'h00
`define CHECKSUM        8'h0 - `DEVICE_ID_MSB - `DEVICE_ID_LSB - `CPLD_MAJ_VER - `CPLD_MIN_VER - `CPLD_TEST_VER
module HEADER (
                input			    SYSCLK,RESET_N,    //System clock and reset signal
                input			    PORT_CS,		   //PORT select signal
                input	    [15:0]	OFFSET_SEL,	       //Address offset selection
                input			    RD_WR,			   //I2C read/write signal, 1 means read, 0 means write
                
                input	    [7:0]	DIN,
                output reg	[7:0]	DOUT,			   //Output data when I2C read operation
				input       [7:0]   mem_rd_data,
				input               BUSY,
				input               ERR,
				input       [7:0]   URT_INTERCONN_OUT,  //0xA5
                input       [7:0]   URT_KEY_DISABLE_OUT  //0xA6
				);

//Output data when I2C read operation for I2C
wire     [7:0]   DOUT_W = ({8{OFFSET_SEL[0]}} & `DEVICE_ID_MSB)			    |
				 		  ({8{OFFSET_SEL[1]}} & `DEVICE_ID_LSB)			    |
						  ({8{OFFSET_SEL[2]}} & `CPLD_MAJ_VER)		            |
						  ({8{OFFSET_SEL[3]}} & `CPLD_MIN_VER)		            |
						  ({8{OFFSET_SEL[4]}} & `CPLD_TEST_VER)		        |
						  ({8{OFFSET_SEL[5]}} & URT_INTERCONN_OUT)                   |
						  ({8{OFFSET_SEL[6]}} & URT_KEY_DISABLE_OUT)                   |
						  ({8{OFFSET_SEL[7]}} & {6'b0,BUSY,ERR});

//READ GPI FOR I2C
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

endmodule
	