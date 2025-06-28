////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Interface
// 
////////////////////////////////////////////////////////////////////////////////
interface fifo_if (clk);
input clk;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow;
bit full, empty, almostfull, almostempty, underflow;
endinterface 