`include"define.sv"
class alu_transaction;
  rand logic [`WIDTH-1:0]OPA;
  rand logic [`WIDTH-1:0]OPB;
  rand logic [`C_W-1:0]CMD;
  rand logic [1:0]INP_VALID;
  rand logic CE,CIN,MODE;

  logic ERR = 'bz,OFLOW = 'bz,COUT = 'bz,G = 'bz,L = 'bz,E = 'bz;
  logic [`WIDTH:0]RES = 'bz;

  constraint inp_valid{INP_VALID == 3;}
  //constraint inp_valid{INP_VALID inside {1,2,3};}
 // constraint operands{OPA>OPB;}
  //constraint operands{OPA==10;OPB==5;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {0,1,2,3,8};} //only 2 operands with inp=11
  //constraint cmd{CMD ==15;}
  constraint MODE_1{MODE==1;}
  //constraint a1{INP_VALID == 2'b01;}

  function alu_transaction copy();
    copy=new();
    copy.OPA=this.OPA;
    copy.OPB=this.OPB;
    copy.CMD=this.CMD;
    copy.INP_VALID=this.INP_VALID;
    copy.CE=this.CE;
    copy.CIN=this.CIN;
    copy.MODE=this.MODE;
  endfunction
endclass

class alu_transaction1 extends alu_transaction;

  constraint inp_valid{INP_VALID ==3;}
 // constraint operands{OPA>OPB;}
  //constraint ce{CE ==1;}
  constraint cmd{CMD inside {9,10};}
  constraint MODE_1{MODE==1;}

  constraint ce{CE ==1;}
  //constraint cmd{CMD ==0;}
  //constraint a1{INP_VALID == 3;}

   virtual function alu_transaction copy();
    alu_transaction1 copy1;
    copy1 = new();
    copy1.OPA        = this.OPA;
    copy1.OPB        = this.OPB;
    copy1.CIN        = this.CIN;
    copy1.CE         = this.CE;
    copy1.MODE       = this.MODE;
    copy1.INP_VALID  = this.INP_VALID;
    copy1.CMD        = this.CMD;
    return copy1;
  endfunction
endclass


class alu_transaction2 extends alu_transaction;

  constraint inp_valid{INP_VALID==3;}
  constraint operands{OPA<OPB;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};}//all arithmatic operators when inp=11
  constraint MODE_1{MODE==1;}


   virtual function alu_transaction copy();
    alu_transaction2 copy2;
    copy2 = new();
    copy2.OPA        = this.OPA;
    copy2.OPB        = this.OPB;
    copy2.CIN        = this.CIN;
    copy2.CE         = this.CE;
    copy2.MODE       = this.MODE;
    copy2.INP_VALID  = this.INP_VALID;
    copy2.CMD        = this.CMD;
    return copy2;
  endfunction
endclass

class alu_transaction3 extends alu_transaction;

  constraint inp_valid{INP_VALID inside {1,2};}
  //constraint operands{OPA>OPB;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {4,5,6,7};}  //single operands when inp=01 or10 for mode=1
  constraint MODE_1{MODE==1;}


   virtual function alu_transaction copy();
    alu_transaction3 copy3;
    copy3 = new();
    copy3.OPA        = this.OPA;
    copy3.OPB        = this.OPB;
    copy3.CIN        = this.CIN;
    copy3.CE         = this.CE;
    copy3.MODE       = this.MODE;
    copy3.INP_VALID  = this.INP_VALID;
    copy3.CMD        = this.CMD;
    return copy3;
  endfunction
endclass

class alu_transaction4 extends alu_transaction;

  constraint inp_valid{INP_VALID inside {0,1,2,3};}
  constraint operands{OPA==OPB;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {0,1,2,3,4,5,6,7,8,9,10};}//all arithmatic operators when inp={0,1,2,3}
  constraint MODE_1{MODE==1;}


   virtual function alu_transaction copy();
    alu_transaction4 copy4;
    copy4 = new();
    copy4.OPA        = this.OPA;
    copy4.OPB        = this.OPB;
    copy4.CIN        = this.CIN;
    copy4.CE         = this.CE;
    copy4.MODE       = this.MODE;
    copy4.INP_VALID  = this.INP_VALID;
    copy4.CMD        = this.CMD;
    return copy4;
  endfunction
endclass

class alu_transaction5 extends alu_transaction;  

  constraint inp_valid{INP_VALID == 3;}
  //constraint operands{OPA>OPB;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {0,1,2,3,4,5,12,13};}//two operand logical operators when inp=11
  constraint MODE_1{MODE==0;}


   virtual function alu_transaction copy();
    alu_transaction5 copy5;
    copy5 = new();
    copy5.OPA        = this.OPA;
    copy5.OPB        = this.OPB;
    copy5.CIN        = this.CIN;
    copy5.CE         = this.CE;
    copy5.MODE       = this.MODE;
    copy5.INP_VALID  = this.INP_VALID;
    copy5.CMD        = this.CMD;
    return copy5;
  endfunction
endclass

class alu_transaction6 extends alu_transaction;

  constraint inp_valid{INP_VALID== 3;}
  constraint operands{OPB inside {[0:16]};}  //only for width =8
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {12,13};} //rol and ror
  constraint MODE_1{MODE==0;}


   virtual function alu_transaction copy();
    alu_transaction6 copy6;
    copy6 = new();
    copy6.OPA        = this.OPA;
    copy6.OPB        = this.OPB;
    copy6.CIN        = this.CIN;
    copy6.CE         = this.CE;
    copy6.MODE       = this.MODE;
    copy6.INP_VALID  = this.INP_VALID;
    copy6.CMD        = this.CMD;
    return copy6;
  endfunction
endclass

class alu_transaction7 extends alu_transaction;

  constraint inp_valid{INP_VALID ==1; }
  //constraint operands{OPA>OPB;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {6,8,9};} //single operand opa
  constraint MODE_1{MODE==0;}


   virtual function alu_transaction copy();
    alu_transaction7 copy7;
    copy7 = new();
    copy7.OPA        = this.OPA;
    copy7.OPB        = this.OPB;
    copy7.CIN        = this.CIN;
    copy7.CE         = this.CE;
    copy7.MODE       = this.MODE;
    copy7.INP_VALID  = this.INP_VALID;
    copy7.CMD        = this.CMD;
    return copy7;
  endfunction
endclass

class alu_transaction8 extends alu_transaction;

  constraint inp_valid{INP_VALID ==2;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside {7,10,11};}
  constraint MODE_1{MODE==0;}


   virtual function alu_transaction copy();
    alu_transaction8 copy8;
    copy8 = new();
    copy8.OPA        = this.OPA;
    copy8.OPB        = this.OPB;
    copy8.CIN        = this.CIN;
    copy8.CE         = this.CE;
    copy8.MODE       = this.MODE;
    copy8.INP_VALID  = this.INP_VALID;
    copy8.CMD        = this.CMD;
    return copy8;
  endfunction
endclass
class alu_transaction9 extends alu_transaction;

  constraint inp_valid{INP_VALID ==3;}

  constraint ce{CE ==1;}
  constraint cmd{CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13};}//all logical operand
  constraint MODE_1{MODE==0;}

   virtual function alu_transaction copy();
    alu_transaction9 copy9;
    copy9 = new();
    copy9.OPA        = this.OPA;
    copy9.OPB        = this.OPB;
    copy9.CIN        = this.CIN;
    copy9.CE         = this.CE;
    copy9.MODE       = this.MODE;
    copy9.INP_VALID  = this.INP_VALID;
    copy9.CMD        = this.CMD;
    return copy9;
  endfunction
endclass


class alu_transaction10 extends alu_transaction;

  constraint inp_valid{INP_VALID == 0;}
  constraint ce{CE ==1;}
  //constraint operands{OPA>OPB;}
  constraint cmd{CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};} 
  constraint MODE_1{MODE inside {0,1};}


   virtual function alu_transaction copy();
    alu_transaction10 copy10;
    copy10 = new();
    copy10.OPA        = this.OPA;
    copy10.OPB        = this.OPB;
    copy10.CIN        = this.CIN;
    copy10.CE         = this.CE;
    copy10.MODE       = this.MODE;
    copy10.INP_VALID  = this.INP_VALID;
    copy10.CMD        = this.CMD;
    return copy10;
  endfunction
endclass

class alu_transaction11 extends alu_transaction;

  constraint inp_valid{INP_VALID ==3;}
  constraint operands{OPA<OPB;}
  constraint ce{CE ==1;}
  constraint cmd{CMD inside{0,1,2,3};}  //2 operand whne inp=00,01,10,11 arithmatic
  constraint MODE_1{MODE==1;}


   virtual function alu_transaction copy();
    alu_transaction11 copy11;
    copy11 = new();
    copy11.OPA        = this.OPA;
    copy11.OPB        = this.OPB;
    copy11.CIN        = this.CIN;
    copy11.CE         = this.CE;
    copy11.MODE       = this.MODE;
    copy11.INP_VALID  = this.INP_VALID;
    copy11.CMD        = this.CMD;
    return copy11;
  endfunction
endclass

class alu_transaction12 extends alu_transaction;

  constraint inp_valid{INP_VALID ==3;}
  constraint operands{OPA==255;} //only for width =8 cout =1 check
  constraint ce{CE ==1;}
  constraint cmd{CMD inside{0,1,2,3};} 
  constraint MODE_1{MODE==1;}


   virtual function alu_transaction copy();
    alu_transaction12 copy12;
    copy12 = new();
    copy12.OPA        = this.OPA;
    copy12.OPB        = this.OPB;
    copy12.CIN        = this.CIN;
    copy12.CE         = this.CE;
    copy12.MODE       = this.MODE;
    copy12.INP_VALID  = this.INP_VALID;
    copy12.CMD        = this.CMD;
    return copy12;
  endfunction
endclass

/*class alu_transaction13 extends alu_transaction;

  constraint inp_valid{INP_VALID inside {0,1,2,3};}

  constraint ce{CE ==0;}
  constraint cmd{CMD inside {0,1,2,3,8,9,10};}  
  constraint MODE_1{MODE==1;}


   virtual function alu_transaction copy();
    alu_transaction13 copy13;
    copy13 = new();
    copy13.OPA        = this.OPA;
    copy13.OPB        = this.OPB;
    copy13.CIN        = this.CIN;
    copy13.CE         = this.CE;
    copy13.MODE       = this.MODE;
    copy13.INP_VALID  = this.INP_VALID;
    copy13.CMD        = this.CMD;
    return copy13;
  endfunction
endclass*/
