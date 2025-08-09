`include "define.sv"

class alu_scoreboard;

alu_transaction ref2sb;
alu_transaction mon2sb;
mailbox #(alu_transaction) mbx_ms;
mailbox #(alu_transaction) mbx_rs;

function new(mailbox #(alu_transaction) mbx_ms,mailbox #(alu_transaction) mbx_rs);
this.mbx_ms=mbx_ms;
this.mbx_rs=mbx_rs;
endfunction

int MATCH,MISMATCH;
task start();
  for(int i=0;i<`no_of_transaction;i++)
 begin
   //$display("[SCOREBOARD] RESULTS FOR TRANSACTION %0d",i+1);
  ref2sb=new();
  mon2sb=new();
  fork
    begin
     mbx_ms.get(mon2sb);
      $display("----------------SCOREBOARD(from monitor)----------t=%t i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i,mon2sb.OPA,mon2sb.OPB,mon2sb.CIN,mon2sb.CE,mon2sb.MODE,mon2sb.CMD,mon2sb.INP_VALID,mon2sb.RES,mon2sb.ERR,mon2sb.OFLOW,mon2sb.G,mon2sb.L,mon2sb.E);
     $display("---------------------------------------------------------------------------------");
    end
    begin
     mbx_rs.get(ref2sb);
     $display("---------------------------------------------------------------------------------");
      $display("----------------SCOREBOARD(from reference)---------- t=%t i=%d:OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i,ref2sb.OPA,ref2sb.OPB,ref2sb.CIN,ref2sb.CE,ref2sb.MODE,ref2sb.CMD,ref2sb.INP_VALID,ref2sb.RES,ref2sb.ERR,ref2sb.OFLOW,ref2sb.G,ref2sb.L,ref2sb.E);
    end
  join
   compare_report();
end
endtask

 task compare_report();
      begin
        if((ref2sb.RES==mon2sb.RES)||
           (ref2sb.ERR==mon2sb.ERR)||
           (ref2sb.OFLOW==mon2sb.OFLOW)||
           (ref2sb.COUT==mon2sb.COUT)||
           (ref2sb.G==mon2sb.G)||
           (ref2sb.L==mon2sb.L)||
           (ref2sb.E==mon2sb.E))
            begin
              $display("----------------SCOREBOARD(from reference, COMPARE REPORT)----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d |t=%d\n  ",ref2sb.RES,ref2sb.ERR,ref2sb.OFLOW,ref2sb.COUT,ref2sb.G,ref2sb.L,ref2sb.E,$time);
              $display("----------------SCOREBOARD(from monitor,COMPARE REPORT)----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d | t=%d \n ",mon2sb.RES,mon2sb.ERR,mon2sb.OFLOW,mon2sb.COUT,mon2sb.G,mon2sb.L,mon2sb.E,$time);
              MATCH++;
              $display("DATA MATCH SUCCESSFUL MATCH=%d",MATCH);
              $display("\n");
            end
          else
            begin
                $display("----------------SCOREBOARD(from reference, COMPARE REPORT)----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d t=%d |\n",ref2sb.RES,ref2sb.ERR,ref2sb.OFLOW,ref2sb.COUT,ref2sb.G,ref2sb.L,ref2sb.E,$time);
              $display("----------------SCOREBOARD(from monitor,COMPARE REPORT )----------\n RES =%0d | ERR=%d | OFLOW=%d | COUT=%d | G=%d | L=%d | E=%d | t-%d\n",mon2sb.RES,mon2sb.ERR,mon2sb.OFLOW,mon2sb.COUT,mon2sb.G,mon2sb.L,mon2sb.E,$time);
             MISMATCH++;
             $display("DATA MATCH FAILED MISMATCH=%d",MISMATCH);
              $display("\n");
            end
    end
   $display("*************************************************************************************************************");
  endtask
endclass
