`include "define.sv"
class alu_generator;
  alu_transaction blueprint;

  mailbox #(alu_transaction)mbx_gd;

  function new(mailbox #(alu_transaction)mbx_gd);
    this.mbx_gd=mbx_gd;
    blueprint=new();
  endfunction

  task start();
    begin
      $display("(GENERATOR) time=%t generator started ",$time);
      for(int i=0;i<`no_of_transaction;i=i+1)
      begin
      assert(blueprint.randomize()==1);
      mbx_gd.put(blueprint.copy());
        $display(" [ GENERATOR : @%t] has randomized the transaction and sent to driver through mailbox\n OPA=%d|OPB=%d | CE=%d | MODE=%d | CIN =%d | INP_VALID =%b | CMD=%b |",$time,blueprint.OPA,blueprint.OPB,blueprint.CE,blueprint.MODE,blueprint.CIN,blueprint.INP_VALID,blueprint.CMD);
        $display("\n");
      end
      end
  endtask
endclass
