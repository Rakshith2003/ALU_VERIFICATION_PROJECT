`include "define.sv"
class alu_monitor;

  alu_transaction mon_trans;

  virtual alu_inf.MON vif;
  mailbox #(alu_transaction)mbx_ms;

  //covergorup

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
      bins equal[] = {0, 1};
    }

    G_CP: coverpoint mon_trans.G {
      bins greater[] = {0, 1};
    }

    L_CP: coverpoint mon_trans.L {
      bins less[] = {0, 1};
    }

    ERR_CP: coverpoint mon_trans.ERR {
      bins error[] = {0, 1};
    }
  endgroup

  function new(mailbox #(alu_transaction)mbx_ms,virtual alu_inf.MON vif);
    begin
    this.mbx_ms=mbx_ms;
    this.vif=vif;
      mon_cg=new();
    end
  endfunction

  task start();
    begin
    //$display("(MONITOR) time=%t MONITOR started ",$time);
      repeat(3)@(vif.mon_cb);
      for(int i=0;i<`no_of_transaction;i=i+1)
        begin
          mon_trans=new();

          repeat(2)@(vif.mon_cb);
         // begin
            //$display("(MONITOR) time=%t before receving from dut for i=%d",$time,i);
            mon_trans.RES=vif.mon_cb.RES;
            mon_trans.ERR=vif.mon_cb.ERR;
            mon_trans.OFLOW=vif.mon_cb.OFLOW;
            mon_trans.COUT=vif.mon_cb.COUT;
            mon_trans.G=vif.mon_cb.G;
            mon_trans.L=vif.mon_cb.L;
            mon_trans.E=vif.mon_cb.E;
           // $display("(MONITOR) time=%t after receving from dut for i=%d",$time,i);
            mon_cg.sample();
            $display(" [ MONITOR ] has RECIVED the data FROM DUT Through Virtual interface at time=%t i=%d\n RES=%d| ERR=%d | OFLOW=%d | COUT=%d | G =%d | L =%d | E=%d |",$time,i,mon_trans.RES,mon_trans.ERR,mon_trans.OFLOW,mon_trans.COUT,mon_trans.G,mon_trans.L,mon_trans.E);
            $display("[ MONITOR ]FUNCTIONAL COVERAGE = %0d", mon_cg.get_coverage());


          mbx_ms.put(mon_trans);
         // mon_cg.sample();
          //  @(vif.mon_cb);
          end
        end

  endtask
endclass
