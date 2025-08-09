

`include"ALU.sv"
`include"alu_interface.sv"
`include"alu_pkg.sv"
module top;
  bit CLK;
  bit RST;
  import alu_pkg::*;
  
  initial begin
    CLK=0;
    forever #5 CLK=~CLK;
  end
   
  initial begin
    @(posedge CLK);
    RST=1;
    repeat(1)@(posedge CLK);
    RST=0;
  end
  
  alu_inf intf(CLK,RST);
  
  ALU_DESIGN DUV(.OPA(intf.OPA),
          .OPB(intf.OPB),
          .CLK(CLK),
          .RST(RST),
          .CE(intf.CE),
                 .MODE(intf.MODE),
                 .INP_VALID(intf.INP_VALID),
                 .CMD(intf.CMD),
                 .RES(intf.RES),
                 .COUT(intf.COUT),
                 .OFLOW(intf.OFLOW),
                 .G(intf.G),
                 .E(intf.E),
                 .L(intf.L),
          .ERR(intf.ERR),
          .CIN(intf.CIN)
                );
  
   alu_test t=new(intf.DRV,intf.MON,intf.REF);
   alu_test1 tb1= new(intf.DRV,intf.MON,intf.REF);
  alu_test2 tb2=  new(intf.DRV,intf.MON,intf.REF);
   alu_test3 tb3=  new(intf.DRV,intf.MON,intf.REF);
   alu_test4 tb4=  new(intf.DRV,intf.MON,intf.REF);
  alu_test5 tb5=  new(intf.DRV,intf.MON,intf.REF);
  alu_test6 tb6=  new(intf.DRV,intf.MON,intf.REF);
  alu_test7 tb7=  new(intf.DRV,intf.MON,intf.REF);
  alu_test8 tb8=  new(intf.DRV,intf.MON,intf.REF);
  alu_test9 tb9=  new(intf.DRV,intf.MON,intf.REF);
  alu_test10 tb10=  new(intf.DRV,intf.MON,intf.REF);
  alu_test11 tb11=  new(intf.DRV,intf.MON,intf.REF);
  alu_test12 tb12=  new(intf.DRV,intf.MON,intf.REF);
  //alu_test13 tb13=  new(intf.DRV,intf.MON,intf.REF);
    test_regression tb_regression=  new(intf.DRV,intf.MON,intf.REF);
  
  initial begin
//     t.run();
//     tb1.run();
//     tb2.run();
//     tb3.run();
//      tb4.run();
//      tb5.run();
//      tb6.run();
//     tb7.run();
//     tb8.run();
//     tb9.run();
//     tb10.run();
//     tb11.run();
//     tb12.run();
    //tb13.run();
    tb_regression.run();
    $finish;
  end
endmodule
  
  
  
