`include "define.sv"

class alu_driver;
  alu_transaction drv_trans;
  mailbox #(alu_transaction) mbx_gd;
  mailbox #(alu_transaction) mbx_dr;
  virtual alu_inf.DRV vif;
     bit flag;
  //covergroup
 //event e;
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
CMO_CP: coverpoint drv_trans.CMD {
                        bins cmd[] = {[0:15]};

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
                                        ignore_bins invalid ={[11:15]};
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
                                                ignore_bins invalid_cmd={[14:15]};
                                                                        }
OPA_CP: coverpoint drv_trans.OPA {
                        bins zero   = {0};
                        bins smaller  = {[1 : (2**(`WIDTH/2))-1]};
                        bins largeer  = {[2**(`WIDTH/2) : (2**`WIDTH)-1]}; }
OPB_CP: coverpoint drv_trans.OPB {
                        bins zero   = {0};
                        bins smaller  = {[1 : (2**(`WIDTH/2))-1]};
                        bins largeer  = {[2**(`WIDTH/2) : (2**`WIDTH)-1]}; }

CMD_X_INP_VALID: cross drv_trans.CMD, drv_trans.INP_VALID;
CMD_X_MODE: cross drv_trans.CMD, drv_trans.MODE;
OPA_X_OPB: cross drv_trans.OPA, drv_trans.OPB;
endgroup


  function new(mailbox #(alu_transaction) mbx_gd,
               mailbox #(alu_transaction) mbx_dr,
               virtual alu_inf.DRV vif);
    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.vif    = vif;
    drv_cg=new();
  endfunction

  task start();
   // $display("[DRIVER] started at %0t", $time);
    repeat(1) @(vif.drv_cb);

    for (int i = 0; i < `no_of_transaction; i++) begin//1
      //$display("(driv) time=%t at i=%d",$time,i);
      drv_trans = new();
      mbx_gd.get(drv_trans);


      if ((drv_trans.MODE == 1'b1 && drv_trans.CMD inside {0, 1, 2, 3, 8, 9, 10}) ||
          (drv_trans.MODE == 1'b0 && drv_trans.CMD inside {0, 1, 2, 3, 4, 5, 12, 13})) begin//2


        if (drv_trans.INP_VALID == 2'b01 || drv_trans.INP_VALID == 2'b10) begin//3
         //repeat(1)@(vif.drv_cb);
         repeat(1)@(vif.drv_cb)
         begin//7
          vif.drv_cb.OPA        <= drv_trans.OPA;
          vif.drv_cb.OPB        <= drv_trans.OPB;
          vif.drv_cb.CIN        <= drv_trans.CIN;
          vif.drv_cb.MODE       <= drv_trans.MODE;
          vif.drv_cb.CE         <= drv_trans.CE;
          vif.drv_cb.CMD        <= drv_trans.CMD;
          vif.drv_cb.INP_VALID  <= drv_trans.INP_VALID;
          $display("[DRIVER 1] %0t sent to dut ",$time);
         // @(vif.drv_cb);
          mbx_dr.put(drv_trans);
          drv_cg.sample();

          $display("[DRIVER1] sent to ref: OPA=%0d, OPB=%0d, CIN=%0d, CE=%0d, MODE=%0d, CMD=%0d, INP_VALID=%b AT %0t",
                  drv_trans.OPA,  drv_trans.OPB, drv_trans.CIN,  drv_trans.CE,
                   drv_trans.MODE, drv_trans.CMD,  drv_trans.INP_VALID, $time);

          drv_trans.CMD.rand_mode(0);
          drv_trans.CE.rand_mode(0);
          drv_trans.MODE.rand_mode(0);
          //@(vif.drv_cb);
          for (int j = 0; j < 16; j++) begin//8
            @(vif.drv_cb)
              begin//9
          void'(drv_trans.randomize());
          vif.drv_cb.OPA        <= drv_trans.OPA;
          vif.drv_cb.OPB        <= drv_trans.OPB;
          vif.drv_cb.CIN        <= drv_trans.CIN;
          vif.drv_cb.INP_VALID  <= drv_trans.INP_VALID;
          $display("[DRIVER 2]@%t sent to dut ",$time);
          @(vif.drv_cb);
          mbx_dr.put(drv_trans);

            drv_cg.sample();
                $display("[DRIVER2] i=%d j=%d  sent to ref: OPA=%0d, OPB=%0d, CIN=%0d, CE=%0d, MODE=%0d, CMD=%0d, INP_VALID=%b AT %0t",i,j,
                  drv_trans.OPA,  drv_trans.OPB, drv_trans.CIN,  drv_trans.CE,
                   drv_trans.MODE, drv_trans.CMD,  drv_trans.INP_VALID, $time);
            $display("[DRIVER] FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
           // @(vif.drv_cb);
            if (drv_trans.INP_VALID == 2'b11) begin//10
            drv_trans.CMD.rand_mode(1);
            drv_trans.CE.rand_mode(1);
            drv_trans.MODE.rand_mode(1);
              break;
            end//10
          end//9
             //break;
          end//8

          end//7

         // @(vif.drv_cb);

        end

        else if (drv_trans.INP_VALID == 2'b11 || drv_trans.INP_VALID == 2'b00) begin
          repeat(1)@(vif.drv_cb)begin
          vif.drv_cb.OPA        <= drv_trans.OPA;
          vif.drv_cb.OPB        <= drv_trans.OPB;
          vif.drv_cb.CIN        <= drv_trans.CIN;
          vif.drv_cb.MODE       <= drv_trans.MODE;
          vif.drv_cb.CE         <= drv_trans.CE;
          vif.drv_cb.CMD        <= drv_trans.CMD;
          vif.drv_cb.INP_VALID  <= drv_trans.INP_VALID;
            @(vif.drv_cb);

            mbx_dr.put(drv_trans);
          drv_cg.sample();
          $display("[ DRIVER ] (11-00) sent to dut: OPA=%0d, OPB=%0d, CIN=%0d, CE=%0d, MODE=%0d, CMD=%0d, INP_VALID=%b AT %0t",
                  drv_trans.OPA,  drv_trans.OPB, drv_trans.CIN,  drv_trans.CE,
                   drv_trans.MODE, drv_trans.CMD,  drv_trans.INP_VALID, $time );
         $display("(DRIVER) FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
         // repeat(2)@(vif.drv_cb);
        end
        end
      end
      else
        repeat(1)@(vif.drv_cb)
        begin
        vif.drv_cb.OPA        <= drv_trans.OPA;
        vif.drv_cb.OPB        <= drv_trans.OPB;
        vif.drv_cb.CIN        <= drv_trans.CIN;
        vif.drv_cb.MODE       <= drv_trans.MODE;
        vif.drv_cb.CE         <= drv_trans.CE;
        vif.drv_cb.CMD        <= drv_trans.CMD;
        vif.drv_cb.INP_VALID  <= drv_trans.INP_VALID;
          @(vif.drv_cb);

        mbx_dr.put(drv_trans);
          drv_cg.sample();
          $display("[ DRIVER ](01-10-11-00) sent to dut: OPA=%0d, OPB=%0d, CIN=%0d, CE=%0d, MODE=%0d, CMD=%0d, INP_VALID=%b AT %0t",
                  drv_trans.OPA,  drv_trans.OPB, drv_trans.CIN,  drv_trans.CE,
                   drv_trans.MODE, drv_trans.CMD,  drv_trans.INP_VALID, $time );
         $display("[DRIVER]FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
        //@(vif.drv_cb);
      end
      //$display("[DRIVER] completed transactions at %0t  for i=%d", $time,i);
    end

  endtask

endclass
