//************************************************************************
//**                          Status CPLD								**
//**                          TOP.v										**
//************************************************************************

//**********************      ChangeList      *****************************

//`include "../SRC/status_define.v"

`timescale 1ns / 1ns
module TOP (
            // System
			//input     SYSCLK,
			input     RESET_N,
			// I2C
			input      SCL,
			inout      SDA,
			output reg LED
			
			);
`define	I2C_ADDR		7'h61		//8bit address is C2

//I2C wire
wire	[7:0]	I2C_DOUT;
wire	[15:0]	PORT_CS;
wire	[15:0]	OFFSET_SEL;    //This two signal port are used for GPIO port selection
wire			RD_WR;         //1 means I2C read operation, and 0 means I2C write operation
wire	[7:0]   DIN_0, DIN_1, DIN_2, DIN_3, DIN_4,  DIN_5, DIN_6, DIN_7, 
                DIN_8, DIN_9, DIN_A, DIN_B, DIN_C, DIN_D, DIN_E, DIN_F;    //16 PORTs for GPIO PORTs
wire			WR_EN;         //This signal is for error code


//reg  RESET_N = 1'b1;
reg     [31:0] cnt;

wire    [7:0] URT_INTERCONN_SET;  //0xA5
wire    [7:0] URT_KEY_DISABLE_SET;  //0xA6
  
wire    [7:0] URT_INTERCONN_OUT;  //0xA5
wire    [7:0] URT_KEY_DISABLE_OUT;  //0xA6

	OSCH #("2.08") clk_inst(               // READ_DELAY = 0
//	OSCH #("14.78") clk_inst(               // READ_DELAY = 0
//	OSCH #("20.46") clk_inst(               // READ_DELAY = 1
//	OSCH #("53.20") clk_inst(               // READ_DELAY = 9
                            //.STDBY(1'b0),
							.OSC(SYSCLK)
							//.SEDSTDBY()
							);	

always@(posedge SYSCLK)
	if(!RESET_N)
		begin
		LED <= 0;
		cnt <= 0;
		end
	else
		begin
			cnt <= (cnt<=32'd2000000)? (cnt+1) : 0;
			LED <= (cnt==32'd2000000)? ~LED : LED;
		end

		
efb_ufm_top i_efb_ufm_top (
    .RESET_N  (RESET_N),
    .SYSCLK   (SYSCLK),
    .URT_INTERCONN_SET      (URT_INTERCONN_SET),  //0xA5
    .URT_KEY_DISABLE_SET    (URT_KEY_DISABLE_SET),  //0xA6
    .URT_INTERCONN_OUT      (URT_INTERCONN_OUT),  //0xA5  output
    .URT_KEY_DISABLE_OUT    (URT_KEY_DISABLE_OUT)  //0xA6  output
);



//**************************************************************************
//**                          
//**  This instance is I2C MACHINE, CPLD use this I2C MACHINE to read/write
//**  data from/to GPIO                    
//**                          
//************************************************************************** 
I2C  I2C_INST  (
               .SCL                 (SCL),
               .SDA                 (SDA),
               .I2C_ADDRESS         (`I2C_ADDR),
               .I2C_RESET_N         (RESET_N),
               .SYSCLK              (SYSCLK),
               .PORT_CS             (PORT_CS),
               .OFFSET_SEL          (OFFSET_SEL),
               .RD_WR               (RD_WR),
               .DOUT                (I2C_DOUT),
               .DIN_0               (DIN_0),                
               .DIN_1               (DIN_1), 		
               .DIN_2               (DIN_2), 		
               .DIN_3               (DIN_3), 		
               .DIN_4               (DIN_4), 		
               .DIN_5               (DIN_5), 		
               .DIN_6               (DIN_6), 		
               .DIN_7               (DIN_7),		    
               .DIN_8               (DIN_8), 		
               .DIN_9               (DIN_9), 		
               .DIN_A               (DIN_A), 		
               .DIN_B               (DIN_B), 		
               .DIN_C               (DIN_C), 		
               .DIN_D               (DIN_D), 		
               .DIN_E               (DIN_E), 		
               .DIN_F               (DIN_F)
			   );
			   
// GPIO0
// 0x10 wr --- 5'b0,mem_ce,mem_we,GO
// 0x11 wr --- cmd[2:0]
// 0X12 wr --- mem_addr[3:0]
// 0x13 wr --- mem_wr_data[7:0]

//GPIO0
// 0x06 rd --- mem_rd_data[7:0]
// 0x07 rd --- BUSY,ERR

GPIO  GPIO_INST (
			.RESET_N		        (RESET_N),
			.SYSCLK			        (SYSCLK),
			                        
			.PORT_CS		        (PORT_CS[10]),
			.OFFSET_SEL	            (OFFSET_SEL),
			.DOUT			        (DIN_A),						
			.RD_WR		            (RD_WR),
			.DIN			        (I2C_DOUT),
                                    
			.GPIO_0		            ( ),
			.GPIO_1		            ( ),
			.GPIO_2		            ( ),
			.GPIO_3		            ( ),
			.GPIO_4		            ( ),
			.GPIO_5		            (URT_INTERCONN_SET ),
			.GPIO_6		            (URT_KEY_DISABLE_SET),
			.GPIO_7		            (),
			.GPIO_8		            (),
			.GPIO_9		            (),
			.GPIO_A		            (),
			.GPIO_B		            (),
			.GPIO_C		            (),
			.GPIO_D		            (),
			.GPIO_E		            (),
			.GPIO_F		            (),
			.URT_INTERCONN_OUT   (URT_INTERCONN_OUT),  //0xA5  input
            .URT_KEY_DISABLE_OUT (URT_KEY_DISABLE_OUT) //0xA6  input
			);

HEADER HEADER_INST (
                    .RESET_N		    (RESET_N),
                    .SYSCLK			    (SYSCLK),						
                    .PORT_CS		    (PORT_CS[0]),
                    .OFFSET_SEL		    (OFFSET_SEL),
                    .DOUT			    (DIN_0),						
                    .RD_WR			    (RD_WR),
                    .DIN				(I2C_DOUT)
					// .mem_rd_data        (mem_rd_data),
					// .BUSY               (BUSY),
					// .ERR                (ERR)
                    // .URT_INTERCONN_OUT   (URT_INTERCONN_OUT),  //0xA5
                    // .URT_KEY_DISABLE_OUT (URT_KEY_DISABLE_OUT) //0xA6
                    );

endmodule
