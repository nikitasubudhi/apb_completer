class apb_random_rw_test;
  rand bit [31:0]paddr;
  rand bit [7:0]pwdata;
  rand bit pwrite;
  bit psel,penable,pready;
  virtual apb_if vif;
  
  constraint addr_range{paddr inside {[0:15]};} 
  constraint data_range {pwdata inside{[0:7]};}
  
  
  function new(virtual apb_if vif);
    this.vif=vif;
  endfunction
  
  task reset();
    vif.presetn<=1'b0;
    vif.psel<=1'b0;
    vif.pwrite<=1'b0;
    vif.penable<=1'b0;
    vif.paddr<=1'b0;
    vif.pwdata<=1'b0;
    #5; vif.presetn<=1'b1;
  endtask
  
  task write_read();
    repeat(15) begin
      this.randomize;
      if (pwrite==1)
        begin
          vif.paddr<=paddr;
          vif.pwdata<=pwdata;
          vif.pwrite<= 1'b1;
          vif.psel<= 1'b1;
          vif.penable<=1'b0;
          @(posedge vif.pclk);
          vif.penable<=1'b1;
          wait(vif.pready==1);
          $display("pready asserted");
          $display("WRITE: address=%0d, data=%0d",paddr, pwdata);
          @(posedge vif.pclk);
          vif.pwrite<= 1'b0;
          vif.psel<= 1'b0;
          vif.penable<=1'b0;
        end
      else
        begin
          repeat(2) @(posedge vif.pclk);  //read
          vif.paddr<= paddr;
          vif.pwrite<=1'b0;
          vif.psel<=1'b1;
          vif.penable<=1'b0;
          @(posedge vif.pclk);
          vif.penable<=1'b1;
          wait(vif.pready==1);
          $display("pready asserted");
          $display("READ: address=%0d, prdata=%0d",paddr, vif.prdata);
          @(posedge vif.pclk);
          vif.psel<=1'b0;
          vif.penable<=1'b0;
        end
    end
  endtask
endclass