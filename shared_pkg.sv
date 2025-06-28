package shared_pkg;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    bit [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    bit [max_fifo_addr:0] count;
endpackage
