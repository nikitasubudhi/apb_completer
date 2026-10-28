class generator;
  transaction tr;
  mailbox #(transaction)mbx;
  
  function new(mailbox #(transaction)mbx);
     this.mbx=mbx;
   endfunction
  
  task run();
    repeat(1) begin
      tr=new();
      tr.randomize;
      mbx.put(tr);
      tr.display("GEN");
    end
    
  endtask
endclass