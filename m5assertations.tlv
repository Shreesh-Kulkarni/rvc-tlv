\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // Welcome!  New to Makerchip? Try the "Learn" menu.
   // =================================================
   
   use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV c_ext_decode($_inputinstr)
   $is_compressed = ($_inputinstr == 16'bx);
   $more_to_do = $valid_decode && 1'b0 && $is_compressed && !($more_to_do_pc[1] == 1'b1);
   $more_to_do_pc[31:2] = $reset ? 30'b0 : >>1$more_to_do_pc + 2'b10;
   $c_instr[15:0] = $more_to_do ? $_inputinstr : >>1$c_instr;
   $instr[31:0] = $more_to_do ? (
                ( $c_instr[15:0] ==? 16'b0001xxxxxxxxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN0 
                ( $c_instr[15:0] ==? 16'b000x1xxxxxxxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN1
                ( $c_instr[15:0] ==? 16'b000xx1xxxxxxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN2
                ( $c_instr[15:0] ==? 16'b000xxx1xxxxxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN3
                ( $c_instr[15:0] ==? 16'b000xxxx1xxxxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN4
                ( $c_instr[15:0] ==? 16'b000xxxxx1xxxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN5
                ( $c_instr[15:0] ==? 16'b000xxxxxx1xxxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN6
                ( $c_instr[15:0] ==? 16'b000xxxxxxx1xxx00 ) ? {2'b0, {$c_instr[10:7], $c_instr[12:11], $c_instr[5] , $c_instr[6] ,2'b0}, 5'b00010 , 3'b000  , {2'b01, $c_instr[4:2]}, 5'b00100     , 2'b11} :  //CADDI4SPN7
                ( $c_instr[15:0] ==? 16'b010xxxxxxxxxxx00 ) ? {5'b0, {$c_instr[5], $c_instr[12:10], $c_instr[6], 2'd0}, {2'b01, $c_instr[9:7]}, 3'b010, {2'b01, $c_instr[4:2]}, 5'b00000, 2'b11} : //CLW
                ( $c_instr[15:0] ==? 16'b110xxxxxxxxxxx00 ) ? {5'b0, {$c_instr[5], $c_instr[12]} , {2'b01, $c_instr[4:2]}, {2'b01, $c_instr[9:7]}, 3'b010, {$c_instr[11:10], $c_instr[6], 2'd0}, 5'b01000, 2'b11} : //CSW
                ( $c_instr[15:0] ==? 16'b010xxxxxxxxxxx01 ) ? {{6{$c_instr[12]}}, {$c_instr[12], $c_instr[6:2]}, 5'b00000, 3'b000, $c_instr[11:7], 5'b00100, 2'b11} : //CLI
                ( $c_instr[15:0] ==? 16'b000xxxxxxxxxxx01 ) ? {{6{$c_instr[12]}}, {$c_instr[12], $c_instr[6:2]}, {$c_instr[11:7]}, 3'b000, $c_instr[11:7], 5'b00100, 2'b11} :  //CADDI
                ( $c_instr[15:0] ==? 16'b001xxxxxxxxxxx01 ) ? {{$c_instr[12], $c_instr[8], $c_instr[10:9], $c_instr[6], $c_instr[7], $c_instr[2], $c_instr[11], $c_instr[5:3],{9{$c_instr[12]}}}, 5'b00001, 5'b11011, 2'b11} :  //CJAL
                ( $c_instr[15:0] ==? 16'b100x00xxxxxxxx01 ) ? {{6'b000000, $c_instr[12], $c_instr[6:2]}, {2'b01, $c_instr[9:7]}, 3'b101, {2'b01, $c_instr[9:7]}, 5'b00100, 2'b11} :  //CSRLI
                ( $c_instr[15:0] ==? 16'b100x01xxxxxxxx01 ) ? {{6'b010000, $c_instr[12], $c_instr[6:2]}, {2'b01, $c_instr[9:7]}, 3'b101, {2'b01, $c_instr[9:7]}, 5'b00100, 2'b11} :  //CSRAI
                ( $c_instr[15:0] ==? 16'b100x10xxxxxxxx01 ) ? {{6{$c_instr[12]}}, {$c_instr[12], $c_instr[6:2]}, {2'b01, $c_instr[9:7]}, 3'b111, {2'b01, $c_instr[9:7]}, 5'b00100, 2'b11} :  //CANDI
                ( $c_instr[15:0] ==? 16'b100011xxx00xxx01 ) ? {7'b0100000, {2'b01, $c_instr[4:2]}, {2'b01, $c_instr[9:7]}, 3'b000, {2'b01, $c_instr[9:7]}, 5'b01100, 2'b11} :  //CSUB
                ( $c_instr[15:0] ==? 16'b100011xxx01xxx01 ) ? {7'b0000000, {2'b01, $c_instr[4:2]}, {2'b01, $c_instr[9:7]}, 3'b100, {2'b01, $c_instr[9:7]}, 5'b01100, 2'b11} :  //CXOR
                ( $c_instr[15:0] ==? 16'b100011xxx10xxx01 ) ? {7'b0000000, {2'b01, $c_instr[4:2]}, {2'b01, $c_instr[9:7]}, 3'b110, {2'b01, $c_instr[9:7]}, 5'b01100, 2'b11} :  //COR
                ( $c_instr[15:0] ==? 16'b100011xxx11xxx01 ) ? {7'b0000000, {2'b01, $c_instr[4:2]}, {2'b01, $c_instr[9:7]}, 3'b111, {2'b01, $c_instr[9:7]}, 5'b01100, 2'b11} :  //CAND
                ( $c_instr[15:0] ==? 16'b101xxxxxxxxxxx01 ) ? {{$c_instr[12], $c_instr[8], $c_instr[10:9], $c_instr[6], $c_instr[7], $c_instr[2], $c_instr[11], $c_instr[5:3], $c_instr[12], $c_instr[12], $c_instr[12], $c_instr[12], $c_instr[12], $c_instr[12],$c_instr[12], $c_instr[12], $c_instr[12]}, 5'b00000, 5'b11011, 2'b11} :  //CJ
                ( $c_instr[15:0] ==? 16'b110xxxxxxxxxxx01 ) ? {{$c_instr[12], $c_instr[12], $c_instr[12], $c_instr[12], $c_instr[6:5], $c_instr[2]}, 5'b00000, {2'b01, $c_instr[9:7]}, 3'b000, {$c_instr[11:10], $c_instr[4:3], $c_instr[12]}, 5'b11000, 2'b11} :  //CBEQZ
                ( $c_instr[15:0] ==? 16'b111xxxxxxxxxxx01 ) ? {{$c_instr[12], $c_instr[12], $c_instr[12], $c_instr[12], $c_instr[6:5], $c_instr[2]}, 5'b00000, {2'b01, $c_instr[9:7]}, 3'b001, {$c_instr[11:10], $c_instr[4:3], $c_instr[12]}, 5'b11000, 2'b11} :  //CBNEZ
                ( $c_instr[15:0] ==? 16'b000xxxxxxxxxxx10 ) ? {{6'b000000, $c_instr[12], $c_instr[6:2]}, {$c_instr[11:7]}, 3'b001, $c_instr[11:7], 5'b00100, 2'b11} :    //CSLLI
                ( $c_instr[15:0] ==? 16'b10001xxxx0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00000, 5'b11001, 2'b11} :  //CJR0
                ( $c_instr[15:0] ==? 16'b1000x1xxx0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00000, 5'b11001, 2'b11} :  //CJR1
                ( $c_instr[15:0] ==? 16'b1000xx1xx0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00000, 5'b11001, 2'b11} :  //CJR2
                ( $c_instr[15:0] ==? 16'b1000xxx1x0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00000, 5'b11001, 2'b11} :  //CJR3 
                ( $c_instr[15:0] ==? 16'b1000xxxx10000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00000, 5'b11001, 2'b11} :  //CJR4
                ( $c_instr[15:0] ==? 16'b1000xxxxx1xxxx10 ) ? {7'b0000000, {$c_instr[6:2]}, 5'b00000, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CMV0
                ( $c_instr[15:0] ==? 16'b1000xxxxxx1xxx10 ) ? {7'b0000000, {$c_instr[6:2]}, 5'b00000, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CMV1  
                ( $c_instr[15:0] ==? 16'b1000xxxxxxx1xx10 ) ? {7'b0000000, {$c_instr[6:2]}, 5'b00000, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CMV2  
                ( $c_instr[15:0] ==? 16'b1000xxxxxxxx1x10 ) ? {7'b0000000, {$c_instr[6:2]}, 5'b00000, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CMV3  
                ( $c_instr[15:0] ==? 16'b1000xxxxxxxxx110 ) ? {7'b0000000, {$c_instr[6:2]}, 5'b00000, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CMV4
                ( $c_instr[15:0] ==? 16'b10011xxxx0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00001, 5'b11001, 2'b11} :  //CJALR0
                ( $c_instr[15:0] ==? 16'b1001x1xxx0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00001, 5'b11001, 2'b11} :  //CJALR1
                ( $c_instr[15:0] ==? 16'b1001xx1xx0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00001, 5'b11001, 2'b11} :  //CJALR2
                ( $c_instr[15:0] ==? 16'b1001xxx1x0000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00001, 5'b11001, 2'b11} :  //CJALR3
                ( $c_instr[15:0] ==? 16'b1001xxxx10000010 ) ? {31'b0, {$c_instr[3:2], $c_instr[12], $c_instr[6:4], 2'd0}, {$c_instr[11:7]}, 3'b000, 5'b00001, 5'b11001, 2'b11} :  //CJALR4
                ( $c_instr[15:0] ==? 16'b1001xxxxx1xxxx10 ) ? {7'b0000000, {$c_instr[6:2]}, {$c_instr[11:7]}, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CADD0
                ( $c_instr[15:0] ==? 16'b1001xxxxxx1xxx10 ) ? {7'b0000000, {$c_instr[6:2]}, {$c_instr[11:7]}, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CADD1 
                ( $c_instr[15:0] ==? 16'b1001xxxxxxx1xx10 ) ? {7'b0000000, {$c_instr[6:2]}, {$c_instr[11:7]}, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CADD2 
                ( $c_instr[15:0] ==? 16'b1001xxxxxxxx1x10 ) ? {7'b0000000, {$c_instr[6:2]}, {$c_instr[11:7]}, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CADD3 
                ( $c_instr[15:0] ==? 16'b1001xxxxxxxxx110 ) ? {7'b0000000, {$c_instr[6:2]}, {$c_instr[11:7]}, 3'b000, $c_instr[11:7], 5'b01100, 2'b11} :  //CADD4 
               32'bx) : $c_instr[31:0] ;
   
\TLV
   $reset = *reset;
   m5+c_ext_decode($foo[15:0])
   //...
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
