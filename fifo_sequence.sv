package fifo_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
//write sequence 
class fifo_wr_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_wr_sequence)
    fifo_seq_item seq_item;
    function new(string name="fifo_wr_sequence");
        super.new(name);
    endfunction
    task body();
        seq_item = fifo_seq_item::type_id::create("seq_item");
        repeat(5) begin
            start_item(seq_item);
            assert(seq_item.randomize());
            seq_item.wr_en = 1'b1;
            seq_item.rd_en = 1'b0;
            finish_item(seq_item);
        end
    endtask
endclass
//reset sequence 
class fifo_reset_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_reset_sequence)
    fifo_seq_item seq_item;
    function new(string name="fifo_reset_sequence");
        super.new(name);
    endfunction
    task body();
        repeat(100) begin
        seq_item = fifo_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 1'b0;
        seq_item.wr_en = 1'b0;
        seq_item.rd_en = 1'b0;
        seq_item.data_in = 0;
        finish_item(seq_item);
        end
    endtask
endclass 
//read sequence 
class fifo_rd_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_rd_sequence)
    fifo_seq_item seq_item;
    function new(string name="fifo_rd_sequence");
        super.new(name);
    endfunction
    task body();
        repeat(100) begin
        seq_item = fifo_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        assert(seq_item.randomize());
        seq_item.wr_en = 1'b0;
        seq_item.rd_en = 1'b1;
        finish_item(seq_item);
        end
    endtask
endclass 
//write and read sequence 
class fifo_wr_rd_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_wr_rd_sequence)
    fifo_seq_item seq_item;
    function new(string name="fifo_wr_rd_sequence");
        super.new(name);
    endfunction
    task body();
        repeat(100) begin
        seq_item = fifo_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        assert(seq_item.randomize());
        seq_item.rd_en=1'b1;
        seq_item.wr_en = 1'b1;
        finish_item(seq_item);
        end
        repeat(10000)begin
        start_item(seq_item);
        assert(seq_item.randomize()); 
        finish_item(seq_item);
        end
    endtask
endclass 
endpackage