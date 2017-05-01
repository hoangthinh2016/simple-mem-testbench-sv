class generator;
  //access type
  access_type_t acc;

  //declaring transaction class 
  rand transaction driv_trans;
  rand transaction score_trans;

  //declaring wr and rd trans
  wr_trans wtrans;
  rd_trans rtrans;
  
  //repeat count, to specify number of items to generate
  int repeat_count;
  int count;
  
  //mailbox, to generate and send the packet to driver and scoreboard
  mailbox gen2driv;
  mailbox gen2score; // new
  
  //event
  event ended;
  
  //constructor
  function new(mailbox gen2driv, mailbox gen2score, access_type_t acc); // changed
    //getting the mailbox handles from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.gen2driv = gen2driv;
    this.gen2score = gen2score; // new
    this.acc = acc; // new
    driv_trans = new();
    score_trans = new();
    count = 0;
  endfunction

  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    repeat(repeat_count) begin
      if(count == 8) begin
        $display("Got in here!");
        case (acc)
          RD: acc = WR;
          WR: acc = RD;
        endcase
      end
      case (acc)
        RD: begin 
          $display("RD transaction!!"); 
          rtrans = new(); 
          driv_trans = rtrans;
          end
        WR: begin
          $display("WR transaction!!"); 
          wtrans = new(); 
          driv_trans = wtrans;
          end
      endcase
      if( !driv_trans.randomize() ) $fatal("Gen:: trans randomization failed");    
      gen2driv.put(driv_trans);
      score_trans = driv_trans;
      gen2score.put(score_trans);
      count++;
    end
    -> ended;
  endtask
  
endclass