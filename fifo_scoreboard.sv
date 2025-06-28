package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;
    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)
        uvm_analysis_export  #(fifo_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
        fifo_seq_item seq_item_sb;
        
        //signals for golden model
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        logic [FIFO_WIDTH-1:0] data_out_ref; 
        logic wr_ack_ref, overflow_ref;
        bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        logic [2:0]wr_pointer=0; 
        logic [2:0]rd_pointer=0;
        logic [FIFO_WIDTH-1:0] my_mem[$]; 

        int error_count=0;
        int correct_count=0;

        function new(string name="fifo_scoreboard", uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_fifo = new("sb_fifo",this);
            sb_export = new("sb_export",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model;
                if((seq_item_sb.data_out !== data_out_ref)) begin
                    `uvm_error("run_phase",$sformatf("Comparisons Failed, Expected data_out=%0d, Actual data out=%0d",data_out_ref,seq_item_sb.data_out));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase",$sformatf("Correct outputs"),UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        task ref_model;
        if(!seq_item_sb.rst_n)begin
        wr_pointer=0;
        rd_pointer=0;
        my_mem.delete();
        almostempty_ref=0;
        almostfull_ref=0;
        full_ref=0;
        empty_ref=1;
        wr_ack_ref=0;
        overflow_ref=0;
        underflow_ref=0;
    end
        else if(seq_item_sb.rst_n)begin
        if(seq_item_sb.rd_en && seq_item_sb.wr_en && (empty_ref || full_ref) )begin
            if(empty_ref)begin //write condition 
            my_mem.push_back(seq_item_sb.data_in); //--> one elemnt of 16 bits in queue
            wr_pointer=(wr_pointer+1)%FIFO_DEPTH;
            wr_ack_ref=1;
            underflow_ref=1;
            overflow_ref=0;
            almostfull_ref=0;
            almostempty_ref=1;
            full_ref=0;
            empty_ref=0;
            //almost full condition 
            if(my_mem.size()==FIFO_DEPTH-1)begin 
                almostfull_ref=1;
                almostempty_ref=0;
                full_ref=0;
                wr_ack_ref=1;
            end
            else if(my_mem.size()==FIFO_DEPTH)begin //write pointer shpuld be ahead of read
            full_ref=1;
            empty_ref=0;
            wr_ack_ref=0;
            almostempty_ref=0;
            almostfull_ref=0;
            end 
        end

        else if (full_ref)begin //read condition
            data_out_ref=my_mem.pop_front(); //--> 1st 16 bits got out 
            rd_pointer=(rd_pointer+1)%FIFO_DEPTH;
            overflow_ref=1;
            wr_ack_ref=0;
            almostfull_ref=1;
            almostempty_ref=0;
            underflow_ref=0;
            empty_ref=0;
            full_ref=0;
            //almost empty condition
            if(FIFO_DEPTH-my_mem.size()==7)begin
                almostempty_ref=1;
                almostfull_ref=0;
                wr_ack_ref=0;
            end
            else if(my_mem.size()==0)begin
                empty_ref=1;
                full_ref=0;
                wr_ack_ref=0;
            end
        end
        return; //get out of task--> Dont enter in further cases 
    end

    ////////////////////////WRITE OPERATION/////////////////////// 
    if(seq_item_sb.wr_en && !full_ref )begin
            //--> 1st 16 bits got in
            my_mem.push_back(seq_item_sb.data_in); //--> one elemnt of 16 bits in queue
            wr_pointer=(wr_pointer+1)%FIFO_DEPTH;
            wr_ack_ref=1;
            overflow_ref=0;
            empty_ref=0;
            //almost full condition 
            if(my_mem.size()==FIFO_DEPTH-1)begin 
                almostfull_ref=1;
                almostempty_ref=0;
                full_ref=0;
            end
            else if(my_mem.size()==FIFO_DEPTH)begin //write pointer shpuld be ahead of read
            full_ref=1;
            empty_ref=0;
            almostfull_ref=0;
            almostempty_ref=0;
            end 
            else if(my_mem.size()==1)begin
                almostempty_ref=1;
                almostfull_ref=0;
                empty_ref=0;
                full_ref=0;
                wr_ack_ref=1;
            end
    end
    else if(seq_item_sb.wr_en && full_ref )begin
        overflow_ref=1;
        wr_ack_ref=0; //write hasn't succeeded
        underflow_ref=0;
    end

    //////////////READ OPERATION///////////////////
    if(seq_item_sb.rd_en && !empty_ref )begin
        data_out_ref=my_mem.pop_front(); //--> 1st 16 bits got out 
        rd_pointer=(rd_pointer+1)%FIFO_DEPTH;
        underflow_ref=0;
        full_ref=0;
        //almost empty condition
        if(FIFO_DEPTH-my_mem.size()==7)begin
            almostempty_ref=1;
            almostfull_ref=0;
            full_ref=0;
            empty_ref=0;
        end
        else if(my_mem.size()==0)begin
            empty_ref=1;
            full_ref=0;
            almostempty_ref=0;
            almostfull_ref=0;
        end
        else if(my_mem.size()==7)begin //read only one 
            almostfull_ref=1;
            almostempty_ref=0;
            full_ref=0;
            empty_ref=0;
        end
    end
    else if(seq_item_sb.rd_en && empty_ref )begin
        underflow_ref=1;
        overflow_ref=0;
    end
     end 
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total number of errors:%0d",error_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total number of correct transactions:%0d",correct_count),UVM_MEDIUM);
        endfunction
    endclass 
endpackage