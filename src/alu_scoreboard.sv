include "define.sv"
class alu_scoreboard;

  mailbox #(alu_transaction)mbx_rs;
  mailbox #(alu_transaction)mbx_ms;

  alu_transaction refscore_trans,monscore_trans;
  int MATCH,MISMATCH;

  function new(mailbox #(alu_transaction)mbx_rs,mailbox #(alu_transaction)mbx_ms);
    this.mbx_rs=mbx_rs;
    this.mbx_ms=mbx_ms;
  endfunction

  task start();
    begin
      for(int i=0;i<`no_of_transaction;i=i+1)
      begin

        refscore_trans=new();
        monscore_trans=new();
        fork
          begin
        #0 mbx_rs.get(refscore_trans);
            $display("----------------SCOREBOARD(from reference)---------- t=%t\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d |\n",$time,refscore_trans.RES,refscore_trans.ERR,refscore_trans.OFLOW,refscore_trans.COUT,refscore_trans.G,refscore_trans.L,refscore_trans.E);
          end
          begin
        #0 mbx_ms.get(monscore_trans);
            $display("----------------SCOREBOARD(from monitor)----------t=%t \n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d |\n",$time,monscore_trans.RES,monscore_trans.ERR,monscore_trans.OFLOW,monscore_trans.COUT,monscore_trans.G,monscore_trans.L,monscore_trans.E);
          end
        join
        compare_report();
          end
    end
  endtask

  task compare_report();
    begin
      if((refscore_trans.RES==monscore_trans.RES)||
         (refscore_trans.ERR==monscore_trans.ERR)||
         (refscore_trans.OFLOW==monscore_trans.OFLOW)||
         (refscore_trans.COUT==monscore_trans.COUT)||
         (refscore_trans.G==monscore_trans.G)||
         (refscore_trans.L==monscore_trans.L)||
         (refscore_trans.E==monscore_trans.E))
          begin
            $display("----------------SCOREBOARD(from reference, COMPARE REPORT)----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d |t=%d\n  ",refscore_trans.RES,refscore_trans.ERR,refscore_trans.OFLOW,refscore_trans.COUT,refscore_trans.G,refscore_trans.L,refscore_trans.E,$time);
            $display("----------------SCOREBOARD(from monitor,COMPARE REPORT)----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d | t=%d \n ",monscore_trans.RES,monscore_trans.ERR,monscore_trans.OFLOW,monscore_trans.COUT,monscore_trans.G,monscore_trans.L,monscore_trans.E,$time);
            MATCH++;
            $display("DATA MATCH SUCCESSFUL MATCH=%d",MATCH);
            $display("\n");
          end
        else
          begin
              $display("----------------SCOREBOARD(from reference, COMPARE REPORT)----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d t=%d |\n",refscore_trans.RES,refscore_trans.ERR,refscore_trans.OFLOW,refscore_trans.COUT,refscore_trans.G,refscore_trans.L,refscore_trans.E,$time);
            $display("----------------SCOREBOARD(from monitor,COMPARE REPORT )----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d | t-%d\n",monscore_trans.RES,monscore_trans.ERR,monscore_trans.OFLOW,monscore_trans.COUT,monscore_trans.G,monscore_trans.L,monscore_trans.E,$time);
            MISMATCH++;
            $display("DATA MATCH FAILED MISMATCH=%d",MISMATCH);
            $display("\n");
          end
  end
endtask
endclass
