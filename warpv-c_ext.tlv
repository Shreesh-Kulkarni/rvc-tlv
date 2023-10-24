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
   /* verilator lint_on WIDTH */
\TLV c_ext_decode()
   $cinstr[15:0] = $Pc[1] ? $raw[31:16] : $raw[15:0];
   $is_compressed = ($cinstr[1:0] != 2'b11);
   $more_to_do = ! $Pc[1] && $is_compressed;
   $more_to_do_pc[31:0] = $reset ? 32'b0 : $Pc[31:0] + 32'b10;
   
   // Peculiar decode fields.
   $csub_xor_or_and_func3[2:0] =
      ( $cinstr[6:5] == 2'b00 ) ? 3'b000 :
      ( $cinstr[6:5] == 2'b01 ) ? 3'b100 :
      ( $cinstr[6:5] == 2'b10 ) ? 3'b110 :
                                  3'b111;
   $cmatch = 1'b1;
   {$instr[31:0], $matched_cinstr} =
          //                                                   funct7/imm                                     rs2/imm                  rs1/imm                           funct3/imm              rd/imm                               opcode
          // CR Format:            fn4   rd/1   rs2    op  => funct7, rs2, rs1, funct3, rd, op
          ( $cinstr[15:0] ==? 16'b_100_x_xx_xxx_xx_xxx_10 ) ? {7'b0000000,                                   $cinstr[6:2],            $cinstr[11:7] & {5{$cinstr[12]}}, 3'b000,                 $cinstr[11:7],                               5'b01100, 2'b11, $cmatch} :  //CMV0-4, CADD0-4
          // CA Format:            fn6,     r*' f2 r2' op  => funct7, rs2,rs1,funct3,rd, op
          ( $cinstr[15:0] ==? 16'b_100_0_11_xxx_xx_xxx_01 ) ? {{1'b0, $cinstr[6:5] == 2'b00, 5'b00000},     {2'b01, $cinstr[4:2]},    {2'b01, $cinstr[9:7]}, $csub_xor_or_and_func3,            {2'b01, $cinstr[9:7]},                       5'b01100, 2'b11, $cmatch} :  //CSUB,CXOR,COR,CAND
          // CI Format:            fn3 i rd/1   imm    op  => imm, rs1, funct3, rd, op
          ( $cinstr[15:0] ==? 16'b_000_x_xx_xxx_xx_xxx_00 ) ? {{2'b0, $cinstr[10:7], $cinstr[12:11], $cinstr[5], $cinstr[6] ,2'b0},   5'b00010,                         3'b000,                 {2'b01, $cinstr[4:2]},                       5'b00100, 2'b11, $cmatch} :  //CADDI4SPN0-7
          ( $cinstr[15:0] ==? 16'b_010_x_xx_xxx_xx_xxx_01 ) ? {{{6{$cinstr[12]}}, $cinstr[12]},              $cinstr[6:2],            5'b00000,                         3'b000,                 $cinstr[11:7],                               5'b00100, 2'b11, $cmatch} :  //CLI
          ( $cinstr[15:0] ==? 16'b_000_x_xx_xxx_xx_xxx_01 ) ? {{{6{$cinstr[12]}}, $cinstr[12]},              $cinstr[6:2],            $cinstr[11:7],                    3'b000,                 $cinstr[11:7],                               5'b00100, 2'b11, $cmatch} :  //CADDI
          ( $cinstr[15:0] ==? 16'b_100_x_00_xxx_xx_xxx_01 ) ? {{1'b0, $cinstr[10], 4'b0000, $cinstr[12]},    $cinstr[6:2],            {2'b01, $cinstr[9:7]},            3'b101,                 {2'b01, $cinstr[9:7]},                       5'b00100, 2'b11, $cmatch} :  //CSRLI, CSRAI
          ( $cinstr[15:0] ==? 16'b_100_x_10_xxx_xx_xxx_01 ) ? {{{6{$cinstr[12]}}, $cinstr[12]},              $cinstr[6:2],            {2'b01, $cinstr[9:7]},            3'b111,                 {2'b01, $cinstr[9:7]},                       5'b00100, 2'b11, $cmatch} :  //CANDI
          ( $cinstr[15:0] ==? 16'b_000_x_xx_xxx_xx_xxx_10 ) ? {{6'b000000, $cinstr[12]},                     $cinstr[6:2],            $cinstr[11:7],                    3'b001,                 $cinstr[11:7],                               5'b00100, 2'b11, $cmatch} :  //CSLLI
          ( $cinstr[15:0] ==? 16'b_100_x_xx_xxx_00_000_10 ) ? {{3'b0, $cinstr[3:2], $cinstr[12]},            {$cinstr[6:4], 2'd0},    $cinstr[11:7],                    3'b000,                 {4'b00000, $cinstr[12]},                     5'b11001, 2'b11, $cmatch} :  //CJR0-4, CJALR0-4
          // CSS Format:           fn3 imm      rs2    op  => imm, rs2, rs1, funct3, imm, op
          // CIW Format:           fn3 imm         rd' op  => imm, rs1, funct3, rd, op
          // CL Format:            fn3 imm  r1' i  rd' op  => imm, rs1, funct3, rd, op
          ( $cinstr[15:0] ==? 16'b_010_x_xx_xxx_xx_xxx_00 ) ? {{5'b0, $cinstr[5], $cinstr[12:10], $cinstr[6], 2'd0},                  {2'b01, $cinstr[9:7]},            3'b010,                 {2'b01, $cinstr[4:2]},                       5'b00000, 2'b11, $cmatch} :  //CLW
          // CS Format:            fn3 imm  r1' i  r2' op  => imm, rs2,rs1,funct3,imm,op
          ( $cinstr[15:0] ==? 16'b_110_x_xx_xxx_xx_xxx_00 ) ? {{5'b0, $cinstr[5], $cinstr[12]},              {2'b01, $cinstr[4:2]},   {2'b01, $cinstr[9:7]},            3'b010,                 {$cinstr[11:10], $cinstr[6], 2'd0},          5'b01000, 2'b11, $cmatch} :  //CSW
          // CB Format:            fn3 off  r1' off    op  => imm, rs2,rs1,funct3,imm,op
          ( $cinstr[15:0] ==? 16'b_11x_x_xx_xxx_xx_xxx_01 ) ? {{{4{$cinstr[12]}}, $cinstr[6:5], $cinstr[2]}, 5'b00000,                {2'b01, $cinstr[9:7]},            {2'b00, $cinstr[13]},   {$cinstr[11:10], $cinstr[4:3], $cinstr[12]}, 5'b11000, 2'b11, $cmatch} :  //CBEQZ,CBNEZ
          // CJ Format:            fn3 jump-target     op  => imm, rd, op
          ( $cinstr[15:0] ==? 16'b_001_x_xx_xxx_xx_xxx_01 ) ? {{$cinstr[12], $cinstr[8], $cinstr[10:9], $cinstr[6], $cinstr[7], $cinstr[2], $cinstr[11], $cinstr[5:3], {9{$cinstr[12]}}, 5'b00001},                                          5'b11011, 2'b11, $cmatch} :  //CJAL
          ( $cinstr[15:0] ==? 16'b_101_x_xx_xxx_xx_xxx_01 ) ? {{$cinstr[12], $cinstr[8], $cinstr[10:9], $cinstr[6], $cinstr[7], $cinstr[2], $cinstr[11], $cinstr[5:3], {9{$cinstr[12]}}, 5'b00000},                                          5'b11011, 2'b11, $cmatch} :  //CJ
                                                              {32'bx, 1'b0};
   
   `BOGUS_USE($matched_cinstr)   // TODO: I'm not sure whether $matched_cinstr will actually be needed.
   
\TLV
   $reset = *reset;
   m5+c_ext_decode($foo[15:0])
   //...
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
