package fifo_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

class fifo_seq_item extends uvm_sequence_item;
`uvm_object_utils(fifo_seq_item)
rand logic [FIFO_WIDTH-1:0] data_in;
rand bit wr_en, rd_en;
rand bit rst_n;
logic [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow;
bit full, empty, almostfull, almostempty, underflow;
int RD_EN_ON_DIST=30;
int WR_EN_ON_DIST=70;

//class constructor 
function new(string name="fifo_seq_item");
super.new(name);        
endfunction 

//constraint blocks
constraint c_fifo{
//constraint_1
rst_n dist {0:=5,1:=95};
//constraint_2
wr_en dist{1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};
//constraint_3
rd_en dist{1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};
}

endclass  
endpackage