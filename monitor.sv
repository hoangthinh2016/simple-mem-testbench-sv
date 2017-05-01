// The test is modified to write to 8 mem addresses then read from those
// The functional coverage covers rdata, wdata, and addr port
// The command to compile the program: vcs -sverilog -ntb_opts dtm tb_top.sv dut.sv
// The command to generate the coverage report: urg -dir simv.vdb
// The reports are generated in the urgReport folder in html format

`define MON_IF mem_vif.MONITOR.monitor_cb
class monitor;
    //Mailbox handle
    mailbox mon2score;

    //Transaction handle
    transaction trans;

    //creating virtual interface handle
    virtual mem_intf mem_vif;

    //Define covergroup
    //Updated the number of bins to cover 4 bit width mem
    covergroup CovMem;
        coverpoint trans.addr {
            bins zero = {0};
            bins one = {1};
            bins two = {2};
            bins three = {3};
            bins four = {4};
            bins five = {5};
            bins six = {6};
            bins seven = {7};
        }
        coverpoint trans.rd_en {
            bins on = {1};
            bins off = {0};
        }
        coverpoint trans.wr_en {
            bins on = {1};
            bins off = {0};
        }
    endgroup

    //constructor
    function new(virtual mem_intf mem_vif, mailbox mon2score);
        //getting the interface
        this.mem_vif = mem_vif;
        //getting the mailbox handles from  environment 
        this.mon2score = mon2score;
        CovMem = new();
    endfunction

    function get_signals(transaction trans);
            trans.addr  = `MON_IF.addr;
            trans.wdata = `MON_IF.wdata;
            trans.rdata = `MON_IF.rdata;
           // trans.rd_en = `MON_IF.rd_en;
           // trans.wr_en = `MON_IF.wr_en;
    endfunction

    task main;
        forever begin
            @(posedge mem_vif.MONITOR.clk);
            if(`MON_IF.rd_en || `MON_IF.wr_en) begin
                trans = new();
                if(`MON_IF.rd_en)   trans.rd_en = 1;
                else if (`MON_IF.wr_en) trans.wr_en = 1;
                @(posedge mem_vif.MONITOR.clk);
                get_signals(trans);
                mon2score.put(trans);
                $display("MONITOR --> SCORE");
                CovMem.sample();
            end
        end
    endtask

endclass