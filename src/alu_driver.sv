`include "define.sv"

class alu_driver;
  mailbox #(alu_transaction) mbx_gd;
  mailbox #(alu_transaction) mbx_dr;
  alu_transaction drv_trans;
  alu_transaction trans_drv_temp;
  virtual alu_inf.DRV vif;

  covergroup drv_cg;
MODE_CP: coverpoint drv_trans.MODE {
                                        bins mode_0 = {0};
                                        bins mode_1 = {1};
                                                                }
CMD_CP: coverpoint drv_trans.CMD {
                                        bins cmd_vals[] = {[0:15]};
                                                                }
INP_VALID_CP: coverpoint drv_trans.INP_VALID {
                                        bins invalid = {2'b00};
                                        bins opa_valid = {2'b01};
                                        bins opb_valid = {2'b10};
                                        bins both_valid = {2'b11};

                                                                         }
CE_CP: coverpoint drv_trans.CE {
                        bins clock_enable[] = {[0:1]};

                                        }
CIN_CP: coverpoint drv_trans.CIN {
                        bins cin[] = {[0:1]};

                                        }
CMD_ARTH_CP: coverpoint drv_trans.CMD iff(drv_trans.MODE == 1) {
                        bins add        = {4'd0};
                        bins sub        = {4'd1};
                        bins add_cin    = {4'd2};
                        bins sub_cin    = {4'd3};
                        bins inc_a      = {4'd4};
                        bins dec_a      = {4'd5};
                        bins inc_b      = {4'd6};
                        bins dec_b      = {4'd7};
                        bins cmp_ab     = {4'd8};
                        bins mul_inc    = {4'd9};
                        bins mul_shift  = {4'd10};
                                        
                                                                                }
CMD_LOGIC_CP:coverpoint drv_trans.CMD iff (drv_trans.MODE == 0)
                                          {
                                                bins and_op = {4'd0};
                                                bins nand_op = {4'd1};
                                                bins or_op = {4'd2};
                                                bins nor_op = {4'd3};
                                                bins xor_op = {4'd4};
                                                bins xnor_op = {4'd5};
                                                bins not_a = {4'd6};
                                                bins not_b = {4'd7};
                                                bins shr1_a = {4'd8};
                                                bins shl1_a = {4'd9};
                                                bins shr1_b = {4'd10};
                                                bins shl1_b = {4'd11};
                                                bins rol_a_b = {4'd12};
                                                bins ror_a_b = {4'd13};
                                                
                                                                        }
OPA_CP: coverpoint drv_trans.OPA {
                        bins zero   = {0};
                        bins smaller  = {[1 : (2**(`WIDTH/2))-1]};
                        bins largeer  = {[2**(`WIDTH/2) : (2**`WIDTH)-1]}; }
