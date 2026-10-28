class scoreboard;
  transaction tr;
  transaction trref;
  mailbox #(transaction)mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(tr);     
      if( tr.pwrite==0 && tr.psel==1 && tr.penable==1)
        begin
          
          if(tr.prdata==tr.pwdata)
            $display("data matched");
          else
            $display("data mismatched");
        end
          
    end
  endtask 
  
endclass