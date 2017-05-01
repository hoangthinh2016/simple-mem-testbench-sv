//access type for transaction
typedef enum{
  RD,
  WR
}access_type_t;

class transaction;
  //declaring the transaction items
  rand bit [2:0] addr;
  rand bit       wr_en;
  rand bit       rd_en;
  rand bit [7:0] wdata;
       bit [7:0] rdata;
       bit [2:0] cnt;
  
  //constaint, to generate any one among write and read
  constraint wr_rd_c { wr_en != rd_en; }; 
  
  //postrandomize function, displaying randomized values of items 
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    $display("\t addr  = %0h",addr);
    if(wr_en) $display("\t wr_en = %0h\t wdata = %0h",wr_en,wdata);
    if(rd_en) $display("\t rd_en = %0h\t rdata = %0h",rd_en,rdata);
    $display("-----------------------------------------");
  endfunction
  
endclass

class rd_trans extends transaction;
    static bit[2:0] cnt;

    function void pre_randomize();
      wr_en.rand_mode(0);
      rd_en.rand_mode(0);
      addr.rand_mode(0);
        wr_en = 0;
        rd_en = 1;
        addr  = this.cnt;
      cnt++;
    endfunction
    
endclass

class wr_trans extends transaction;
    static bit[2:0] cnt;
    
    function void pre_randomize();
      wr_en.rand_mode(0);
      rd_en.rand_mode(0);
      addr.rand_mode(0);
        wr_en = 1;
        rd_en = 0;
        addr  = this.cnt;
      cnt++;
    endfunction
    
endclass