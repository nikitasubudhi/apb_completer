class apb_back2back_write_test;
  transaction tr;
  virtual apb_if vif;
  bit [31:0] addr_temp[$];
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
  
  task write();
    repeat(3) begin
      tr=new();
      tr.randomize;
      addr_temp.push_back(tr.paddr);
      vif.paddr<=tr.paddr;
      vif.pwdata<=tr.pwdata;
      vif.pwrite<= 1'b1;
      vif.psel<= 1'b1;
      vif.penable<=1'b0;
      @(posedge vif.pclk);
      vif.penable<=1'b1;
      wait(vif.pready==1);
      $display("pready asserted 1");
      $display("addr=%0d, data=%0d",vif.paddr,vif.pwdata);
      @(posedge vif.pclk);
      vif.pwrite<= 1'b0;
      vif.psel<= 1'b0;
      vif.penable<=1'b0;

    end
  endtask
endclass