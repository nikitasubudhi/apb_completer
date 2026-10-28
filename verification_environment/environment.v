class environment;
  generator gen;
  driver drv;
  monitor mon; 
  scoreboard sco;
  
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) msmbx;
  virtual apb_if vif;
  
  function new(virtual apb_if vif);
    gdmbx=new();
    gen=new(gdmbx);
    drv=new(gdmbx);
    msmbx=new();
    mon=new(msmbx);
    sco=new(msmbx);
    this.vif=vif;
    drv.vif=this.vif;
    mon.vif=this.vif;
  endfunction
  
   task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.write();
      drv.read();
      mon.run();
      sco.run();
    join
  endtask
  
  task run();
    pre_test();
    test();
  endtask
endclass