`include "package.sv"
import my_pkg::*;

module tb;
  logic pclk;
  logic presetn;
  logic [31:0] paddr;
  logic psel;
  logic penable;
  logic [7:0] pwdata;
  logic pwrite;
  logic [7:0] prdata;
  logic pready;
  logic pslverr;
  
  initial begin
    vif.pclk=1'b0;
  end
  
  always #5 vif.pclk = ~vif.pclk;
       
  environment env;
  apb_back2back_write_test b2bwrite;
  apb_back2back_read_test b2bread;
  
//    initial begin
//      vif.presetn=1'b0;
//      #10; vif.presetn=1'b1;
//      #40; vif.presetn=1'b0;
//      env.pre_test();
//    end
  apb_if vif();
  apb_s dut(.pclk(vif.pclk),
            .presetn(vif.presetn),
            .paddr(vif.paddr), 
            .psel(vif.psel),
            .penable(vif.penable),
            .pwdata(vif.pwdata),
            .pwrite(vif.pwrite),
            .prdata(vif.prdata),
            .pready(vif.pready),
            .pslverr(vif.pslverr));
  
  initial begin
//      env=new(vif);
      b2bwrite=new(vif);
      b2bread=new(vif,b2bwrite);
    
      fork
        begin
//          env.run(); 
        end
        
        begin
//          repeat(12)@(posedge vif.pclk);
          b2bwrite.reset();
          b2bwrite.write();
          b2bread.reset();
          b2bread.read();
        end
        
      join

  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    #1200 $finish;
  end
endmodule