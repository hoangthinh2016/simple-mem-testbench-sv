`include "env.sv"
program test(mem_intf intf);    
  //declaring environment instance
  environment env;
  access_type_t acc;
  
  initial begin
    //creating environment
    env = new(intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 16;
    
    env.gen.acc = WR;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();

    //run 2nd time for writing test
    //env.gen.repeat_count = 4;
    
    //env.gen.acc= WR;
    
    //calling run of env, it interns calls generator and driver main tasks.
    //env.run();
  end
endprogram