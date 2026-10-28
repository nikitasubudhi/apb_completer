class driver;
  transaction tr;
  mailbox #(transaction)mbx;
  virtual apb_if vif;
  
  function new(mailbox #(transaction)mbx);
    this.mbx=mbx;
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
  
  task write();
    begin
      mbx.get(tr);
      vif.paddr<=tr.paddr;
      vif.pwdata<=tr.pwdata;
      vif.pwrite<= 1'b1;
      vif.psel<= 1'b1;
      vif.penable<=1'b0;
      @(posedge vif.pclk);
      vif.penable<=1'b1;
      wait(vif.pready==1);
      $display("pready asserted");
      tr.display("DRIW");
      @(posedge vif.pclk);
      vif.pwrite<= 1'b0;
      vif.psel<= 1'b0;
      vif.penable<=1'b0;
      @(posedge vif.pclk);
    end
  endtask
  
  task read();
    begin
      repeat(6) @(posedge vif.pclk);
      vif.paddr<= tr.paddr;
      vif.pwrite<=1'b0;
      vif.psel<=1'b1;
      vif.penable<=1'b0;
      @(posedge vif.pclk);
      vif.penable<=1'b1;
      wait(vif.pready==1);
      $display("pready asserted");
      $display("prdata=%0h",vif.prdata);
      @(posedge vif.pclk);
      vif.psel<=1'b0;
      vif.penable<=1'b0;
    end
  endtask
  
    
endclass