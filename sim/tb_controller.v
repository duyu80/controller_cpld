//`include "../SRC/status_define.v"
//`include "i2c_master_defines.v"
`timescale 1ns / 1ns

`define DEVICE_ID_MSB   8'h20
`define DEVICE_ID_LSB   8'h14
`define CPLD_MAJ_VER    8'hf0
`define CPLD_MIN_VER    8'h00
`define CPLD_TEST_VER   8'h00
`define CHECKSUM        8'h0 - `DEVICE_ID_MSB - `DEVICE_ID_LSB - `CPLD_MAJ_VER - `CPLD_MIN_VER - `CPLD_TEST_VER
`define	CPLD_REV		8'h16
`define	I2C_ADDR		7'h61		//8bit address is C2
module tb_controller;

parameter 		CPLD_REV	= `CPLD_REV;
parameter		GPI_IN		= 8'ha5;
parameter		GPO_OUT	= 8'h37;

reg	[7:0]		i;
reg			    clk;
reg			    rstn;
reg			    i2c_wr;
reg	[7:0]	    i2c_address;
reg	[7:0]	    i2c_wrdata1;
reg	[7:0]	    i2c_wrdata2;
reg	[7:0]	    i2c_wrdata3;
reg	[7:0]	    i2c_data_num;

wire	[2:0]	adr;
wire	[7:0]	dat_o;
wire	[7:0]	dat0_i;
wire			cyc;
wire			stb;
wire			we;
wire			ack;

wire			scl;
wire			sda;

wire	[7:0]	porta;
wire	[7:0]	portb;
wire	[15:0]	PORT_CS;
wire	[15:0]	OFFSET_SEL;    //This two signal port are used for GPIO port selection
wire	[7:0]	I2C_DOUT;    //When write through I2C, the output data will through these two port to each GPIO port
wire			RD_WR;    //1 means I2C read operation, and 0 means I2C write operation
wire	[7:0]	DIN_0;

wire			i2c_busy;
wire	[7:0]	i2c_rddata1;
wire	[7:0]	i2c_rddata2;

reg     [8*16-1:0] teststate;



pullup p1(scl); // pullup scl line
pullup p2(sda); // pullup sda line

GSR GSR_INST (.GSR(1'b1));
PUR PUR_INST (.PUR(1'b1));
wb_master #(8, 8) u0 (
		.clk(clk),
		.rst(rstn),
		.adr(adr),
		.din(dat0_i),
		.dout(dat_o),
		.cyc(cyc),
		.stb(stb),
		.we(we),
		.sel(),
		.ack(ack),
		.err(1'b0),
		.rty(1'b0),
		.i2c_wr(i2c_wr),
		.i2c_addr(i2c_address),
		.i2c_wrdata1( i2c_wrdata1),
		.i2c_wrdata2( i2c_wrdata2),
		.i2c_wrdata3( i2c_wrdata3),
		.i2c_data_num(i2c_data_num),
		.i2c_busy(i2c_busy),
		.i2c_rddata1(i2c_rddata1),
		.i2c_rddata2(i2c_rddata2)
	);

i2c_master_wb_top u1 (

		// wishbone interface
		.wb_clk_i(clk),
		.wb_rst_i(1'b0),
		.arst_i(rstn),
		.wb_adr_i(adr[2:0]),
		.wb_dat_i(dat_o),
		.wb_dat_o(dat0_i),
		.wb_we_i(we),
		.wb_stb_i(stb),
		.wb_cyc_i(cyc),
		.wb_ack_o(ack),
		.wb_inta_o(),

		.scl(scl),
		.sda(sda)
	);


TOP		TOP_INST (
				//.SYSCLK                         (clk),
				.RESET_N                        (rstn),
				.SCL			                (scl),
				.SDA			                (sda)
				);

				
always	#20   clk       = ~clk;

	
initial
	begin

        clk         = 0;
        rstn        = 0;
        i2c_wr      = 1;

        repeat (1000) @(posedge clk);
		
        rstn = 1;
		//repeat (3000) @(posedge clk);
		
		repeat (6000) @(posedge clk);
		//force tb_controller.TOP_INST.URT_INTERCONN_SET = 8'h12;
        //force tb_controller.TOP_INST.URT_KEY_DISABLE_SET = 8'h34;
		wb_write(`I2C_ADDR,8'hA5,8'h55,0,8'h2);
		
		wb_write(`I2C_ADDR,8'h05,0,0,8'h1);
		wb_read(`I2C_ADDR,8'h1);
		
		// repeat (3000) @(posedge clk);
		// force tb_controller.TOP_INST.i_efb_ufm_top.pwr_on_read = 1;
		// repeat (20) @(posedge clk);
		// force tb_controller.TOP_INST.i_efb_ufm_top.pwr_on_read = 0;
		// repeat (30000) @(posedge clk);
		// $display("URT_INTERCONN_OUT is %x", tb_controller.TOP_INST.URT_INTERCONN_OUT);
		// $display("URT_KEY_DISABLE_OUT is %x", tb_controller.TOP_INST.URT_KEY_DISABLE_OUT);
		$stop;
		
        // UFM TEST
		//UFM_TEST();
		//repeat (1000) @(posedge clk);
		// CPLD INFO TEST
        //HEADER_TEST();
		//repeat (1000) @(posedge clk);

        $stop;

	end


//***************************	HEADER TEST TASK	**************************
task HEADER_TEST;
	begin
	    $display("*************************** HEADER test begin ***************************\n");
		
        $display("*********** Read DEVICE_ID_MSB ***********");
		wb_write(`I2C_ADDR,8'h0,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `DEVICE_ID_MSB)
		  $display("DEVICE_ID_MSB test pass\n");
		else
		  begin
		    $display("DEVICE_ID_MSB test fail");
			$stop;
		  end
		
		$display("*********** Read DEVICE_ID_LSB ***********");
		wb_write(`I2C_ADDR,8'h1,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `DEVICE_ID_LSB)
		  $display("DEVICE_ID_LSB test pass\n");
		else
		  begin
		    $display("DEVICE_ID_LSB test fail");
			$stop;
		  end
		
		$display("*********** Read CPLD_MAJ_VER ***********");
		wb_write(`I2C_ADDR,8'h2,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_MAJ_VER)
		  $display("CPLD_MAJ_VER test pass\n");
		else
		  begin
		    $display("CPLD_MAJ_VER test fail");
			$stop;
		  end
		
		$display("*********** Read CPLD_MIN_VER ***********");
		wb_write(`I2C_ADDR,8'h3,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_MIN_VER)
		  $display("CPLD_MIN_VER test pass\n");
		else
		  begin
		    $display("CPLD_MIN_VER test fail");
			$stop;
		  end
		
		$display("*********** Read CPLD_TEST_VER ***********");
		wb_write(`I2C_ADDR,8'h4,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_TEST_VER)
		  $display("CPLD_TEST_VER test pass\n");
		else
		  begin
		    $display("CPLD_TEST_VER test fail");
			$stop;
		  end
		
		$display("*********** Read CHECKSUM ***********");
		wb_write(`I2C_ADDR,8'h5,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CHECKSUM)
		  $display("CHECKSUM test pass\n");
		else
		  begin
		    $display("CHECKSUM test fail");
			$stop;
		  end
		
		$display("*************************** HEADER test pass ***************************\n");
	end
endtask

//***************************	UFM TEST TASK	**************************
//  000 Read 1 page Clear when finished End of transaction
//  001 Read next page Clear when finished End of transaction
//  010 Write 1 page Clear upon UFM busy clear. Beginning of transaction
//  011 Write next page Clear upon UFM busy clear Beginning of transaction
//  100 Enable UFM access Clear upon UFM busy clear. N/A
//  101 Disable UFM access Clear when finished N/A
//  110 (undefined) – –
//  111 Erase UFM

//GPIO0
// 0x06 rd --- mem_rd_data[7:0]
// 0x07 rd --- BUSY,ERR

// GPIO0
// 0x10 wr --- 5'b0,mem_ce,mem_we,GO
// 0x11 wr --- cmd[2:0]
// 0X12 wr --- mem_addr[3:0]
// 0x13 wr --- mem_wr_data[7:0]

task UFM_TEST;
	begin
		$display("*************************** Write UFM test begin ***************************\n");
		
		$display("  *** Read URT_INTERCONN_OUT ***");
		teststate = "Read URT_INTERCONN_OUT";
		wb_write(`I2C_ADDR,8'hA5,8'h00,8'h00,8'h1);
		wb_read(`I2C_ADDR,8'h1);
		repeat (100) @(posedge clk);

		$display("  *** Read URT_KEY_DISABLE_OUT ***");
		teststate = "Read URT_KEY_DISABLE_OUT";
		wb_write(`I2C_ADDR,8'hA6,8'h00,8'h00,8'h1);
		wb_read(`I2C_ADDR,8'h1);
		repeat (100) @(posedge clk);		
		
		$display("*************************** UFM test stop ***************************\n");
	end
endtask

//******************************	I2C TASK	******************************
task wb_write;
	input	[7:0]	i2c_addr;
	input	[7:0]	data1;
	input	[7:0]	data2;
	input	[7:0]	data3;
	input	[7:0]	data_num;
	begin
		//i2c_address = {`I2C_ADDR,1'b0};
		i2c_address = {i2c_addr,1'b0};
		i2c_wrdata1 = data1;
		i2c_wrdata2 = data2;
		i2c_wrdata3 = data3;
		i2c_data_num = data_num;
		@(posedge clk);
		i2c_wr = 0;
		@(posedge clk);
		i2c_wr = 1;
		
		@(negedge i2c_busy);
		
		if(data_num == 8'h1)
			$display("The I2C write %x", i2c_wrdata1);
		else if(data_num == 8'h2)
			$display("The I2C write %x and %x", i2c_wrdata1, i2c_wrdata2);
		else
			$display("The I2C write %x and %x and %x", i2c_wrdata1, i2c_wrdata2, i2c_wrdata3);
	end
endtask

task wb_read;
	input	[7:0]	i2c_addr;
	//output	[7:0]	data1;
	//output	[7:0]	data2;
	input	[7:0]	data_num;
	begin
		//i2c_address = {`I2C_ADDR,1'b1};
		i2c_address = {i2c_addr,1'b1};
		i2c_data_num = data_num;
		@(posedge clk);
		i2c_wr = 0;
		@(posedge clk);
		i2c_wr = 1;
		
		@(negedge i2c_busy);
		
		if(data_num == 8'h1)
			$display("The I2C received %x", i2c_rddata1);
		else
			$display("The I2C received %x and %x", i2c_rddata1, i2c_rddata2);
		//data1 = i2c_rddata1;
		//data2 = i2c_rddata2;
	end
endtask


endmodule

