`include "define.sv"

class alu_monitor;

alu_transaction mon_trans;
mailbox #(alu_transaction) mbx_ms;
virtual alu_inf.MON vif;
  covergroup mon_cg;
    RESULT_CP: coverpoint mon_trans.RES {
      bins result[] = {[0 : (2**`WIDTH)-1]};
    }
    COUT_CP: coverpoint mon_trans.COUT {
      bins cout[] = {0, 1};
    }
    OFLOW_CP: coverpoint mon_trans.OFLOW {
      bins overflow[] = {0, 1};
    }

    E_CP: coverpoint mon_trans.E {
      bins equal = {0, 1};
    }

    G_CP: coverpoint mon_trans.G {
      bins greater = {0, 1};
    }

    L_CP: coverpoint mon_trans.L {
      bins less= {0, 1};
    }

    ERR_CP: coverpoint mon_trans.ERR {
      bins error[] = {0, 1};
    }
  endgroup

function new(mailbox #(alu_transaction) mbx_ms,virtual alu_inf.MON vif);
 this.mbx_ms=mbx_ms;
 this.vif=vif;
 mon_cg=new();
endfunction

task start();
  //$display("[MONITOR @%t]Monitor started",$time);
repeat(4)@(vif.mon_cb);
  for(int i=0;i<`no_of_transaction;i++)
 begin
  mon_trans=new();
  @(vif.mon_cb);

  if(vif.mon_cb.INP_VALID inside{0,1,2,3} && ((vif.mon_cb.MODE==1 && vif.mon_cb.CMD inside {0,1,2,3,4,5,6,7,8})||(vif.mon_cb.MODE==0 && vif.mon_cb.CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13})))
    begin repeat(1) @(vif.mon_cb);
      $display("[mon @%t] i=%d",$time,i);
      end
else if(vif.mon_cb.INP_VALID==3 && (vif.mon_cb.MODE==1 && vif.mon_cb.CMD inside {9,10}))
    repeat(2) @(vif.mon_cb);

   begin
     if((vif.mon_cb.INP_VALID==2'b01) ||(vif.mon_cb.INP_VALID==2'b10))
      begin
        if(((vif.mon_cb.MODE==1)&& (vif.mon_cb.CMD inside {0,1,2,3,8,9,10})) || ((vif.mon_cb.MODE==0)&& (vif.mon_cb.CMD inside {0,1,2,3,4,5,12,13}))) //if two operation cmd and inp=01 or 10
          begin
            for(int j=0;j<16;j++)
              begin
                @(vif.mon_cb);
                $display("[mon @%t] i=%d j=%d opa=%d opb=%d inp=%d",$time,i,j,vif.mon_cb.OPA,vif.mon_cb.OPB,vif.mon_cb.INP_VALID);
                 begin
                   if(vif.mon_cb.INP_VALID==2'b11) //checking got inp=11
                    begin
                      if(vif.mon_cb.MODE==1 && vif.mon_cb.CMD inside {9,10})// multiplication
                      begin
                       repeat(2)@(vif.mon_cb);
                       mon_trans.RES=vif.mon_cb.RES;
                       mon_trans.ERR=vif.mon_cb.ERR;
                       mon_trans.G=vif.mon_cb.G;
                       mon_trans.L=vif.mon_cb.L;
                       mon_trans.E=vif.mon_cb.E;
                       mon_trans.OFLOW=vif.mon_cb.OFLOW;
                       mon_trans.OPA=vif.mon_cb.OPA;
                       mon_trans.OPB=vif.mon_cb.OPB;
                       mon_trans.CIN=vif.mon_cb.CIN;
                       mon_trans.CE=vif.mon_cb.CE;
                       mon_trans.MODE=vif.mon_cb.MODE;
                       mon_trans.CMD=vif.mon_cb.CMD;
                       mon_trans.INP_VALID=vif.mon_cb.INP_VALID;

                       mbx_ms.put(mon_trans);
                        $display("[MONITOR :@%t] Monitor transfered values from the DUT to mailbox(to scoreboard)(16 clock logic) for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i,vif.mon_cb.OPA,vif.mon_cb.OPB,vif.mon_cb.CIN,vif.mon_cb.CE,vif.mon_cb.MODE,vif.mon_cb.CMD,vif.mon_cb.INP_VALID,vif.mon_cb.RES,vif.mon_cb.ERR,vif.mon_cb.OFLOW,vif.mon_cb.G,vif.mon_cb.L,vif.mon_cb.E);
                    mon_cg.sample();
                    $display("OUTPUT COVERAGE %.2f",mon_cg.get_coverage());
                   end   
                    else //other operations
                     begin
                      repeat(1)@(vif.mon_cb);
                      mon_trans.RES=vif.mon_cb.RES;
                      mon_trans.ERR=vif.mon_cb.ERR;
                      mon_trans.G=vif.mon_cb.G;
                      mon_trans.L=vif.mon_cb.L;
                      mon_trans.E=vif.mon_cb.E;
                      mon_trans.OFLOW=vif.mon_cb.OFLOW;
                      mon_trans.OPA=vif.mon_cb.OPA;
                      mon_trans.OPB=vif.mon_cb.OPB;
                      mon_trans.CIN=vif.mon_cb.CIN;
                      mon_trans.CE=vif.mon_cb.CE;
                      mon_trans.MODE=vif.mon_cb.MODE;
                      mon_trans.CMD=vif.mon_cb.CMD;
                      mon_trans.INP_VALID=vif.mon_cb.INP_VALID;

                      mbx_ms.put(mon_trans);
                      $display("[MONITOR :@%t] Monitor transfered values from the DUT to mailbox(to scoreboard) for i=%d:OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i,vif.mon_cb.OPA,vif.mon_cb.OPB,vif.mon_cb.CIN,vif.mon_cb.CE,vif.mon_cb.MODE,vif.mon_cb.CMD,vif.mon_cb.INP_VALID,vif.mon_cb.RES,vif.mon_cb.ERR,vif.mon_cb.OFLOW,vif.mon_cb.G,vif.mon_cb.L,vif.mon_cb.E);
                    mon_cg.sample();
                    $display("OUTPUT COVERAGE %.2f",mon_cg.get_coverage());
                    end   
                     break;
                   end//11
                 else
                    begin
                      continue;
                    end
                 end
              end//forloop end
          end //end of if
        else if((vif.mon_cb.MODE==1 && vif.mon_cb.CMD inside {4,5,6,7})||(vif.mon_cb.MODE==0 && vif.mon_cb.CMD inside {6,7,8,9,10,11})) //if inp=01 or 10 and single operand operation
              begin
                     mon_trans.RES=vif.mon_cb.RES;
                     mon_trans.ERR=vif.mon_cb.ERR;
                     mon_trans.G=vif.mon_cb.G;
                     mon_trans.L=vif.mon_cb.L;
                     mon_trans.E=vif.mon_cb.E;
                     mon_trans.OFLOW=vif.mon_cb.OFLOW;
                     mon_trans.OPA=vif.mon_cb.OPA;
                     mon_trans.OPB=vif.mon_cb.OPB;
                     mon_trans.CIN=vif.mon_cb.CIN;
                     mon_trans.CE=vif.mon_cb.CE;
                     mon_trans.MODE=vif.mon_cb.MODE;
                     mon_trans.CMD=vif.mon_cb.CMD;
                     mon_trans.INP_VALID=vif.mon_cb.INP_VALID;

                     mbx_ms.put(mon_trans);
                $display("[MONITOR :@%t] Monitor transfered values from the DUT to mailbox (to scoreboard)for single operand operation, for i=%d:OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i+1,vif.mon_cb.OPA,vif.mon_cb.OPB,vif.mon_cb.CIN,vif.mon_cb.CE,vif.mon_cb.MODE,vif.mon_cb.CMD,vif.mon_cb.INP_VALID,vif.mon_cb.RES,vif.mon_cb.ERR,vif.mon_cb.OFLOW,vif.mon_cb.G,vif.mon_cb.L,vif.mon_cb.E);
                     mon_cg.sample();
                     $display("OUTPUT COVERAGE %.2f",mon_cg.get_coverage());

               end 
      end //end of main 01 or 10 if 
        else 
           begin
             mon_trans.RES=vif.mon_cb.RES;
             mon_trans.ERR=vif.mon_cb.ERR;
             mon_trans.G=vif.mon_cb.G;
             mon_trans.L=vif.mon_cb.L;
             mon_trans.E=vif.mon_cb.E;
             mon_trans.OFLOW=vif.mon_cb.OFLOW;
             mon_trans.OPA=vif.mon_cb.OPA;
             mon_trans.OPB=vif.mon_cb.OPB;
             mon_trans.CIN=vif.mon_cb.CIN;
             mon_trans.CE=vif.mon_cb.CE;
             mon_trans.MODE=vif.mon_cb.MODE;
             mon_trans.CMD=vif.mon_cb.CMD;
             mon_trans.INP_VALID=vif.mon_cb.INP_VALID;
              mbx_ms.put(mon_trans);
              mon_cg.sample();
             $display("OUTPUT COVERAGE %.2f",mon_cg.get_coverage());
            $display("[MONITOR :@%t] Monitor transfered values from the DUT to mailbox(to scoreboard) for INPUT_VALID=11 or 00 i=%d:OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i+1,vif.mon_cb.OPA,vif.mon_cb.OPB,vif.mon_cb.CIN,vif.mon_cb.CE,vif.mon_cb.MODE,vif.mon_cb.CMD,vif.mon_cb.INP_VALID,vif.mon_cb.RES,vif.mon_cb.ERR,vif.mon_cb.OFLOW,vif.mon_cb.G,vif.mon_cb.L,vif.mon_cb.E);
   end 
  end
end
endtask

endclass
