class apb_back2back_read_test;
  apb_back2back_write_test wt;
  transaction tr;
  virtual apb_if vif;
  
  function new(virtual apb_if vif,apb_back2back_write_test wt);
    this.vif=vif;
    this.wt=wt;
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
  
  task read();
    begin
      repeat(2) @(posedge vif.pclk); 
      tr=new();
      foreach(wt.addr_temp[i]) begin
        vif.paddr<=wt.addr_temp[i];
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
    end
  endtask
endclass