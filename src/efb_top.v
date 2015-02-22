module efb_ufm_top (
  input  RESET_N,
  input  SYSCLK,
  
  input  [7:0] URT_INTERCONN_SET,  //0xA5
  input  [7:0] URT_KEY_DISABLE_SET,  //0xA6
  
  output reg [7:0] URT_INTERCONN_OUT,  //0xA5
  output reg [7:0] URT_KEY_DISABLE_OUT,  //0xA6
  output [7:0] diag

);

//parameter    delay         = 32'd50_000_000;
//for sim
parameter    delay         = 32'd50;

parameter    RD_SM_IDLE    = 'b1 << 0,
             RD_SM_ENUFM   = 'b1 << 1,
             RD_SM_RDUFM   = 'b1 << 2,
             RD_SM_RDDATA0 = 'b1 << 3,
			 RD_SM_RDDATA1 = 'b1 << 4,
			 RD_SM_END     = 'b1 << 5;

parameter    WR_SM_IDLE       = 'b1 << 0,
             WR_SM_ENUFM      = 'b1 << 1,
             WR_SM_ERAS_UFM   = 'b1 << 2,
             WR_SM_DATA0      = 'b1 << 3,
			 WR_SM_DATA1      = 'b1 << 4,
			 WR_SM_WRUFM      = 'b1 << 5,
			 WR_SM_END        = 'b1 << 6;

reg  [15:0]   rd_sm_ns, rd_sm_q;
reg  [15:0]   wr_sm_ns, wr_sm_q;

reg  [7:0]   URT_INTERCONN_SET_Q;
reg  [7:0]   URT_KEY_DISABLE_SET_Q;

reg  [31:0]  cnt;
reg          pwr_on_read;

reg          BUSY_D;

wire [2:0]   cmd;
//wire [10:0]  ufm_page;
reg          GO;
wire         BUSY;
wire         ERR;
wire         mem_ce;
wire         mem_we;
wire [3 :0]  mem_addr;
wire [7:0]   mem_wr_data;
wire [7:0]   mem_rd_data;

wire         BUSY_N = BUSY_D & ~BUSY;
wire         write_trig = (URT_INTERCONN_SET_Q ^ URT_INTERCONN_SET) || (URT_KEY_DISABLE_SET_Q ^ URT_KEY_DISABLE_SET);

//assign       cmd = ( rd_sm_ns == RD_SM_IDLE     )? 3'b100   : (
assign       cmd = ( rd_sm_ns == RD_SM_ENUFM    )? 3'b100   : (
				   ( rd_sm_ns == RD_SM_RDUFM    )? 3'b000   : (
				   ( rd_sm_ns == RD_SM_RDDATA0  )? 3'b000   : (
				   ( rd_sm_ns == RD_SM_RDDATA1  )? 3'b000   : (
				   ( rd_sm_ns == RD_SM_END      )? 3'b000   : (
//				   ( wr_sm_ns == WR_SM_IDLE     )? 3'b100   : (
				   ( wr_sm_ns == WR_SM_ENUFM    )? 3'b100   : (
				   ( wr_sm_ns == WR_SM_ERAS_UFM )? 3'b111   : (
				   ( wr_sm_ns == WR_SM_WRUFM    )? 3'b010   : (
				   ( wr_sm_ns == WR_SM_END      )? 3'b010   : 3'b100
				              )
							  )
				              )
				              )
				              )
				              )
				              )
//				              )
                              );

assign       mem_ce      = ((rd_sm_ns == RD_SM_RDDATA0) || (rd_sm_ns == RD_SM_RDDATA1) || (wr_sm_ns == WR_SM_DATA0) || (wr_sm_ns == WR_SM_DATA1));
assign       mem_we      = ((wr_sm_ns == WR_SM_DATA0) || (wr_sm_ns == WR_SM_DATA1));
assign       mem_addr    = ((rd_sm_ns == RD_SM_RDDATA0) || (wr_sm_ns == WR_SM_DATA0)) ? 4'b0000 : (((rd_sm_ns == RD_SM_RDDATA1) || (wr_sm_ns == WR_SM_DATA1))? 4'b0001 : 4'b0000);
assign       mem_wr_data = (wr_sm_ns == WR_SM_DATA0)? URT_INTERCONN_SET : ((wr_sm_ns == WR_SM_DATA1)? URT_KEY_DISABLE_SET : URT_INTERCONN_SET);

assign       diag = {6'b0,BUSY,ERR};

always@(posedge SYSCLK)
  if(!RESET_N)
    begin
	  rd_sm_q <= RD_SM_IDLE;
	  wr_sm_q <= WR_SM_IDLE;
	end
  else
    begin
	  rd_sm_q <= rd_sm_ns;
	  wr_sm_q <= wr_sm_ns;
	end
						  
always@(posedge SYSCLK)
  if(!RESET_N)
    begin
	  GO <= 'b0;
	end
  else
    begin
	  GO <= BUSY? 1'b0 : ((((rd_sm_q == RD_SM_IDLE) && (rd_sm_ns == RD_SM_ENUFM))     ||
	         ((rd_sm_q == RD_SM_ENUFM) && (rd_sm_ns == RD_SM_RDUFM))                  ||
			 ((rd_sm_q == RD_SM_RDUFM) && (rd_sm_ns == RD_SM_RDDATA0))                ||
			 ((wr_sm_q == WR_SM_IDLE) && (wr_sm_ns == WR_SM_ENUFM))                   ||
			 ((wr_sm_q == WR_SM_ENUFM) && (wr_sm_ns == WR_SM_ERAS_UFM))               ||
			 ((wr_sm_q == WR_SM_DATA1) && (wr_sm_ns == WR_SM_WRUFM))
			)? 1'b1 : GO);
	end
	
