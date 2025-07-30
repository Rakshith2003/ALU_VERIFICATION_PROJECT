`include "define.sv"

class alu_reference_model;

  mailbox #(alu_transaction) mbx_rs;
  mailbox #(alu_transaction) mbx_dr;
  alu_transaction ref_trans;
  virtual alu_inf.REF vif;
  int count=0;
  localparam rot_bits = $clog2(`WIDTH);
  logic [rot_bits-1:0] rot_val;// = opb_t[rot_bits-1:0];

  function new(mailbox #(alu_transaction) mbx_dr,
               mailbox #(alu_transaction) mbx_rs,
               virtual alu_inf.REF vif);
    this.mbx_dr = mbx_dr;
    this.mbx_rs = mbx_rs;
    this.vif = vif;
  endfunction

  task start();
 repeat(1)@(vif.ref_cb);

    for (int i = 0; i < `no_of_transaction; i++)
      begin  //1
       // $display("(REF model) time=%t reference model started for i=%d",$time,i);
      ref_trans = new();
        mbx_dr.get(ref_trans);
        $display("(***REF MODEL***): OPA=%0d, OPB=%0d, CIN=%0d, CE=%0d, MODE=%0d, CMD=%0d, INP_VALID=%b AT  i=%d t=%0t",
                  ref_trans.OPA,  ref_trans.OPB, ref_trans.CIN,  ref_trans.CE,ref_trans.MODE, ref_trans.CMD,  ref_trans.INP_VALID,i, $time);

        repeat(1)@(vif.ref_cb);
        repeat(1)@(vif.ref_cb)
        begin  //2
         // $display("(REF model) Time =%t ,started at i=%d",$time,i);

          if (vif.ref_cb.RST==1)
          begin //3
          ref_trans.RES = 0;
          ref_trans.OFLOW = 0;
          ref_trans.COUT = 0;
          ref_trans.G = 0;
          ref_trans.L = 0;
          ref_trans.E = 0;
        end//3

          else if(ref_trans.CE==1)
          begin//4
            if(ref_trans.INP_VALID==2'b00)    //inp valid 00
              begin
                ref_trans.ERR=1'b1;
              end

            // Handle 2-operand commands with both operands valid
            else if(ref_trans.INP_VALID==2'b11)
              begin  //11_1
                 if(ref_trans.MODE==1)
                              begin //9
                                case(ref_trans.CMD)
                                `ADD: begin

                                                                ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
                                                                ref_trans.COUT = ref_trans.RES[`WIDTH];

                                                         break;
                                                                        end
                                                `SUB: begin
                                                                ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
                                                                ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB) ? 1 : 0;
                                                         break;
                                                                        end
                                                `ADD_CIN: begin
                                                                ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
                                                                ref_trans.COUT = ref_trans.RES[`WIDTH];
                                                        break;
                                                                end
                                                 `SUB_CIN: begin
                                                                        ref_trans.RES = (ref_trans.OPA - ref_trans.OPB) - ref_trans.CIN;
                                                                ref_trans.OFLOW = ref_trans.RES[`WIDTH];
                                   break;
                                                                        end
                                                `INC_A : begin
                                                                         ref_trans.RES = ref_trans.OPA + 1;
                                                                ref_trans.COUT = ref_trans.RES[`WIDTH];
                                  break;
                                                                        end
                                                `DEC_A: begin
                                                                ref_trans.RES = ref_trans.OPA - 1;
                                                                ref_trans.OFLOW = (ref_trans.OPA == 0) ? 1 : 0;
                                  break;
                                                                 end
                                  `INC_B: begin
                                                                ref_trans.RES = ref_trans.OPB + 1;
                                                                ref_trans.COUT = ref_trans.RES[`WIDTH];
                                  break;
                                                                        end
                                                `DEC_B: begin
                                                                         ref_trans.RES = ref_trans.OPB - 1;
                                                                ref_trans.OFLOW = (ref_trans.OPB == 0) ? 1 : 0;
                                                        break;
                                                                        end
                                                `CMP: begin
                                                                if (ref_trans.OPA < ref_trans.OPB)
                                                                ref_trans.L = 1;
                                                                else if (ref_trans.OPA == ref_trans.OPB)
                                                                ref_trans.E = 1;
                                                                else
                                                                ref_trans.G = 1;
                                                break;
                                                                end
                                                `MUL_IN: begin
                                  //repeat(1)@(vif.ref_cb);
                                  repeat(1)@(vif.ref_cb);
                                    ref_trans.RES = (ref_trans.OPA+1) * (ref_trans.OPB+1);
                                   break;
                                  end

                                                `MUL_S:begin
                                  repeat(1)@(vif.ref_cb);
                                    ref_trans.RES = (ref_trans.OPA << 1) * ref_trans.OPB;
                                  break;
                                  end
                                                default: begin
                                                 ref_trans.ERR = 1;
                                                 ref_trans.RES = {(`WIDTH){1'b0}};
                                                end
                                                endcase

                              end//9
                              else  //logical
                                begin //10
                                  case (ref_trans.CMD)
                                    `AND:begin
                                        ref_trans.RES = {1'b0, ref_trans.OPA & ref_trans.OPB};
                                        break;
                                    end
                                    `NAND:begin
                                      ref_trans.RES = {1'b0, ~(ref_trans.OPA & ref_trans.OPB)};
                                      break;end
                                    `OR:begin
                                      ref_trans.RES = {1'b0, ref_trans.OPA | ref_trans.OPB};
                                      break;
                                       end
                                    `NOR: begin
                                      ref_trans.RES = {1'b0, ~(ref_trans.OPA | ref_trans.OPB)};
                                    break;
                                    end
                                    `XOR:begin
                                      ref_trans.RES = {1'b0, ref_trans.OPA ^ ref_trans.OPB};
                                    break;
                                    end
                                    `XNOR:begin
                                      ref_trans.RES = {1'b0, ~(ref_trans.OPA ^ ref_trans.OPB)};
                                    break;
                                    end
                                        `ROL: begin
                                       rot_val= ref_trans.OPB[rot_bits-1:0];
                                      ref_trans.RES = {1'b0, (ref_trans.OPA << rot_val) | (ref_trans.OPA >> (`WIDTH - rot_val))};
                                      ref_trans.ERR = (ref_trans.OPB >= `WIDTH);
                                        break;
                                    end

                                                `ROR: begin
                                      rot_val= ref_trans.OPB[rot_bits-1:0];
                                      ref_trans.RES = {1'b0, (ref_trans.OPA >> rot_val) | (ref_trans.OPA << (`WIDTH - rot_val))};
                                      ref_trans.ERR = (ref_trans.OPB >= `WIDTH);
                                        break;
                                    end

                            default: begin
                                ref_trans.RES = {(`WIDTH){1'b0}};
                                ref_trans.ERR = 1'b1;
                            end
                        endcase
                                 // mbx_rs.put(ref_trans);  //logical sent to score
                                end  //10

              end  //11_1


            else if((ref_trans.INP_VALID==2'b01 || ref_trans.INP_VALID==2'b10) &&
                    ((ref_trans.MODE==1 && ref_trans.CMD inside{0, 1, 2, 3, 8, 9, 10}) ||
                     (ref_trans.MODE==1'b0 && ref_trans.CMD inside{0, 1, 2, 3, 4, 5, 12, 13})))
            begin//5 - 2-operand command but only 1 operand valid
                $display("correct came here for i=%d",i);

                for(int j = 0; j < 16; j++)
                begin //7
                    @(vif.ref_cb);
                    mbx_dr.get(ref_trans);
                    count++;   //counts the iteration
                    $display("here comes iteration %0d", j);

                    @(vif.ref_cb);
                    if(ref_trans.INP_VALID==2'b11)
                    begin //8
                        if(ref_trans.MODE==1)
                        begin //9
                            case(ref_trans.CMD)
                            `ADD: begin

                                        ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
                                        ref_trans.COUT = ref_trans.RES[`WIDTH];

                                         break;
                                    end
                            `SUB: begin
                                        ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
                                        ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB) ? 1 : 0;
                                         break;
                                    end
                            `ADD_CIN: begin
                                        ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
                                        ref_trans.COUT = ref_trans.RES[`WIDTH];
                                        break;
                                    end
                             `SUB_CIN: begin
                                        ref_trans.RES = (ref_trans.OPA - ref_trans.OPB) - ref_trans.CIN;
                                        ref_trans.OFLOW = ref_trans.RES[`WIDTH];
                               break;
                                    end

                            `CMP: begin
                                        if (ref_trans.OPA < ref_trans.OPB)
                                        ref_trans.L = 1;
                                        else if (ref_trans.OPA == ref_trans.OPB)
                                        ref_trans.E = 1;
                                        else
                                        ref_trans.G = 1;
                                    break;
                                    end
                            `MUL_IN: begin
                                repeat(1)@(vif.ref_cb)
                                    ref_trans.RES = (ref_trans.OPA+1) * (ref_trans.OPB+1);
                                break;
                            end
                            `MUL_S:begin
                                repeat(1)@(vif.ref_cb)
                                    ref_trans.RES = (ref_trans.OPA << 1) * ref_trans.OPB;
                                break;
                                end
                            default: begin
                             ref_trans.ERR = 1;
                             ref_trans.RES = {(`WIDTH){1'b0}};
                            end
                            endcase

                        end//9
                        else  //logical
                        begin //10
                            case (ref_trans.CMD)
                                `AND:begin
                                    ref_trans.RES = {1'b0, ref_trans.OPA & ref_trans.OPB};
                                    break;end
                                `NAND:begin
                                    ref_trans.RES = {1'b0, ~(ref_trans.OPA & ref_trans.OPB)};
                                    break;end
                                `OR:begin
                                    ref_trans.RES = {1'b0, ref_trans.OPA | ref_trans.OPB};
                                    break;
                                end
                                `NOR: begin
                                    ref_trans.RES = {1'b0, ~(ref_trans.OPA | ref_trans.OPB)};
                                break;
                                end
                                `XOR:begin
                                    ref_trans.RES = {1'b0, ref_trans.OPA ^ ref_trans.OPB};
                                break;
                                end
                                `XNOR:begin
                                    ref_trans.RES = {1'b0, ~(ref_trans.OPA ^ ref_trans.OPB)};
                                break;
                                end
                                `ROL: begin
                                    rot_val= ref_trans.OPB[rot_bits-1:0];
                                    ref_trans.RES = {1'b0, (ref_trans.OPA << rot_val) | (ref_trans.OPA >> (`WIDTH - rot_val))};
                                    ref_trans.ERR = (ref_trans.OPB >= `WIDTH);
                                 break;
                                end

                                `ROR: begin
                                    rot_val= ref_trans.OPB[rot_bits-1:0];
                                    ref_trans.RES = {1'b0, (ref_trans.OPA >> rot_val) | (ref_trans.OPA << (`WIDTH - rot_val))};
                                    ref_trans.ERR = (ref_trans.OPB >= `WIDTH);
                                break;
                                end

                        default: begin
                            ref_trans.RES = {(`WIDTH){1'b0}};
                            ref_trans.ERR = 1'b1;
                        end
                    endcase
                             // mbx_rs.put(ref_trans);  //logical sent to score
                        end  //10
                    end  //8
                    else
                    begin
                        $display("[REFERENCE MODEL]else part took AT TIME =%d,for i=%d",$time,i);
                        ref_trans.RES = 'bz;
                        ref_trans.OFLOW = 'bz;
                        ref_trans.COUT = 'bz;
                        ref_trans.G = 'bz;
                        ref_trans.L = 'bz;
                        ref_trans.E = 'bz;
                        //mbx_rs.put(ref_trans);
                    end

                end //7
                if(count >= 16 && ref_trans.INP_VALID != 2'b11) begin
                                ref_trans.ERR = 1;
                                //f_trans.RES = z;
                        $display("[REFERENCE MODEL] Timeout: No valid inputs received after 16 cycles");
                        end
            end  //5

            // Handle single operand commands with operand A valid
            else if(ref_trans.INP_VALID==2'b01)  //inp_valid 01 one operand
              begin
                if(ref_trans.MODE==1'b1 && ref_trans.CMD inside{4,5})   // arith a valid
                  begin
                  case(ref_trans.CMD)
                            `INC_A: begin
                                    ref_trans.RES = ref_trans.OPA + 1;
                              ref_trans.COUT = ref_trans.RES[`WIDTH];
                            end
                            `DEC_A: begin
                                    ref_trans.RES = ref_trans.OPA - 1;
                              ref_trans.OFLOW = (ref_trans.OPA == 0) ? 1 : 0;
                            end
                            default: begin
                                ref_trans.ERR = 1'b1;
                              ref_trans.RES = {(`WIDTH*2){1'b0}};
                            end
                        endcase
                  end
                else    // logical a valid
                  begin //11
                    if(ref_trans.CMD inside{6,8,9})begin
                    case (ref_trans.CMD)
                      `NOT_A: ref_trans.RES = {1'b0, ~ref_trans.OPA};
                      `SHR1_A: ref_trans.RES = {1'b0, ref_trans.OPA >> 1};
                      `SHL1_A: ref_trans.RES = {1'b0, ref_trans.OPA << 1};
                            default: begin
                                ref_trans.ERR = 1'b1;
                              ref_trans.RES = {(`WIDTH*2){1'b0}};
                            end
                        endcase
                    end
                  end  //11
              end

            // Handle single operand commands with operand B valid
            else if(ref_trans.INP_VALID==2'b10)   // arith b valid
              begin
                if(ref_trans.MODE==1'b1 && ref_trans.CMD inside{6,7})
                  begin
                  case(ref_trans.CMD)
                            `INC_B: begin
                                    ref_trans.RES = ref_trans.OPB+ 1;
                              ref_trans.COUT = ref_trans.RES[`WIDTH];
                            end
                            `DEC_B: begin
                                    ref_trans.RES = ref_trans.OPB - 1;
                              ref_trans.OFLOW = (ref_trans.OPB == 0) ? 1 : 0;
                            end
                            default: begin
                                ref_trans.ERR = 1'b1;
                              ref_trans.RES = {(`WIDTH*2){1'b0}};
                            end
                        endcase
                  end
                else     // logical b valid
                  begin //11
                    if(ref_trans.CMD inside{7,10,11})begin
                    case (ref_trans.CMD)
                      `NOT_B: ref_trans.RES = {1'b0, ~ref_trans.OPB};
                      `SHR1_B: ref_trans.RES = {1'b0, ref_trans.OPB >> 1};
                      `SHL1_B: ref_trans.RES = {1'b0, ref_trans.OPB << 1};
                            default: begin
                                ref_trans.ERR = 1'b1;
                              ref_trans.RES = {(`WIDTH*2){1'b0}};
                            end
                        endcase
                    end
                  end  //11
              end

          end  //4



       end //2
       mbx_rs.put(ref_trans);
        $display("ref put happened at time-%d for i=%d count=%d",$time,i,count);
      end  //1
    endtask

endclass
