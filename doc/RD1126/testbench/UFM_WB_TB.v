// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2001 - 2008 by Lattice Semiconductor Corporation  
// --------------------------------------------------------------------  
//  
// Permission:                    
//
// Lattice Semiconductor grants permission to use this code for use
// in synthesis for any Lattice programmable logic product. Other
// use of this code, including the selling or duplication of any
// portion is strictly prohibited.
//
// Disclaimer:
//
// This verilog source code is intended as a design reference
// which illustrates how these types of functions can be implemented.
// It is the user's responsibility to verify their design for
// consistency and functionality through the use of formal
// verification methods. Lattice Semiconductor provides no warranty
// regarding the use or functionality of this code.
//
// --------------------------------------------------------------------
//
// Lattice Semiconductor Corporation
// 5555 NE Moore Court
// Hillsboro, OR 97214
// U.S.A
//
// TEL: 1-800-Lattice (USA and Canada)
// 503-268-8001 (other locations)
//
// web: http://www.latticesemi.com/
// email: techsupport@latticesemi.com
//  
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | Vijay   |3/09/12    |Initial ver
//  
// --------------------------------------------------------------------

`timescale 1ns / 100ps
module UFM_WB_tb;


//Internal signals declarations:
reg clk_i;
reg rst_n;
reg [2:0]cmd;
reg [10:0]ufm_page;
reg GO;
wire BUSY;
wire ERR;
reg mem_ce;
reg mem_we;
reg[3 :0] mem_addr;
reg[7:0] mem_wr_data;
wire [7:0] mem_rd_data;
reg [4:0] i;

	OSCH #("2.08") clk_inst(               // READ_DELAY = 0
//	OSCH #("14.78") clk_inst(               // READ_DELAY = 0
//	OSCH #("20.46") clk_inst(               // READ_DELAY = 1
//	OSCH #("53.20") clk_inst(               // READ_DELAY = 9
							.OSC(clk_i)
							);	 
GSR GSR_INST (.GSR(1'b1));
PUR PUR_INST (.PUR(1'b1));	
// Unit Under Test port map
	UFM_WB # (.READ_DELAY (0)) UUT 
        (
		.clk_i(clk_i),
		.rst_n(rst_n),
		.cmd(cmd),
		.ufm_page(ufm_page),
		.GO(GO),
		.BUSY(BUSY),
		.ERR(ERR),
		.mem_clk(clk_i),
		.mem_ce(mem_ce),
		.mem_we(mem_we),
		.mem_addr(mem_addr),
		.mem_wr_data(mem_wr_data),
		.mem_rd_data(mem_rd_data));

//initial
//	$monitor($realtime,,"ps %h %h %h %h %h %h %h ",clk_i,rst_n,cmd,ufm_page,GO,BUSY,ERR);

	

initial
	begin
		rst_n = 1'b0;
		$display($time," ps\t Reset asserted ");
		#1000 rst_n = 1'b1;
		$display($time," ps\t Reset de-asserted ");
	end	 
	

initial
	begin 
		GO = 1'b0;
		cmd = 3'b000;
		ufm_page = 11'b00000000000;
		mem_ce = 1'b0;
		mem_we = 1'b0;
		mem_addr = 4'h0;
		mem_wr_data = 8'h00;
		#1100 ;
	
wait (!BUSY);				//tested ERR condition 
$display($time," ps\t Testing error condition.. ");
		GO = 1'b1;
		cmd = 3'b111;
wait (BUSY );		
		GO = 1'b0;
	
/************************************************Write UFM**************************************************************/ 
$display($time," ps\t UFM Write operation start.. ");	 

wait (!BUSY);				//enable UFM
#1000  
$display($time," ps\t \t  Enable UFM command - %x issued.. ", cmd);	
		GO = 1'b1;
		cmd = 3'b100;
wait (BUSY);		
GO = 1'b0; 

 
$display($time," ps\t \t  Loading page1 data to DPRAM.. ");	
for (i=0; i<16 ; i = i+1 )				   			// load 16 bytes(page 1) of data  (8'hC0-8'hCF)
	begin 	
		@(posedge clk_i) 
				mem_addr = i[3:0];
				mem_wr_data = {3'b110,i[4:0]};
		$display($time," ps\t \t  \t  ADDR- %x \t DATA- %x ",mem_addr,mem_wr_data);
	   @(posedge clk_i)
		 		mem_ce = 1'b1;
				mem_we = 1'b1;		
		
		@ (posedge clk_i)
		 		mem_ce = 1'b0;
				mem_we = 1'b0;
 	end
	 
	 
	 
wait (!BUSY);		 		//write UFM	   
#1000
		GO = 1'b1;
		cmd = 3'b010;
		ufm_page = 11'b000_0000_0010;
		$display($time," ps\t \t  Write 1 page data to UFM address %x command - %x issued.. ",ufm_page, cmd);
wait (BUSY);		
GO = 1'b0;

$display($time," ps\t \t  Loading page2 data to DPRAM.. ");	
 for (i=0; i<16 ; i = i+1 )				   			// load 16 bytes(next page) of data   (8'hE0-8'hEF)				
	begin 	
		@(posedge clk_i) 
				mem_addr = i[3:0];
				mem_wr_data = {3'b111,i[4:0]};
		$display($time," ps\t \t  \t  ADDR- %x \t DATA- %x ",mem_addr,mem_wr_data);
	   @(posedge clk_i)
		 		mem_ce = 1'b1;
				mem_we = 1'b1;		
		
		@ (posedge clk_i)
		 		mem_ce = 1'b0;
				mem_we = 1'b0;
 	end
	 
		
wait (!BUSY);		 		//repeated write UFM 
#1000
		GO = 1'b1;
		cmd = 3'b011;
		$display($time," ps\t \t  Repeated write to UFM command - %x issued.. ", cmd);
wait (BUSY);		
GO = 1'b0;

wait (!BUSY);				//disable UFM
#1000
		GO = 1'b1;
		cmd = 3'b101; 
		$display($time," ps\t \t  Disable UFM command - %x issued.. ", cmd);
wait (BUSY);		
GO = 1'b0;

$display($time," ps\t UFM Write operation done!! ");
/******************************************************Read UFM**************************************************************/	

$display($time," ps\t UFM Read operation start.. ");
wait (!BUSY);				//enable UFM
#1000
		GO = 1'b1;
		cmd = 3'b100;
		$display($time," ps\t \t  Enable UFM command - %x issued.. ", cmd);
wait (BUSY);		
GO = 1'b0; 

wait (!BUSY);		 		//read UFM
#1000
		GO = 1'b1;
		cmd = 3'b000;
		ufm_page = 11'b000_0000_0010;
		$display($time," ps\t \t  Read 1 page data from UFM address %x command - %x issued.. ",ufm_page, cmd);
wait (BUSY);		
GO = 1'b0;	

wait (!BUSY);		 		
#1000				   //repeated read UFM	
		GO = 1'b1;
		cmd = 3'b001; 
		$display($time," ps\t \t  Read next page data from UFM command - %x issued.. ", cmd); 
		$display($time," ps\t \t  Reading page1 data from DPRAM.. ");
 for (i=0; i<16 ; i = i+1 )				   			// read 16 bytes( page1) of data   (8'hC0-8'hCF)
	begin 
		mem_addr = i;
		mem_we = 1'b0;
		@(posedge clk_i) 
			mem_ce = 1'b1;			
		@ (posedge clk_i)
			mem_ce = 1'b0;
		$display($time," ps\t \t  \t  ADDR- %x \t DATA- %x ",mem_addr,mem_rd_data);
	end
wait (BUSY);		
GO = 1'b0;


 		
wait (!BUSY);				
#1000			 //disable UFM
		GO = 1'b1;
		cmd = 3'b101;
		$display($time," ps\t \t  Disable UFM command - %x issued.. ", cmd);
wait (BUSY);		
		GO = 1'b0;

$display($time," ps\t \t  Reading page2 data from DPRAM.. ");		
wait (!BUSY);
 for (i=0; i<16 ; i = i+1 )				   			// read 16 bytes( next page) of data   (8'hE0-8'hEF)
	begin 
		mem_addr = i;
		mem_we = 1'b0;
		@(posedge clk_i) 
			mem_ce = 1'b1;				
		@ (posedge clk_i)
			mem_ce = 1'b0;
		$display($time," ps\t \t  \t  ADDR- %x \t DATA- %x ",mem_addr,mem_rd_data);
	end						  
	
$display($time," ps\t UFM Read operation done!! ");		
				//not simulating erase condition due to the delay requirement(around 107ms)
wait (!BUSY);			  //erase UFM 
#1000
		GO = 1'b1;
		cmd = 3'b111;
		
wait (BUSY);
		GO = 1'b0; 
 	
 
 
 /*************************************************Read UFM erased page**************************************************************/	
 $display($time," ps\t UFM Read erased pages operation start.. ");
 wait (!BUSY);				//enable UFM
#1000
		GO = 1'b1;
		cmd = 3'b100;
		$display($time," ps\t \t  Enable UFM command - %x issued.. ", cmd);
wait (BUSY);		
GO = 1'b0; 

wait (!BUSY);			  //erase UFM 
#1000
		GO = 1'b1;
		cmd = 3'b111;
		$display($time," ps\t \t  Erase UFM command - %x issued.. ", cmd);
wait (BUSY);
		GO = 1'b0; 
 
wait (!BUSY);		 		//read UFM
#1000
		GO = 1'b1;
		cmd = 3'b000;
		ufm_page = 11'b000_0000_0011;
		$display($time," ps\t \t  Read 1 page data from UFM address %x command - %x issued.. ",ufm_page, cmd);
wait (BUSY);		
GO = 1'b0;	

wait (!BUSY);		 		
#1000				   //repeated read UFM	
		GO = 1'b1;
		cmd = 3'b001;
		$display($time," ps\t \t  Read next page data from UFM command - %x issued.. ", cmd); 
		$display($time," ps\t \t  Reading page1 data from DPRAM.. ");
 for (i=0; i<16 ; i = i+1 )				   			// read 16 bytes( page1) of data   
	begin 
		mem_addr = i;
		mem_we = 1'b0;
		@(posedge clk_i) 
			mem_ce = 1'b1;				
		@ (posedge clk_i)
			mem_ce = 1'b0;
		$display($time," ps\t \t  \t  ADDR- %x \t DATA- %x ",mem_addr,mem_rd_data);
	end
wait (BUSY);		
GO = 1'b0;


 		
wait (!BUSY);				
#1000			 //disable UFM
		GO = 1'b1;
		cmd = 3'b101;
		$display($time," ps\t \t  Disable UFM command - %x issued.. ", cmd);
wait (BUSY);		
		GO = 1'b0;

$display($time," ps\t \t  Reading page2 data from DPRAM.. ");		
wait (!BUSY);
 for (i=0; i<16 ; i = i+1 )				   			// read 16 bytes( next page) of data   
	begin 
		mem_addr = i;
		mem_we = 1'b0;
		@(posedge clk_i) 
			mem_ce = 1'b1;				
		@ (posedge clk_i)
			mem_ce = 1'b0; 
		$display($time," ps\t \t  \t  ADDR- %x \t DATA- %x ",mem_addr,mem_rd_data);
	end	
	
$display($time," ps\t UFM Read erased pages operation done!! ");
$finish;
 end
 
 
endmodule