OPB_CP: coverpoint drv_trans.OPB {
                        bins zero   = {0};
                        bins smaller  = {[1 : (2**(`WIDTH/2))-1]};
                        bins largeer  = {[2**(`WIDTH/2) : (2**`WIDTH)-1]}; }

endgroup


  function new(mailbox #(alu_transaction) mbx_gd, mailbox #(alu_transaction) mbx_dr, virtual alu_inf.DRV vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.vif = vif;
    drv_cg = new();
  endfunction

  task start();
    repeat(3) @(vif.drv_cb);
    for (int i = 0; i < `no_of_transaction; i++) 
      begin//1
      drv_trans = new();
      mbx_gd.get(drv_trans);
      $display("[DRIVER : @%t] From generator for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d",
               $time,i, drv_trans.OPA, drv_trans.OPB, drv_trans.CIN, drv_trans.CE, drv_trans.MODE, drv_trans.CMD, drv_trans.INP_VALID);

      @(vif.drv_cb);
        if (drv_trans.INP_VALID == 2'b01 || drv_trans.INP_VALID == 2'b10) //checking for 2 operand and inp=01 or10
        begin//2
        if (((drv_trans.MODE == 1) && (drv_trans.CMD inside {0,1,2,3,8,9,10})) || ((drv_trans.MODE == 0) && (drv_trans.CMD inside {0,1,2,3,4,5,12,13}))) 
          begin//3
          $display("[DRIVER 1 : @%t] two operand operation 01-10 for i=%d",$time,i);
          vif.drv_cb.OPA <= drv_trans.OPA;
          vif.drv_cb.OPB <= drv_trans.OPB;
          vif.drv_cb.CIN <= drv_trans.CIN;
          vif.drv_cb.CE <= drv_trans.CE;
          vif.drv_cb.CMD <= drv_trans.CMD;
          vif.drv_cb.MODE <= drv_trans.MODE;
          vif.drv_cb.INP_VALID <= drv_trans.INP_VALID;
          mbx_dr.put(drv_trans);
          $display("[DRIVER 1 :@%t] initialy put to reference model is done for i=%d", $time, i);
          $display("[DRIVER 1 :@%t] driver sent to dut through VI for i=%d OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d",
                   $time,i, drv_trans.OPA, drv_trans.OPB, drv_trans.CIN, drv_trans.CE, drv_trans.MODE, drv_trans.CMD, drv_trans.INP_VALID);

          for (int j = 0; j < 16; j++) 
            begin//4
            @(vif.drv_cb);
            if (drv_trans.INP_VALID == 2'b11) 
              begin//5
              vif.drv_cb.OPA <= drv_trans.OPA;
              vif.drv_cb.OPB <= drv_trans.OPB;
              vif.drv_cb.CIN <= drv_trans.CIN;
              vif.drv_cb.CE <= drv_trans.CE;
              vif.drv_cb.CMD <= drv_trans.CMD;
              vif.drv_cb.MODE <= drv_trans.MODE;
              vif.drv_cb.INP_VALID <= drv_trans.INP_VALID;
              $display("[DRIVER 2 @%t] Driver obtained INP_VALID as 11 transfered to dut for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d",
                       $time,i, drv_trans.OPA, drv_trans.OPB, drv_trans.CIN, drv_trans.CE, drv_trans.MODE, drv_trans.CMD, drv_trans.INP_VALID);
              drv_cg.sample();
              $display("INPUT FUNCTIONAL COVERAGE =%.2f", drv_cg.get_coverage());
              mbx_dr.put(drv_trans);
              $display("[DRIVER 2 @%t] Driver put to reference model for i=%d", $time, i);
              break;
              end //5
              else 
                begin//6
              $display("[DRIVER 2 :@%t] else part of 16 logic", $time);
              drv_trans.MODE.rand_mode(0);
              drv_trans.CMD.rand_mode(0);
              drv_trans.CE.rand_mode(0);
              assert(drv_trans.randomize() == 1);
              $display("[DRIVER 2 : @%t ] NOT RECEIVED 11 SO RANDOMIZED...so now values after randomization for i=%d and   j=%d:OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d",
                       $time,i,j, drv_trans.OPA, drv_trans.OPB, drv_trans.CIN, drv_trans.CE, drv_trans.MODE, drv_trans.CMD, drv_trans.INP_VALID);
              drv_cg.sample();
              $display("INPUT FUNCTIONAL COVERAGE =%.2f", drv_cg.get_coverage());
            end//6
          end//4
        end //3
          else //its 01 and 10 but not 2 operand ,single operand operation cmd
            begin//7
          vif.drv_cb.OPA <= drv_trans.OPA;
          vif.drv_cb.OPB <= drv_trans.OPB;
          vif.drv_cb.CIN <= drv_trans.CIN;
          vif.drv_cb.CE <= drv_trans.CE;
          vif.drv_cb.CMD <= drv_trans.CMD;
          vif.drv_cb.MODE <= drv_trans.MODE;
          vif.drv_cb.INP_VALID <= drv_trans.INP_VALID;
          mbx_dr.put(drv_trans);
          $display("[DRIVER :@%t] INP_valid =01 0r 10 single operand Mailbox put happened for i=%0d", $time, i);
          $display("[DRIVER :@%t] Driver driving values to dut for inp_valid=01 or 10 for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d",
                   $time, i,drv_trans.OPA, drv_trans.OPB, drv_trans.CIN, drv_trans.CE, drv_trans.MODE, drv_trans.CMD, drv_trans.INP_VALID);
          drv_cg.sample();
          $display("INPUT FUNCTIONAL COVERAGE =%.2f", drv_cg.get_coverage());
        end//7
      end //2
        else //inp=11 or 00
          begin//8
        vif.drv_cb.OPA <= drv_trans.OPA;
        vif.drv_cb.OPB <= drv_trans.OPB;
        vif.drv_cb.CIN <= drv_trans.CIN;
        vif.drv_cb.CE <= drv_trans.CE;
        vif.drv_cb.CMD <= drv_trans.CMD;
        vif.drv_cb.MODE <= drv_trans.MODE;
        vif.drv_cb.INP_VALID <= drv_trans.INP_VALID;
        mbx_dr.put(drv_trans);

        $display("[DRIVER :@%t] Driver Mailbox put and transfer to dut happened FOR  INP_VALID=11 for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d",
                 $time,i, drv_trans.OPA, drv_trans.OPB, drv_trans.CIN, drv_trans.CE, drv_trans.MODE, drv_trans.CMD, drv_trans.INP_VALID);
        drv_cg.sample();
        $display("INPUT FUNCTIONAL COVERAGE =%.2f", drv_cg.get_coverage());
      end//8

      if (drv_trans.INP_VALID inside {0,1,2,3} &&
         ((drv_trans.MODE == 1 && drv_trans.CMD inside {0,1,2,3,4,5,6,7,8}) ||
          (drv_trans.MODE == 0 && drv_trans.CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13})))
        repeat (1) @(vif.drv_cb);
      else if (drv_trans.INP_VALID == 3 && (drv_trans.MODE == 1 && drv_trans.CMD inside {9,10}))
        repeat (2) @(vif.drv_cb);
    end//1
  endtask

endclass

