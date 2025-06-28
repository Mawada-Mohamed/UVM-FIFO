import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test_pkg::*;
module top();
  bit clk;

  initial begin
    clk=0;
    forever #1 clk = ~clk;
  end

  fifo_if f_if(clk);
  FIFO DUT(f_if.data_in, f_if.wr_en, f_if.rd_en, f_if.clk, f_if.rst_n, f_if.full, f_if.empty, 
  f_if.almostfull, f_if.almostempty,f_if.wr_ack, f_if.overflow, f_if.underflow, f_if.data_out);

    // Bind the assertions to the DUT instance
    bind FIFO fifo_assertions assertions_inst(f_if.data_in, f_if.wr_en, f_if.rd_en, f_if.clk, f_if.rst_n, f_if.full,
    f_if.empty, f_if.almostfull, f_if.almostempty, f_if.wr_ack,
    f_if.overflow, f_if.underflow, f_if.data_out);

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top", "fifo_if", f_if);
    run_test("fifo_test");  
  end
endmodule
