`include"define.sv"
interface alu_inf(input logic CLK,input logic RST);
  logic [`WIDTH-1:0]OPA,OPB;
  logic [`C_W-1:0]CMD;
  logic [1:0]INP_VALID;
  logic CE,CIN,MODE;
  logic ERR,OFLOW,COUT,G,L,E;
  logic [`WIDTH:0]RES;

  clocking drv_cb@(posedge CLK);
 default input #0 output #0;
 input RST;    //optional
 output OPA,OPB,INP_VALID,MODE,CMD,CE,CIN;
endclocking


  clocking mon_cb@(posedge CLK);
default input #0 output #0;
 input RES,ERR,OFLOW,G,L,E,COUT,OPA,OPB,CIN,CE,MODE,CMD,INP_VALID;
endclocking

  clocking ref_cb@(posedge CLK);
default input #0 output #0;
input RST;
endclocking

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
    modport REF(clocking ref_cb );

ASSERTIONS

  property prop1;
    @(posedge CLK)
    INP_VALID == 2'b11 |-> !$isunknown(OPA) && !$isunknown(OPB);
  endproperty
    assert property (prop1)
    else $error("OPA/OPB unknown when IN_VALID == 2'b11");

  property prop2;
    @(posedge CLK)
    CE |-> !$isunknown(CMD) && !$isunknown(OPA) && !$isunknown(OPB) && !$isunknown(INP_VALID) && !$isunknown(MODE);
  endproperty
    assert property (prop2)
    else $error("CMD or operands unknown when CE is high");

  property prop3;
    @(posedge CLK)
    CMD < (2**`C_W);
  endproperty
    assert property (prop3)
    else $error("CMD out of range!");

  property prop4;
    @(posedge CLK)
    (MODE==1 ) |-> (CMD inside {0,1,2,3,4,5,6,7,8,9,10});
  endproperty
    assert property (prop4)
    else $error("Invalid CMD used in MODE=1");

  property prop5;
    @(posedge CLK)
    (MODE==0 ) |-> (CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13});
  endproperty
    assert property (prop5)
    else $error("Invalid CMD used in MODE=0");

  property prop6;
    @(posedge CLK)
   RST |-> (RES==0 && ERR==0 && COUT==0 && OFLOW==0 && G==0 && E==0 && L==0);
  endproperty
    assert property (prop6)
    else $error("Outputs not cleared on reset");

      sequence seq1;
        CE ==1 && ((MODE ==1) && CMD inside{0,1,2,3,4,5,6,7,8}) || MODE == 0;
      endsequence

    property prop7;
    @(posedge CLK) seq1 ##2 RES;
  endproperty
     assert property (prop7)
       else $error("No result after 1 clock cycle");

       sequence seq2;
         CE == 1 && (MODE == 1 && CMD inside {9,10});
       endsequence

//       property prop8;
  //       @(posedge CLK) seq2 ##3 RES;
    //   endproperty
      // assert property (prop8);
        // $error("no resut for multiplication after 2 clock cycle ");

endinterface
