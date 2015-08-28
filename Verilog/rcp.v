 // rcp.v  look-up table for reciprocal function
 `timescale 1ns/100ps
 // For use in SYMPL FP32X-AXI4 multi-thread RISC core only
 // Author:  Jerry D. Harthcock
 // Version:  1.21 August 27, 2015
 // December 9, 2014
 // Copyright (C) 2014.  All rights reserved without prejudice.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //                                                                                                               //
 //                              SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC                                         //
 //                              Evaluation and Product Development License                                       //
 //                                                                                                               //
 // Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
 // the original author and exclusive copyright owner of this SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC            //
 // Verilog RTL IP core ("this IP"), hereby grants to recipient of this IP ("licensee"), a world-wide, paid-up,   //
 // non-exclusive license to use this IP for the purposes of evaluation, education, and development of end        //
 // products and related development tools only.                                                                  //
 //                                                                                                               //
 // Also subject to the terms and conditions set forth herein, Jerry D. Harthcock, exlusive inventor and owner    //
 // of US Patent No. 7,073,048, entitled "CASCADED MICROCOMPUTER ARRAY AND METHOD", issue date July 4, 2006       //
 // ("the '048 patent"), hereby grants a world-wide, paid-up, non-exclusive license under the '048 patent to use  //
 // this IP for the purposes of evaluation, education, and development of end products and related development    //
 // tools only.                                                                                                   //
 //                                                                                                               //
 // Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
 // and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
 // binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
 // netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
 // any copyright notices from any source file covered under this Evaluation and Product Development License.     //
 //                                                                                                               //
 // LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR     //
 // THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM   //
 // ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                //
 //                                                                                                               //
 // Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
 // or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
 // of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
 // in this Evaluation and Product Development License.                                                           //
 //                                                                                                               //
 // This Evaluation and Product Development License does not include the right to sell products that incorporate  //
 // this IP, any IP derived from this IP, or the '048 patent.  If you would like to obtain such a license, please //
 // contact Licensor.                                                                                             //
 //                                                                                                               //
 // Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                            //
 //                                                                                                               //
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module rcp (
    rdenA,
    x,
    rddataA);    

input         rdenA;
input  [7:0]  x;
output [31:0] rddataA;

reg [31:0] rcp;

wire [31:0] rddataA;

wire [7:0] absltx;
wire [7:0] lookup;

assign absltx = x[7] ? (8'h00 - x) : x;   //get absolute value of input x
assign lookup = absltx[7:0];
assign rddataA = {x[7], rcp[30:0]};

always @(rdenA or lookup) begin
    if (rdenA) 
        case (lookup)                      //  ; 1/x in range  (+/-) 1/0 : 1/127  with 1/0 returning 32'hEFFFFFFF          
            8'h00 : rcp = 31'h7FFFFFFF;    //  rcp_0:   DFL   0xFFFFFFFF   
            8'h01 : rcp = 31'h3F800000;    //  rcp_1:   DFF   1  
            8'h02 : rcp = 31'h3F000000;    //  rcp_2:   DFF   0.5  
            8'h03 : rcp = 31'h3EAAAAAB;    //  rcp_3:   DFF   0.33333333333333333333333333333333  
            8'h04 : rcp = 31'h3E800000;    //  rcp_4:   DFF   0.25  
            8'h05 : rcp = 31'h3E4CCCCD;    //  rcp_5:   DFF   0.2  
            8'h06 : rcp = 31'h3E2AAAAB;    //  rcp_6:   DFF   0.16666666666666666666666666666667  
            8'h07 : rcp = 31'h3E124925;    //  rcp_7:   DFF   0.14285714285714285714285714285714  
            8'h08 : rcp = 31'h3E000000;    //  rcp_8:   DFF   0.125  
            8'h09 : rcp = 31'h3DE38E39;    //  rcp_9:   DFF   0.11111111111111111111111111111111  
            8'h0A : rcp = 31'h3DCCCCCD;    //  rcp_10:  DFF   0.1  
            8'h0B : rcp = 31'h3DBA2E8C;    //  rcp_11:  DFF   0.09090909090909090909090909090909  
            8'h0C : rcp = 31'h3DAAAAAB;    //  rcp_12:  DFF   0.08333333333333333333333333333333  
            8'h0D : rcp = 31'h3D9D89D9;    //  rcp_13:  DFF   0.07692307692307692307692307692308  
            8'h0E : rcp = 31'h3D924925;    //  rcp_14:  DFF   0.07142857142857142857142857142857
            8'h0F : rcp = 31'h3D888889;    //  rcp_15:  DFF   0.06666666666666666666666666666667
            8'h10 : rcp = 31'h3D800000;    //  rcp_16:  DFF   0.0625
            8'h11 : rcp = 31'h3D70F0F1;    //  rcp_17:  DFF   0.05882352941176470588235294117647
            8'h12 : rcp = 31'h3D638E39;    //  rcp_18:  DFF   0.05555555555555555555555555555556
            8'h13 : rcp = 31'h3D579436;    //  rcp_19:  DFF   0.05263157894736842105263157894737
            8'h14 : rcp = 31'h3D4CCCCD;    //  rcp_20:  DFF   0.05
            8'h15 : rcp = 31'h3D430C31;    //  rcp_21:  DFF   0.04761904761904761904761904761905
            8'h16 : rcp = 31'h3D3A2E8C;    //  rcp_22:  DFF   0.04545454545454545454545454545455
            8'h17 : rcp = 31'h3D321643;    //  rcp_23:  DFF   0.04347826086956521739130434782609
            8'h18 : rcp = 31'h3D2AAAAB;    //  rcp_24:  DFF   0.04166666666666666666666666666667
            8'h19 : rcp = 31'h3D23D70A;    //  rcp_25:  DFF   0.04
            8'h1A : rcp = 31'h3D1D89D9;    //  rcp_26:  DFF   0.03846153846153846153846153846154
            8'h1B : rcp = 31'h3D17B426;    //  rcp_27:  DFF   0.03703703703703703703703703703704
            8'h1C : rcp = 31'h3D124925;    //  rcp_28:  DFF   0.03571428571428571428571428571429
            8'h1D : rcp = 31'h3D0D3DCB;    //  rcp_29:  DFF   0.03448275862068965517241379310345
            8'h1E : rcp = 31'h3D088889;    //  rcp_30:  DFF   0.03333333333333333333333333333333
            8'h1F : rcp = 31'h3D042108;    //  rcp_31:  DFF   0.03225806451612903225806451612903
            8'h20 : rcp = 31'h3D000000;    //  rcp_32:  DFF   0.03125
            8'h21 : rcp = 31'h3CF83E10;    //  rcp_33:  DFF   0.03030303030303030303030303030303
            8'h22 : rcp = 31'h3CF0F0F1;    //  rcp_34:  DFF   0.02941176470588235294117647058824
            8'h23 : rcp = 31'h3CEA0EA1;    //  rcp_35:  DFF   0.02857142857142857142857142857143
            8'h24 : rcp = 31'h3CE38E39;    //  rcp_36:  DFF   0.02777777777777777777777777777778
            8'h25 : rcp = 31'h3CDD67C9;    //  rcp_37:  DFF   0.02702702702702702702702702702703
            8'h26 : rcp = 31'h3CD79436;    //  rcp_38:  DFF   0.02631578947368421052631578947368
            8'h27 : rcp = 31'h3CD20D21;    //  rcp_39:  DFF   0.02564102564102564102564102564103
            8'h28 : rcp = 31'h3CCCCCCD;    //  rcp_40:  DFF   0.025
            8'h29 : rcp = 31'h3CC7CE0C;    //  rcp_41:  DFF   0.02439024390243902439024390243902
            8'h2A : rcp = 31'h3CC30C31;    //  rcp_42:  DFF   0.02380952380952380952380952380952
            8'h2B : rcp = 31'h3CBE82FA;    //  rcp_43:  DFF   0.02325581395348837209302325581395
            8'h2C : rcp = 31'h3CBA2E8C;    //  rcp_44:  DFF   0.02272727272727272727272727272727
            8'h2D : rcp = 31'h3CB60B61;    //  rcp_45:  DFF   0.02222222222222222222222222222222
            8'h2E : rcp = 31'h3CB21643;    //  rcp_46:  DFF   0.02173913043478260869565217391304
            8'h2F : rcp = 31'h3CAE4C41;    //  rcp_47:  DFF   0.02127659574468085106382978723404
            8'h30 : rcp = 31'h3CAAAAAB;    //  rcp_48:  DFF   0.02083333333333333333333333333333
            8'h31 : rcp = 31'h3CA72F05;    //  rcp_49:  DFF   0.02040816326530612244897959183673
            8'h32 : rcp = 31'h3CA3D70A;    //  rcp_50:  DFF   0.02
            8'h33 : rcp = 31'h3CA0A0A1;    //  rcp_51:  DFF   0.01960784313725490196078431372549
            8'h34 : rcp = 31'h3C9D89D9;    //  rcp_52:  DFF   0.01923076923076923076923076923077
            8'h35 : rcp = 31'h3C9A90E8;    //  rcp_53:  DFF   0.01886792452830188679245283018868
            8'h36 : rcp = 31'h3C97B426;    //  rcp_54:  DFF   0.01851851851851851851851851851852
            8'h37 : rcp = 31'h3C94F209;    //  rcp_55:  DFF   0.01818181818181818181818181818182
            8'h38 : rcp = 31'h3C924925;    //  rcp_56:  DFF   0.01785714285714285714285714285714
            8'h39 : rcp = 31'h3C8FB824;    //  rcp_57:  DFF   0.01754385964912280701754385964912
            8'h3A : rcp = 31'h3C8D3DCB;    //  rcp_58:  DFF   0.01724137931034482758620689655172
            8'h3B : rcp = 31'h3C8AD8F3;    //  rcp_59:  DFF   0.01694915254237288135593220338983
            8'h3C : rcp = 31'h3C888889;    //  rcp_60:  DFF   0.01666666666666666666666666666667
            8'h3D : rcp = 31'h3C864B8A;    //  rcp_61:  DFF   0.01639344262295081967213114754098
            8'h3E : rcp = 31'h3C842108;    //  rcp_62:  DFF   0.01612903225806451612903225806452
            8'h3F : rcp = 31'h3C820821;    //  rcp_63:  DFF   0.01587301587301587301587301587302
            8'h40 : rcp = 31'h3C800000;    //  rcp_64:  DFF   0.015625
            8'h41 : rcp = 31'h3C7C0FC1;    //  rcp_65:  DFF   0.01538461538461538461538461538462
            8'h42 : rcp = 31'h3C783E10;    //  rcp_66:  DFF   0.01515151515151515151515151515152
            8'h43 : rcp = 31'h3C74898D;    //  rcp_67:  DFF   0.0149253731343283582089552238806
            8'h44 : rcp = 31'h3C70F0F1;    //  rcp_68:  DFF   0.01470588235294117647058823529412
            8'h45 : rcp = 31'h3C6D7304;    //  rcp_69:  DFF   0.01449275362318840579710144927536
            8'h46 : rcp = 31'h3C6A0EA1;    //  rcp_70:  DFF   0.01428571428571428571428571428571
            8'h47 : rcp = 31'h3C66C2B4;    //  rcp_71:  DFF   0.01408450704225352112676056338028
            8'h48 : rcp = 31'h3C638E39;    //  rcp_72:  DFF   0.01388888888888888888888888888889
            8'h49 : rcp = 31'h3C607038;    //  rcp_73:  DFF   0.01369863013698630136986301369863
            8'h4A : rcp = 31'h3C5D67C9;    //  rcp_74:  DFF   0.01351351351351351351351351351351
            8'h4B : rcp = 31'h3C5A740E;    //  rcp_75:  DFF   0.01333333333333333333333333333333
            8'h4C : rcp = 31'h3C579436;    //  rcp_76:  DFF   0.01315789473684210526315789473684
            8'h4D : rcp = 31'h3C54C77B;    //  rcp_77:  DFF   0.01298701298701298701298701298701
            8'h4E : rcp = 31'h3C520D21;    //  rcp_78:  DFF   0.01282051282051282051282051282051
            8'h4F : rcp = 31'h3C4F6475;    //  rcp_79:  DFF   0.01265822784810126582278481012658
            8'h50 : rcp = 31'h3C4CCCCD;    //  rcp_80:  DFF   0.0125
            8'h51 : rcp = 31'h3C4A4588;    //  rcp_81:  DFF   0.01234567901234567901234567901235
            8'h52 : rcp = 31'h3C47CE0C;    //  rcp_82:  DFF   0.01219512195121951219512195121951
            8'h53 : rcp = 31'h3C4565C8;    //  rcp_83:  DFF   0.01204819277108433734939759036145
            8'h54 : rcp = 31'h3C430C31;    //  rcp_84:  DFF   0.01190476190476190476190476190476
            8'h55 : rcp = 31'h3C40C0C1;    //  rcp_85:  DFF   0.01176470588235294117647058823529
            8'h56 : rcp = 31'h3C3E82FA;    //  rcp_86:  DFF   0.01162790697674418604651162790698
            8'h57 : rcp = 31'h3C3C5264;    //  rcp_87:  DFF   0.01149425287356321839080459770115
            8'h58 : rcp = 31'h3C3A2E8C;    //  rcp_88:  DFF   0.01136363636363636363636363636364
            8'h59 : rcp = 31'h3C381703;    //  rcp_89:  DFF   0.01123595505617977528089887640449
            8'h5A : rcp = 31'h3C360B61;    //  rcp_90:  DFF   0.01111111111111111111111111111111
            8'h5B : rcp = 31'h3C340B41;    //  rcp_91:  DFF   0.01098901098901098901098901098901
            8'h5C : rcp = 31'h3C321643;    //  rcp_92:  DFF   0.01086956521739130434782608695652
            8'h5D : rcp = 31'h3C302C0B;    //  rcp_93:  DFF   0.01075268817204301075268817204301
            8'h5E : rcp = 31'h3C2E4C41;    //  rcp_94:  DFF   0.01063829787234042553191489361702
            8'h5F : rcp = 31'h3C2C7692;    //  rcp_95:  DFF   0.01052631578947368421052631578947
            8'h60 : rcp = 31'h3C2AAAAB;    //  rcp_96:  DFF   0.01041666666666666666666666666667
            8'h61 : rcp = 31'h3C28E83F;    //  rcp_97:  DFF   0.01030927835051546391752577319588
            8'h62 : rcp = 31'h3C272F05;    //  rcp_98:  DFF   0.01020408163265306122448979591837
            8'h63 : rcp = 31'h3C257EB5;    //  rcp_99:  DFF   0.01010101010101010101010101010101
            8'h64 : rcp = 31'h3C23D70A;    //  rcp_100: DFF   0.01 
            8'h65 : rcp = 31'h3C2237C3;    //  rcp_101: DFF   0.00990099009900990099009900990099 
            8'h66 : rcp = 31'h3C20A0A1;    //  rcp_102: DFF   0.00980392156862745098039215686275 
            8'h67 : rcp = 31'h3C1F1166;    //  rcp_103: DFF   0.00970873786407766990291262135922 
            8'h68 : rcp = 31'h3C1D89D9;    //  rcp_104: DFF   0.00961538461538461538461538461538 
            8'h69 : rcp = 31'h3C1C09C1;    //  rcp_105: DFF   0.00952380952380952380952380952381 
            8'h6A : rcp = 31'h3C1A90E8;    //  rcp_106: DFF   0.00943396226415094339622641509434 
            8'h6B : rcp = 31'h3C191F1A;    //  rcp_107: DFF   0.00934579439252336448598130841121 
            8'h6C : rcp = 31'h3C17B426;    //  rcp_108: DFF   0.00925925925925925925925925925926 
            8'h6D : rcp = 31'h3C164FDA;    //  rcp_109: DFF   0.00917431192660550458715596330275 
            8'h6E : rcp = 31'h3C14F209;    //  rcp_110: DFF   0.00909090909090909090909090909091 
            8'h6F : rcp = 31'h3C139A86;    //  rcp_111: DFF   0.00900900900900900900900900900901 
            8'h70 : rcp = 31'h3C124925;    //  rcp_112: DFF   0.00892857142857142857142857142857 
            8'h71 : rcp = 31'h3C10FDBC;    //  rcp_113: DFF   0.00884955752212389380530973451327 
            8'h72 : rcp = 31'h3C0FB824;    //  rcp_114: DFF   0.00877192982456140350877192982456 
            8'h73 : rcp = 31'h3C0E7835;    //  rcp_115: DFF   0.00869565217391304347826086956522 
            8'h74 : rcp = 31'h3C0D3DCB;    //  rcp_116: DFF   0.00862068965517241379310344827586 
            8'h75 : rcp = 31'h3C0C08C1;    //  rcp_117: DFF   0.00854700854700854700854700854701 
            8'h76 : rcp = 31'h3C0AD8F3;    //  rcp_118: DFF   0.00847457627118644067796610169492 
            8'h77 : rcp = 31'h3C09AE41;    //  rcp_119: DFF   0.00840336134453781512605042016807 
            8'h78 : rcp = 31'h3C088889;    //  rcp_120: DFF   0.00833333333333333333333333333333 
            8'h79 : rcp = 31'h3C0767AB;    //  rcp_121: DFF   0.00826446280991735537190082644628 
            8'h7A : rcp = 31'h3C064B8A;    //  rcp_122: DFF   0.00819672131147540983606557377049 
            8'h7B : rcp = 31'h3C053408;    //  rcp_123: DFF   0.00813008130081300813008130081301 
            8'h7C : rcp = 31'h3C042108;    //  rcp_124: DFF   0.00806451612903225806451612903226 
            8'h7D : rcp = 31'h3C03126F;    //  rcp_125: DFF   0.008 
            8'h7E : rcp = 31'h3C020821;    //  rcp_126: DFF   0.00793650793650793650793650793651 
            8'h7F : rcp = 31'h3C010204;    //  rcp_127: DFF   0.00787401574803149606299212598425
            8'h80 : rcp = 31'h3C000000;    //  rcp_128: DFF   0.0078125 00000000
          default : rcp = 31'h00000000;  
        endcase 
    else rcp = 31'h00000000;
end                      
endmodule              
                       