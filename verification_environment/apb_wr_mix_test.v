class apb_wr_mix_test;
  transaction tr;
  virtual apb_if vif;

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
    repeat(3) begin
      tr=new();
      tr.randomize;
      vif.paddr<=tr.paddr;
      vif.pwdata<=tr.pwdata;
      vif.pwrite<= 1'b1;
      vif.psel<= 1'b1;
      vif.penable<=1'b0;
      @(posedge vif.pclk);
      vif.penable<=1'b1;
      wait(vif.pready==1);
      $display("pready asserted");
      @(posedge vif.pclk);
      vif.pwrite<= 1'b0;
      vif.psel<= 1'b0;
      vif.penable<=1'b0;
      
      repeat(2) @(posedge vif.pclk);  //read
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