always@(posedge SYSCLK)
  if(!RESET_N)
    begin
	  cnt         <= 'b0;
	  pwr_on_read <= 'b0;
	  BUSY_D      <= 'b0;
	end
  else
    begin
	  cnt         <= (cnt<=delay)? (cnt+1) : cnt;
	  pwr_on_read <= (cnt==delay)? 'b1 : 'b0;
	  BUSY_D      <= BUSY;
	end

always@(posedge SYSCLK)
  if(!RESET_N)
    begin
	  URT_INTERCONN_SET_Q   <= 'b0;
	  URT_KEY_DISABLE_SET_Q <= 'b0;
	end
  else
    begin
	  URT_INTERCONN_SET_Q   <= URT_INTERCONN_SET;
	  URT_KEY_DISABLE_SET_Q <= URT_KEY_DISABLE_SET;	  
	end
	
always@(posedge SYSCLK)
  if(!RESET_N)
    begin
	  URT_INTERCONN_OUT   <= 'b0;
	  URT_KEY_DISABLE_OUT <= 'b0;
	end
  else
    begin
	  URT_INTERCONN_OUT   <= (rd_sm_q == RD_SM_RDDATA0)? mem_rd_data : URT_INTERCONN_OUT;
	  URT_KEY_DISABLE_OUT <= (rd_sm_q == RD_SM_RDDATA1)? mem_rd_data : URT_KEY_DISABLE_OUT;	  
	end

always @(*) begin
    case (rd_sm_q)
        RD_SM_IDLE :   rd_sm_ns = (pwr_on_read && !BUSY)? RD_SM_ENUFM : RD_SM_IDLE;
		RD_SM_ENUFM:   rd_sm_ns = BUSY_N? RD_SM_RDUFM : RD_SM_ENUFM;
		RD_SM_RDUFM:   rd_sm_ns = BUSY_N? RD_SM_RDDATA0 : RD_SM_RDUFM;
        RD_SM_RDDATA0: rd_sm_ns = RD_SM_RDDATA1;
		RD_SM_RDDATA1: rd_sm_ns = RD_SM_END;
		RD_SM_END:     rd_sm_ns = RD_SM_IDLE;
        default:       rd_sm_ns  = RD_SM_IDLE;
    endcase
end

always @(*) begin
    case (wr_sm_q)
        WR_SM_IDLE :      wr_sm_ns = (write_trig && !BUSY)? WR_SM_ENUFM : WR_SM_IDLE;
		
		//only for test
		WR_SM_ENUFM:      wr_sm_ns = BUSY_N? WR_SM_ERAS_UFM : WR_SM_ENUFM;
		//WR_SM_ENUFM:      wr_sm_ns = BUSY_N? WR_SM_DATA0 : WR_SM_ENUFM;
		
		WR_SM_ERAS_UFM:   wr_sm_ns = BUSY_N? WR_SM_DATA0 : WR_SM_ERAS_UFM;
        WR_SM_DATA0:      wr_sm_ns = WR_SM_DATA1;
		WR_SM_DATA1:      wr_sm_ns = WR_SM_WRUFM;
		WR_SM_WRUFM:      wr_sm_ns = BUSY_N? WR_SM_END : WR_SM_WRUFM;
		WR_SM_END:        wr_sm_ns = WR_SM_IDLE;
        default:          wr_sm_ns = WR_SM_IDLE;
    endcase
end

	UFM_WB # (.READ_DELAY (2)) UUT 
        (
		.clk_i(SYSCLK),
		.rst_n(RESET_N),
		.cmd(cmd),
		.ufm_page('b0),
		.GO(GO),
		.BUSY(BUSY),
		.ERR(ERR),
		.mem_clk(SYSCLK),
		.mem_ce(mem_ce),
		.mem_we(mem_we),
		.mem_addr(mem_addr),
		.mem_wr_data(mem_wr_data),
		.mem_rd_data(mem_rd_data));

		
    // synopsys_translate_off
    reg [20*8-1:0] rd_msg;
    always @(rd_sm_q) begin
        case (rd_sm_q) 
            RD_SM_IDLE  : rd_msg = "RD_SM_IDLE  ";
            RD_SM_ENUFM    : rd_msg = "RD_SM_ENUFM    ";
            RD_SM_RDUFM    : rd_msg = "RD_SM_RDUFM    ";
            RD_SM_RDDATA0  : rd_msg = "RD_SM_RDDATA0  ";
			RD_SM_RDDATA1  : rd_msg = "RD_SM_RDDATA1  ";
			RD_SM_END  : rd_msg = "RD_SM_END  ";
            default    : rd_msg = "XXXXXXXXXXX";
        endcase
    end
    // synopsys_translate_on

	// synopsys_translate_off
    reg [20*8-1:0] wr_msg;
    always @(wr_sm_q) begin
        case (wr_sm_q) 
            WR_SM_IDLE  : wr_msg = "WR_SM_IDLE  ";
            WR_SM_ENUFM    : wr_msg = "WR_SM_ENUFM    ";
            WR_SM_ERAS_UFM    : wr_msg = "WR_SM_ERAS_UFM    ";
            WR_SM_DATA0  : wr_msg = "WR_SM_DATA0  ";
			WR_SM_DATA1  : wr_msg = "WR_SM_DATA1  ";
			WR_SM_WRUFM  : wr_msg = "WR_SM_WRUFM  ";
			WR_SM_END  : wr_msg = "WR_SM_END  ";
            default    : wr_msg = "XXXXXXXXXXX";
        endcase
    end
    // synopsys_translate_on
		
endmodule