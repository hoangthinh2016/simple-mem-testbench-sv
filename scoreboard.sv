// get the transaction from generator and compare with the output from the DUT to 
class scoreboard;

  //score
  bit[4:0] score;
  
  //used to count the number of transactions
  int no_transactions;

  //creating mailbox handles
  mailbox gen2score;
  mailbox mon2score;

  //constructor
  function new(mailbox mon2score, mailbox gen2score); //changed
    //getting the mailbox handles from  environment 
    this.gen2score = gen2score;
    this.mon2score = mon2score;
  endfunction

// scoreboard get the transaction and compare with the transaction from monitor
  task main;
    forever begin
      transaction gen_trans, mon_trans;
        score = 4'b0;
      	mon2score.get(mon_trans);
        gen2score.get(gen_trans);
        no_transactions++;
        if(gen_trans.wr_en) begin
          score[0] = ((gen_trans.wr_en == mon_trans.wr_en) ? 1 : 0);
          score[1] = ((gen_trans.addr == mon_trans.addr) ? 1 : 0);
          score[2] = ((gen_trans.wdata == mon_trans.wdata) ? 1 : 0);
          score[3] = ((gen_trans.cnt == mon_trans.cnt) ? 1 : 0);
          if(score == 15) $display("Transaction %0d checked!!", no_transactions);
          else $display("Error transaction %0d! -- %0b", no_transactions, score);
        end
        else if(gen_trans.rd_en)  begin
          score[0] = ((gen_trans.rd_en == mon_trans.rd_en) ? 1 : 0);
          score[1] = ((gen_trans.addr == mon_trans.addr) ? 1 : 0);
          score[2] = ((memory.mem[gen_trans.addr] == mon_trans.rdata) ? 1 : 0);
          score[3] = ((gen_trans.cnt == mon_trans.cnt) ? 1 : 0);
          if(score == 15) $display("Transaction %0d checked!!", no_transactions);
          else $display("Error transaction %0d! -- %0b", no_transactions, score);
        end
    end
  endtask

endclass