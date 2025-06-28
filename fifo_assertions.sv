import shared_pkg::*;
module fifo_assertions (data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
input logic [FIFO_WIDTH-1:0] data_out;
input logic wr_ack, overflow, underflow;
input logic full, empty, almostfull, almostempty;

  
always_comb begin
  if (!rst_n) begin
    reset: assert final (wr_ptr == 0 && rd_ptr == 0 && count == 0 && wr_ack == 0 && overflow == 0 && underflow == 0)
      else $error("RESET ERROR");
  end
end

wr_ack1: assert property (@(posedge clk) disable iff (!rst_n)
  (wr_en && !full) |=> wr_ack)
  else $error("WR_ACK ERROR");

overflow1: assert property (@(posedge clk) disable iff (!rst_n)
  (wr_en && full) |=> overflow)
  else $error("OVERFLOW ERROR");

underflow1: assert property (@(posedge clk) disable iff (!rst_n)
  (rd_en && empty) |=> underflow)
  else $error("UNDERFLOW ERROR");

wr_ptr1: assert property (@(posedge clk) disable iff (!rst_n)
  (wr_en && !full) |=> (wr_ptr == (($past(wr_ptr) + 1) % FIFO_DEPTH)))
  else $warning("WR_PTR WARNING");

rd_ptr1: assert property (@(posedge clk) disable iff (!rst_n)
  (rd_en && !empty) |=> (rd_ptr == (($past(rd_ptr) + 1) % FIFO_DEPTH)))
  else $warning("RD_PTR WARNING");



always_comb begin
  count1: assert final (count <= FIFO_DEPTH)
    else $error("COUNT ERROR");
  wr_ptr2: assert final (wr_ptr < FIFO_DEPTH)
    else $error("WR_PTR ERROR");
  rd_ptr2: assert final (rd_ptr < FIFO_DEPTH)
    else $error("RD_PTR ERROR");

  almostempty1: assert final (((count == 1) == almostempty))
  else $error("ALMOSTEMPTY FLAG ERROR");
  
  almostfull1: assert final (((count == FIFO_DEPTH - 1) == almostfull))
  else $error("ALMOSTFULL FLAG ERROR");
  empty1: assert final ( ((count == 0) == empty))
  else $error("EMPTY FLAG ERROR");

full1: assert final ( ((count == FIFO_DEPTH) == full))
  else $error("FULL FLAG ERROR");
end
endmodule
