class transaction;
   rand bit [31:0] paddr;
   rand bit [7:0] pwdata;
   bit psel;
   bit pwrite;
   bit penable;
   bit pready;
   bit [7:0] prdata;
  
  constraint addr_range{paddr inside {[0:15]};} 
  constraint data_range {pwdata inside{[0:7]};}
  
  function new();
    this.paddr=paddr;
    this.pwdata=pwdata;
    this.psel=psel;
    this.pwrite=pwrite;
    this.pready=pready;
    this.penable=penable;
    this.prdata=prdata;
  endfunction
  
  function void display(input string tag); 
    $display("[%0s] addr=%p ,data=%p, psel=%p, pwrite=%p,pready=%p",tag,paddr,pwdata,psel,pwrite,pready);
  endfunction
endclass