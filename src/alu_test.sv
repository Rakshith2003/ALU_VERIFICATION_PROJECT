class alu_test;
  alu_environment env;

  virtual alu_inf drv_vif;
  virtual alu_inf mon_vif;
  virtual alu_inf ref_vif;

  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    begin
      this.drv_vif=drv_vif;
      this.mon_vif=mon_vif;
      this.ref_vif=ref_vif;
    end
  endfunction

  task run();
    begin
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    env.start;
    end
  endtask

endclass

class alu_test1 extends alu_test;
 alu_transaction1 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test2 extends alu_test;
 alu_transaction1 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test3 extends alu_test;
 alu_transaction3 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test4 extends alu_test;
 alu_transaction4 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test5 extends alu_test;
 alu_transaction5 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test6 extends alu_test;
 alu_transaction6 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test7 extends alu_test;
 alu_transaction7 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test8 extends alu_test;
 alu_transaction8 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test9 extends alu_test;
 alu_transaction9 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test10 extends alu_test;
 alu_transaction10 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test11 extends alu_test;
 alu_transaction11 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

class alu_test12 extends alu_test;
 alu_transaction12 trans;
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    $display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans = new();
    env.gen.blueprint= trans;
    end
    env.start;
  endtask
endclass

// class alu_test13 extends alu_test;
//  alu_transaction13 trans;
//   function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
//     super.new(drv_vif,mon_vif,ref_vif);
//   endfunction

//   task run();
//     $display("child test");
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans = new();
//     env.gen.blueprint= trans;
//     end
//     env.start;
//   endtask
// endclass

class test_regression extends alu_test;
 alu_transaction  trans0;
 alu_transaction1 trans1;
alu_transaction2 trans2;
 alu_transaction3 trans3;
alu_transaction4 trans4;
  alu_transaction5 trans5;
  alu_transaction6 trans6;
  alu_transaction7 trans7;
  alu_transaction8 trans8;
  alu_transaction9 trans9;
  alu_transaction10 trans10;
  alu_transaction11 trans11;
  alu_transaction12 trans12;
  
  function new(virtual alu_inf.DRV drv_vif,virtual alu_inf.MON mon_vif,virtual alu_inf.REF ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    //$display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
///////////////////////////////////////////////////////
    begin
    trans0 = new();
    env.gen.blueprint= trans0;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans1 = new();
    env.gen.blueprint= trans1;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans2 = new();
    env.gen.blueprint= trans2;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans3 = new();
    env.gen.blueprint= trans3;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans4 = new();
    env.gen.blueprint= trans4;
    end
    env.start;
//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    begin
    trans5 = new();
    env.gen.blueprint= trans5;
    end
    env.start;
//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    begin
    trans6 = new();
    env.gen.blueprint= trans6;
    end
    env.start;
//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    begin
    trans7 = new();
    env.gen.blueprint= trans7;
    end
    env.start;
//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    begin
    trans8 = new();
    env.gen.blueprint= trans8;
    end
    env.start;
//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    begin
    trans9 = new();
    env.gen.blueprint= trans9;
    end
    env.start;
//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    begin
    trans10 = new();
    env.gen.blueprint= trans10;
    end
    env.start;
//////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////
    begin
    trans11 = new();
    env.gen.blueprint= trans11;
    end
    env.start;
//////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////
    begin
    trans12 = new();
    env.gen.blueprint= trans12;
    end
    env.start;
//////////////////////////////////////////////////////
  endtask
endclass
