`include "define.sv"
class alu_reference_model;

mailbox #(alu_transaction) mbx_dr;
mailbox #(alu_transaction) mbx_rs;
alu_transaction ref_trans;
virtual alu_inf.REF vif;

function new(mailbox #(alu_transaction) mbx_dr,
               mailbox #(alu_transaction) mbx_rs,
               virtual alu_inf.REF vif);
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs;
    this.vif=vif;
  endfunction

  int shift_value,got,inside_16;
  localparam int required_bits = $clog2(`WIDTH);


task start();
  repeat(1)@(vif.ref_cb);
    begin
  for(int i=0;i<`no_of_transaction;i++)
    begin
      got=0;
      ref_trans=new();
      if(inside_16==1)
        begin $display("ref came here at time=%t",$time);
          mbx_dr.get(ref_trans);end
      else
        begin
          @(vif.ref_cb);
          $display("[ref]came here for mul at time=%t",$time);
          mbx_dr.get(ref_trans);
        end
        inside_16=0;
      $display("[REF MODEL @%t] Reference model got values for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,INP_VALID=%0d,CMD=%0d",$time,i,ref_trans.OPA,ref_trans.OPB,ref_trans.CIN,ref_trans.CE,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD);
      if(vif.ref_cb.RST==1)
           begin
             ref_trans.RES=9'bz;
             ref_trans.OFLOW=1'bz;
             ref_trans.COUT=1'bz;
             ref_trans.G=1'bz;
             ref_trans.L=1'bz;
             ref_trans.E=1'bz;
             ref_trans.ERR=1'bz;
           end
         else
           begin
             if(ref_trans.CE==1)
              begin
                 if(ref_trans.INP_VALID == 2'b01 || ref_trans.INP_VALID == 2'b10)
                     begin
                       if(((ref_trans.MODE==1)&& (ref_trans.CMD inside {0,1,2,3,8,9,10})) || ((ref_trans.MODE==0)&& (ref_trans.CMD inside {0,1,2,3,4,5,12,13})))
                         begin

                           mbx_dr.get(ref_trans);  

                           $display("[REF MODEL @%t]Here comes",$time);
                           $display("[REF MODEL @%t]Reference model got next get data:OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,INP_VALID=%0d,CMD=%0d",$time,ref_trans.OPA,ref_trans.OPB,ref_trans.CIN,ref_trans.CE,ref_trans.MODE,ref_trans.INP_VALID,ref_trans.CMD);
                           repeat(16)@(vif.ref_cb)
                           begin
                             inside_16=1;
                           if(ref_trans.INP_VALID==2'b11)
                            begin
                              got=1;
                             if(ref_trans.MODE==1)
                               begin
                                case(ref_trans.CMD)
                                  `ADD:begin
                                            ref_trans.RES=(ref_trans.OPA+ref_trans.OPB);
                                    ref_trans.COUT=ref_trans.RES[`WIDTH]?1:0;
                                              end
                                      `SUB:begin
                                           ref_trans.RES=(ref_trans.OPA-ref_trans.OPB);
                                           ref_trans.OFLOW=(ref_trans.OPA<ref_trans.OPB)?1:0;
                                              end
                                      `ADD_CIN:begin
                                                 ref_trans.RES=(ref_trans.OPA+ref_trans.OPB+ref_trans.CIN);
                                        ref_trans.COUT=ref_trans.RES[`WIDTH]?1:0;
                                              end
                                      `SUB_CIN:begin
                                                 ref_trans.RES=(ref_trans.OPA-ref_trans.OPB-ref_trans.CIN);
                                                 ref_trans.OFLOW=((ref_trans.OPA<ref_trans.OPB)||((ref_trans.OPA==ref_trans.OPB)&&ref_trans.CIN))?1:0;
                                               end
                                  `CMP:begin
                                          ref_trans.E=(ref_trans.OPA==ref_trans.OPB)? 1'b1:1'bz;
                                          ref_trans.G=(ref_trans.OPA>ref_trans.OPB)? 1'b1:1'bz;
                                          ref_trans.L=(ref_trans.OPA<ref_trans.OPB)? 1'b1:1'bz;
                                      end
                                  `MUL_IN:begin
                                              ref_trans.RES=(ref_trans.OPA+1)*(ref_trans.OPB+1);
                                          end
                                  `MUL_S:begin
                                               ref_trans.RES=(ref_trans.OPA<<1)*(ref_trans.OPB);
                                            end
                                  default:begin
                                               ref_trans.RES=9'bz;
                                               ref_trans.OFLOW=1'bz;
                                               ref_trans.COUT=1'bz;
                                               ref_trans.ERR=1'bz;
                                               ref_trans.G=1'bz;
                                               ref_trans.L=1'bz;
                                               ref_trans.E=1'bz;
                                          end
                                endcase
                               end 
                  else            
                    begin
                      case(ref_trans.CMD)
                        `AND:begin
                                ref_trans.RES={1'b0,(ref_trans.OPA & ref_trans.OPB)};
                            end
                        `NAND:begin
                               ref_trans.RES={1'b0,~(ref_trans.OPA & ref_trans.OPB)};
                            end
                        `OR:begin
                               ref_trans.RES={1'b0,(ref_trans.OPA | ref_trans.OPB)};
                            end
                        `NOR:begin
                               ref_trans.RES={1'b0,~(ref_trans.OPA | ref_trans.OPB)};
                            end
                        `XOR:begin
                               ref_trans.RES={1'b0,(ref_trans.OPA ^ ref_trans.OPB)};
                            end
                        `XNOR:begin
                                ref_trans.RES={1'b0,~(ref_trans.OPA ^ ref_trans.OPB)};
                            end
                        `ROL:begin
                                 shift_value=ref_trans.OPB[required_bits-1:0];
                                 ref_trans.RES={1'b0,((ref_trans.OPA<<shift_value)|(ref_trans.OPA>>`WIDTH-shift_value))};
                          if(ref_trans.OPB>`WIDTH-1)
                                  ref_trans.ERR=1;
                                 else
                                  ref_trans.ERR=0;
                                end
                        `ROR:begin
                                 shift_value=ref_trans.OPB[required_bits-1:0];
                                 ref_trans.RES={1'b0,((ref_trans.OPA>>shift_value)|(ref_trans.OPA<<`WIDTH-shift_value))};
                                if(ref_trans.OPB>`WIDTH-1)
                                  ref_trans.ERR=1;
                                 else
                                  ref_trans.ERR=0;
                                end
                        default:begin
                               ref_trans.RES=9'bz;
                               ref_trans.OFLOW=1'bz;
                               ref_trans.COUT=1'bz;
                               ref_trans.G=1'bz;
                               ref_trans.L=1'bz;
                               ref_trans.E=1'bz;
                              ref_trans.ERR=1'bz;
                              end
                      endcase
                  end 
                if(got==1)
                   break; 
             end 
           end 
              if(got==1 && ref_trans.ERR==1)
                  ref_trans.ERR=1;
              else if(got==1 && ref_trans.ERR==0)
                  ref_trans.ERR=0;
              else
                  ref_trans.ERR=1;
         end  
    else if((ref_trans.MODE==1 && ref_trans.CMD inside {4,5,6,7}) || (ref_trans.MODE==0 && ref_trans.CMD inside {6,7,8,9,10,11}))
      begin
       if(ref_trans.MODE==1)
          begin
            if(ref_trans.INP_VALID==01)
              begin
               case(ref_trans.CMD)
                `INC_A:begin
                        ref_trans.RES=ref_trans.OPA+1;
                    end
                `DEC_A:begin
                        ref_trans.RES=ref_trans.OPA-1;
                    end
                 default:begin
                        ref_trans.RES=9'bz;
                        ref_trans.OFLOW=1'bz;
                        ref_trans.COUT=1'bz;
                        ref_trans.G=1'bz;
                        ref_trans.L=1'bz;
                        ref_trans.E=1'bz;
                        ref_trans.ERR=1'bz;
                      end
               endcase 
            end 
         else
           begin
             case(ref_trans.CMD)
               `INC_B:begin
                        ref_trans.RES=ref_trans.OPB+1;
                      end
                `DEC_B:begin
                        ref_trans.RES=ref_trans.OPB-1;
                      end
                 default:begin
                        ref_trans.RES=9'bz;
                        ref_trans.OFLOW=1'bz;
                        ref_trans.COUT=1'bz;
                        ref_trans.G=1'bz;
                        ref_trans.L=1'bz;
                        ref_trans.E=1'bz;
                        ref_trans.ERR=1'bz;
                      end
              endcase
            end
          end
        else
          begin
          if(ref_trans.INP_VALID==2'b01)
            begin
            case(ref_trans.CMD)
              `NOT_A:begin
                        ref_trans.RES={1'b0,~(ref_trans.OPA)};
                    end
              `SHR1_A:begin
                       ref_trans.RES={1'b0,(ref_trans.OPA>>1)};
                    end
              `SHL1_A:begin
                        ref_trans.RES={1'b0,(ref_trans.OPA<<1)};
                    end
              default:begin
                        ref_trans.RES=9'bz;
                        ref_trans.OFLOW=1'bz;
                        ref_trans.COUT=1'bz;
                        ref_trans.G=1'bz;
                        ref_trans.L=1'bz;
                        ref_trans.E=1'bz;
                        ref_trans.ERR=1'bz;
                      end
             endcase
            end
          else
             begin
               case(ref_trans.CMD)
               `NOT_B:begin
                       ref_trans.RES={1'b0,~(ref_trans.OPB)};
                      end
                `SHR1_B:begin
                         ref_trans.RES={1'b0,(ref_trans.OPB>>1)};
                        end
                `SHL1_B:begin
                         ref_trans.RES={1'b0,(ref_trans.OPB<<1)};
                        end
                  default:begin
                        ref_trans.RES=9'bz;
                        ref_trans.OFLOW=1'bz;
                        ref_trans.COUT=1'bz;
                        ref_trans.G=1'bz;
                        ref_trans.L=1'bz;
                        ref_trans.E=1'bz;
                        ref_trans.ERR=1'bz;
                      end
                endcase
             end
           end 
      end 
  end 
else if (ref_trans.INP_VALID==2'b11)
  begin
      if(ref_trans.MODE==1)
        begin
            case(ref_trans.CMD)
                             `ADD:begin
                                    ref_trans.RES=(ref_trans.OPA+ref_trans.OPB);
                                    ref_trans.COUT=ref_trans.RES[`WIDTH]?1:0;
                                  end
                                 `SUB:begin
                                        ref_trans.RES=(ref_trans.OPA-ref_trans.OPB);
                                        ref_trans.OFLOW=(ref_trans.OPA<ref_trans.OPB)?1:0;
                                         end
                                 `ADD_CIN:begin
                                            ref_trans.RES=(ref_trans.OPA+ref_trans.OPB+ref_trans.CIN);
                                            ref_trans.COUT=ref_trans.RES[`WIDTH]?1:0;
                                         end
                                `SUB_CIN:begin
                                             ref_trans.RES=(ref_trans.OPA-ref_trans.OPB-ref_trans.CIN);
                                             ref_trans.OFLOW=((ref_trans.OPA<ref_trans.OPB)||((ref_trans.OPA==ref_trans.OPB)&&ref_trans.CIN))?1:0;
                                         end
                                `CMP:begin
                                            ref_trans.E=(ref_trans.OPA==ref_trans.OPB)? 1'b1:1'bz;
                                            ref_trans.G=(ref_trans.OPA>ref_trans.OPB)? 1'b1:1'bz;
                                            ref_trans.L=(ref_trans.OPA<ref_trans.OPB)? 1'b1:1'bz;
                                      end
                           `MUL_IN:begin
                                     ref_trans.RES=(ref_trans.OPA+1)*(ref_trans.OPB+1);
                                   end
                           `MUL_S:begin
                                       ref_trans.RES=(ref_trans.OPA<<1)*(ref_trans.OPB);
                                     end
                           `INC_A:begin
                                   ref_trans.RES=ref_trans.OPA+1;
                                  end
                           `DEC_A:begin
                                  ref_trans.RES=ref_trans.OPA-1;
                                  end
                          `INC_B:begin
                                  ref_trans.RES=ref_trans.OPB+1;
                                 end
                         `DEC_B:begin
                                 ref_trans.RES=ref_trans.OPB-1;
                                end
                           default:begin
                                        ref_trans.RES=9'bz;
                                        ref_trans.OFLOW=1'bz;
                                        ref_trans.COUT=1'bz;
                                        ref_trans.G=1'bz;
                                        ref_trans.L=1'bz;
                                        ref_trans.E=1'bz;
                                        ref_trans.ERR=1'bz;
                                   end
                        endcase
                    end
                  else 
                    begin
                      case(ref_trans.CMD)
                        `AND:begin
                                ref_trans.RES={1'b0,(ref_trans.OPA & ref_trans.OPB)};
                            end
                        `NAND:begin
                               ref_trans.RES={1'b0,~(ref_trans.OPA & ref_trans.OPB)};
                            end
                        `OR:begin
                               ref_trans.RES={1'b0,(ref_trans.OPA | ref_trans.OPB)};
                            end
                        `NOR:begin
                               ref_trans.RES={1'b0,~(ref_trans.OPA | ref_trans.OPB)};
                            end
                        `XOR:begin;
                               ref_trans.RES={1'b0,(ref_trans.OPA ^ ref_trans.OPB)};
                            end
                        `XNOR:begin
                                ref_trans.RES={1'b0,~(ref_trans.OPA ^ ref_trans.OPB)};
                            end
                        `ROL:begin
                                 shift_value=ref_trans.OPB[required_bits-1:0];
                                 ref_trans.RES={1'b0,((ref_trans.OPA<<shift_value)|(ref_trans.OPA>>`WIDTH-shift_value))};
                          if(ref_trans.OPB>`WIDTH-1)
                                  ref_trans.ERR=1;
                                 else
                                  ref_trans.ERR=1'bz;
                                end
                        `ROR:begin
                                 shift_value=ref_trans.OPB[required_bits-1:0];
                                 ref_trans.RES={1'b0,((ref_trans.OPA>>shift_value)|(ref_trans.OPA<<`WIDTH-shift_value))};
                          if(ref_trans.OPB>`WIDTH-1)
                                  ref_trans.ERR=1;
                                 else
                                  ref_trans.ERR=1'bz;
                                end
                         `NOT_A:begin
                                 ref_trans.RES={1'b0,~(ref_trans.OPA)};
                                end
                         `NOT_B:begin
                                ref_trans.RES={1'b0,~(ref_trans.OPB)};
                                end
                         `SHR1_A:begin
                                 ref_trans.RES={1'b0,(ref_trans.OPA>>1)};
                                 end
                        `SHL1_A:begin
                                ref_trans.RES={1'b0,(ref_trans.OPA<<1)};
                                end
                        `SHR1_B:begin
                                 ref_trans.RES={1'b0,(ref_trans.OPB>>1)};
                                end
                        `SHL1_B:begin
                                 ref_trans.RES={1'b0,(ref_trans.OPB<<1)};
                                end

                        default:begin
                                 ref_trans.RES=9'bz;
                                 ref_trans.OFLOW=1'bz;
                                 ref_trans.COUT=1'bz;
                                 ref_trans.G=1'bz;
                                 ref_trans.L=1'bz;
                                 ref_trans.E=1'bz;
                                 ref_trans.ERR=1'bz;
                              end
                      endcase
                  end 
            end  
   else  
     begin
       ref_trans.RES=ref_trans.RES;
       ref_trans.OFLOW=ref_trans.OFLOW;
       ref_trans.COUT=ref_trans.COUT;
       ref_trans.G=ref_trans.G;
       ref_trans.L=ref_trans.L;
       ref_trans.E=ref_trans.E;
       ref_trans.ERR=1'b1;
     end 
  end 
else  
    begin
       ref_trans.RES=ref_trans.RES;
       ref_trans.OFLOW=ref_trans.OFLOW;
       ref_trans.COUT=ref_trans.COUT;
       ref_trans.G=ref_trans.G;
       ref_trans.L=ref_trans.L;
       ref_trans.E=ref_trans.E;
       ref_trans.ERR=ref_trans.ERR;
     end
  end  
if( ref_trans.INP_VALID inside {0,1,2,3} && ((ref_trans.MODE==1 && ref_trans.CMD inside {0,1,2,3,4,5,6,7,8})|| (ref_trans.MODE==0 && ref_trans.CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13})))
 repeat(1)@(vif.ref_cb);
else if(ref_trans.INP_VALID==3 && ref_trans.MODE==1 && ref_trans.CMD inside {9,10})
 repeat(2)@(vif.ref_cb);

mbx_rs.put(ref_trans); 

      $display("[REF MODEL :@%t]Reference model done put ,sent to scoreboard for i=%d :OPA=%0d,OPB=%0d,CIN=%0d,CE=%0d,MODE=%0d,CMD=%0d,INP_VALID=%0d,RES=%0d,ERR=%0d,COUT=%0d,OFLOW=%0d,G=%0d,L=%0d,E=%0d",$time,i,ref_trans.OPA,ref_trans.OPB,ref_trans.CIN,ref_trans.CE,ref_trans.MODE,ref_trans.CMD,ref_trans.INP_VALID,ref_trans.RES,ref_trans.ERR,ref_trans.COUT,ref_trans.OFLOW,ref_trans.G,ref_trans.L,ref_trans.E);
end//for loop end
end
endtask


endclass
