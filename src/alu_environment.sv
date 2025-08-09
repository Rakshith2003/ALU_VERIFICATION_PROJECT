class alu_environment;

  virtual alu_inf drv_vif;
  virtual alu_inf mon_vif;
  virtual alu_inf ref_vif;
  mailbox #(alu_transaction)mbx_gd;
  mailbox #(alu_transaction)mbx_dr;
  mailbox #(alu_transaction)mbx_ms;
  mailbox #(alu_transaction)mbx_rs;

  alu_generator gen;
  alu_driver dri;
  alu_reference_model ref_model;
  alu_monitor mon;
  alu_scoreboard score;


  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    begin
      this.drv_vif=drv_vif;
      this.mon_vif=mon_vif;
      this.ref_vif=ref_vif;
    end
  endfunction

  task build();
    begin
      mbx_gd=new();
      mbx_dr=new();
      mbx_ms=new();
      mbx_rs=new();

      gen=new(mbx_gd);
      dri=new(mbx_gd,mbx_dr,drv_vif);
      ref_model=new(mbx_dr,mbx_rs,ref_vif);
      mon=new(mbx_ms,mon_vif);
      score=new(mbx_ms,mbx_rs);
    end
  endtask

  task start();
    begin
       fork
         gen.start();
         dri.start();
         ref_model.start();
         mon.start();
         score.start();
       join
    end
  endtask

endclass
