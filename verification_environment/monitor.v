class monitor;
  transaction tr;
  mailbox #(transaction) mbx;
  virtual apb_if vif;
  
  function new(mailbox #(transaction) mbx);
    this.mbx=mbx;
  endfunction

  task run();
    forever begin
      @(posedge vif.pclk);
      if(vif.psel && vif.penable && vif.pready)
      begin
        tr=new();
        tr.paddr=vif.paddr;
        tr.pwdata=vif.pwdata;
        tr.pwrite=vif.pwrite;
        tr.psel=vif.psel;
        tr.penable=vif.penable;
        tr.pready=vif.pready;
        tr.prdata=vif.prdata;
        mbx.put(tr);
        
        tr.display("MON");
      end
    end
  endtask
endclass