`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "monitor.sv"

class environment;
  
  //generator and driver instance
  generator gen;
  driver    driv;
  scoreboard score; // new
  monitor	mon;	// new
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox gen2score; // new
  mailbox mon2score; // new
  
  //access type handle
  access_type_t acc;

  //virtual interface
  virtual mem_intf mem_vif;

  //constructor
  function new(virtual mem_intf mem_vif);
    //get the interface from test
    this.mem_vif = mem_vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    gen2score = new(); // new
    mon2score = new(); // new
    
    //creating generator and driver
    gen  = new(gen2driv, gen2score, acc); // changed
    driv = new(mem_vif, gen2driv); // changed 
    score = new(mon2score, gen2score); // new
    mon = new(mem_vif, mon2score); // new

  endfunction
  
  //
  task pre_test();
    driv.reset();
   //driv.wr_sample_data(); // Write some data to mem to test the read test
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
	  mon.main(); //new
    score.main(); // new
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == score.no_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass

