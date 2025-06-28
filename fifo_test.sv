////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package fifo_test_pkg;
import fifo_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_config_pkg::*;
import fifo_env_pkg::*;
import fifo_sequence_pkg::*;
class fifo_test extends uvm_test;
 `uvm_component_utils(fifo_test)
  fifo_env env;
  fifo_wr_sequence wr_seq;
  fifo_reset_sequence reset_seq;
  fifo_rd_sequence rd_seq;
  fifo_wr_rd_sequence wr_rd_seq;
  fifo_config fifo_cfg;

  function new(string name="fifo_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env",this);
    fifo_cfg = fifo_config::type_id::create("fifo_cfg",this);
    wr_seq = fifo_wr_sequence::type_id::create("wr_seq",this); 
    reset_seq = fifo_reset_sequence::type_id::create("reset_seq",this);
    rd_seq = fifo_rd_sequence::type_id::create("rd_seq",this); 
    wr_rd_seq = fifo_wr_rd_sequence::type_id::create("wr_rd_seq",this);


    if(!uvm_config_db #(virtual fifo_if)::get(this,"","fifo_if",fifo_cfg.fifo_vif)) begin
      `uvm_fatal("build_phase", "test - unable to get the virtual interface of the fifo from the uvm config_db")
    end
    uvm_config_db #(fifo_config)::set(this,"*","CFG",fifo_cfg);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase", "reset asserted",UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "reset deasserted",UVM_LOW)
    ////////////////WRITE///////////////////////
    `uvm_info("run_phase", "stim gen started--> write only op",UVM_LOW)
    wr_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "stim gen ended",UVM_LOW)
    ///////////////////////READ/////////////////////////////
     `uvm_info("run_phase", "stim gen started--> read only op",UVM_LOW)
    rd_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "stim gen ended",UVM_LOW)
    ////////////////////////WRITE AND READ////////////////////////////
     `uvm_info("run_phase", "stim gen started--> read and write op",UVM_LOW)
    wr_rd_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "stim gen ended",UVM_LOW)
    phase.drop_objection(this);
  endtask 
endclass
endpackage