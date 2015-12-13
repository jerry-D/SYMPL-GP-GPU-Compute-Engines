`timescale 1ns/100ps 
// trigd.v      32-bit floating-point, single-precision, trig tables for "degrees", resolution 1 degree out of 360
// input is 10-bit signed integer, output is 32-bit float
// For use in SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine
// Version 1.13  Dec. 12, 2015
// Author:  Jerry D. Harthcock
// Copyright (C) 2014-2015.  All rights reserved without prejudice.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                   SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine                           //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of the SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-  //
// Compute Engine Verilog RTL IP core family and instruction-set architecture ("this IP"), hereby grants to      //
// recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive license to use this IP for the        //
// non-commercial purposes of evaluation, education, and development of end products and related development     //
// tools only. For a license to use this IP in commercial products intended for sale, license, lease or any      //
// other form of barter, contact licensor at:  SYMPL.gpu@gmail.com                                               //
//                                                                                                               //
// Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
// and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
// binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
// netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
// any copyright notices from any source file covered under this Evaluation and Product Development License.     //
//                                                                                                               //
// THIS IP IS PROVIDED "AS IS".  LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT        //
// INFRINGE THE RIGHTS OF OTHERS OR THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE //
// TO HOLD LICENSOR HARMLESS FROM ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                 //                               
//                                                                                                               //
// Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
// or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
// of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
// in this Evaluation and Product Development License.                                                           //
//                                                                                                               //
// This Evaluation and Product Development License does not include the right to sell products that incorporate  //
// this IP or any IP derived from this IP.  If you would like to obtain such a license, please contact Licensor. //                                                                                            //
//                                                                                                               //
// Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
module trigd(
    opcode_q2,
    x,
    sin,
    cos,
    tan,
    cot);
    
input [3:0] opcode_q2;
input [9:0] x; 
output [31:0] sin, cos, tan, cot;

parameter   SIN_    = 4'b1100;
parameter   COS_    = 4'b1101;
parameter   TAN_    = 4'b1110;
parameter   COT_    = 4'b1111;

//     sine           
parameter sin_0deg  =  32'h00000000;  //  sin_0deg:   DFF   0.0
parameter sin_1deg  =  31'h3C8EF859;  //  sin_1deg:   DFF   0.01745240643728351281941897851632
parameter sin_2deg  =  31'h3D0EF2C6;  //  sin_2deg:   DFF   0.03489949670250097164599518162533
parameter sin_3deg  =  31'h3D565E3A;  //  sin_3deg:   DFF   0.05233595624294383272211862960908
parameter sin_4deg  =  31'h3D8EDC7B;  //  sin_4deg:   DFF   0.06975647374412530077595883519414
parameter sin_5deg  =  31'h3DB27EB6;  //  sin_5deg:   DFF   0.08715574274765817355806427083747
parameter sin_6deg  =  31'h3DD61305;  //  sin_6deg:   DFF   0.1045284632676534713998341548025
parameter sin_7deg  =  31'h3DF996A2;  //  sin_7deg:   DFF   0.12186934340514748111289391923153
parameter sin_8deg  =  31'h3E0E8365;  //  sin_8deg:   DFF   0.13917310096006544411249666330111
parameter sin_9deg  =  31'h3E20305B;  //  sin_9deg:   DFF   0.15643446504023086901010531946717
parameter sin_10deg =  31'h3E31D0D4;  //  sin_10deg:  DFF   0.17364817766693034885171662676931
parameter sin_11deg =  31'h3E43636F;  //  sin_11deg:  DFF   0.19080899537654481240514048795839
parameter sin_12deg =  31'h3E54E6CD;  //  sin_12deg:  DFF   0.20791169081775933710174228440513
parameter sin_13deg =  31'h3E665992;  //  sin_13deg:  DFF   0.2249510543438649980511072083428
parameter sin_14deg =  31'h3E77BA60;  //  sin_14deg:  DFF   0.24192189559966772256044237410035
parameter sin_15deg =  31'h3E8483EE;  //  sin_15deg:  DFF   0.25881904510252076234889883762405
parameter sin_16deg =  31'h3E8D2057;  //  sin_16deg:  DFF   0.2756373558169991856499715746113
parameter sin_17deg =  31'h3E95B1BE;  //  sin_17deg:  DFF   0.29237170472273672809746869537714
parameter sin_18deg =  31'h3E9E377A;  //  sin_18deg:  DFF   0.30901699437494742410229341718282
parameter sin_19deg =  31'h3EA6B0DF;  //  sin_19deg:  DFF   0.32556815445715666871400893579472
parameter sin_20deg =  31'h3EAF1D44;  //  sin_20deg:  DFF   0.34202014332566873304409961468226
parameter sin_21deg =  31'h3EB77C01;  //  sin_21deg:  DFF   0.35836794954530027348413778941347
parameter sin_22deg =  31'h3EBFCC6F;  //  sin_22deg:  DFF   0.3746065934159120354149637745012
parameter sin_23deg =  31'h3EC80DE9;  //  sin_23deg:  DFF   0.39073112848927375506208458888909
parameter sin_24deg =  31'h3ED03FC9;  //  sin_24deg:  DFF   0.4067366430758002077539859903415
parameter sin_25deg =  31'h3ED8616C;  //  sin_25deg:  DFF   0.42261826174069943618697848964773
parameter sin_26deg =  31'h3EE0722F;  //  sin_26deg:  DFF   0.43837114678907741745273454065827
parameter sin_27deg =  31'h3EE87171;  //  sin_27deg:  DFF   0.45399049973954679156040836635787
parameter sin_28deg =  31'h3EF05E94;  //  sin_28deg:  DFF   0.46947156278589077595946228822784
parameter sin_29deg =  31'h3EF838F7;  //  sin_29deg:  DFF   0.48480962024633702907537962241578
parameter sin_30deg =  31'h3F000000;  //  sin_30deg:  DFF   0.5
parameter sin_31deg =  31'h3F03D989;  //  sin_31deg:  DFF   0.51503807491005421008163193639814
parameter sin_32deg =  31'h3F07A8CA;  //  sin_32deg:  DFF   0.52991926423320495404678115181609
parameter sin_33deg =  31'h3F0B6D77;  //  sin_33deg:  DFF   0.54463903501502708222408369208157
parameter sin_34deg =  31'h3F0F2744;  //  sin_34deg:  DFF   0.55919290347074683016042813998599
parameter sin_35deg =  31'h3F12D5E8;  //  sin_35deg:  DFF   0.57357643635104609610803191282616
parameter sin_36deg =  31'h3F167918;  //  sin_36deg:  DFF   0.58778525229247312916870595463907
parameter sin_37deg =  31'h3F1A108D;  //  sin_37deg:  DFF   0.60181502315204827991797700044149
parameter sin_38deg =  31'h3F1D9BFE;  //  sin_38deg:  DFF   0.61566147532565827966881109284366
parameter sin_39deg =  31'h3F211B24;  //  sin_39deg:  DFF   0.62932039104983745270590245827997
parameter sin_40deg =  31'h3F248DBB;  //  sin_40deg:  DFF   0.64278760968653932632264340990726
parameter sin_41deg =  31'h3F27F37C;  //  sin_41deg:  DFF   0.65605902899050728478249596402342
parameter sin_42deg =  31'h3F2B4C25;  //  sin_42deg:  DFF   0.66913060635885821382627333068678
parameter sin_43deg =  31'h3F2E9772;  //  sin_43deg:  DFF   0.68199836006249850044222578471113
parameter sin_44deg =  31'h3F31D522;  //  sin_44deg:  DFF   0.69465837045899728665640629942269
parameter sin_45deg =  31'h3F3504F3;  //  sin_45deg:  DFF   0.70710678118654752440084436210485
parameter sin_46deg =  31'h3F3826A7;  //  sin_46deg:  DFF   0.71933980033865113935605467445671
parameter sin_47deg =  31'h3F3B39FF;  //  sin_47deg:  DFF   0.73135370161917048328754360827562
parameter sin_48deg =  31'h3F3E3EBD;  //  sin_48deg:  DFF   0.74314482547739423501469704897426
parameter sin_49deg =  31'h3F4134A6;  //  sin_49deg:  DFF   0.75470958022277199794298421956102
parameter sin_50deg =  31'h3F441B7D;  //  sin_50deg:  DFF   0.76604444311897803520239265055542
parameter sin_51deg =  31'h3F46F30A;  //  sin_51deg:  DFF   0.7771459614569708799799377436724
parameter sin_52deg =  31'h3F49BB13;  //  sin_52deg:  DFF   0.78801075360672195669397778783585
parameter sin_53deg =  31'h3F4C7360;  //  sin_53deg:  DFF   0.79863551004729284628400080406894
parameter sin_54deg =  31'h3F4F1BBD;  //  sin_54deg:  DFF   0.80901699437494742410229341718282
parameter sin_55deg =  31'h3F51B3F3;  //  sin_55deg:  DFF   0.81915204428899178968448838591684
parameter sin_56deg =  31'h3F543BCE;  //  sin_56deg:  DFF   0.82903757255504169200633684150164
parameter sin_57deg =  31'h3F56B31D;  //  sin_57deg:  DFF   0.83867056794542402963759094180455
parameter sin_58deg =  31'h3F5919AE;  //  sin_58deg:  DFF   0.84804809615642597038617617869039
parameter sin_59deg =  31'h3F5B6F51;  //  sin_59deg:  DFF   0.85716730070211228746521798014476
parameter sin_60deg =  31'h3F5DB3D7;  //  sin_60deg:  DFF   0.86602540378443864676372317075294
parameter sin_61deg =  31'h3F5FE714;  //  sin_61deg:  DFF   0.87461970713939580028463695866108
parameter sin_62deg =  31'h3F6208DA;  //  sin_62deg:  DFF   0.88294759285892694203217136031572
parameter sin_63deg =  31'h3F641901;  //  sin_63deg:  DFF   0.89100652418836786235970957141363
parameter sin_64deg =  31'h3F66175E;  //  sin_64deg:  DFF   0.89879404629916699278229567669579
parameter sin_65deg =  31'h3F6803CA;  //  sin_65deg:  DFF   0.90630778703664996324255265675432
parameter sin_66deg =  31'h3F69DE1D;  //  sin_66deg:  DFF   0.91354545764260089550212757198532
parameter sin_67deg =  31'h3F6BA635;  //  sin_67deg:  DFF   0.92050485345244032739689472330046
parameter sin_68deg =  31'h3F6D5BEC;  //  sin_68deg:  DFF   0.92718385456678740080647445113696          
parameter sin_69deg =  31'h3F6EFF20;  //  sin_69deg:  DFF   0.93358042649720174899004306313957
parameter sin_70deg =  31'h3F708FB2;  //  sin_70deg:  DFF   0.93969262078590838405410927732473
parameter sin_71deg =  31'h3F720D81;  //  sin_71deg:  DFF   0.9455185755993168103481247075194
parameter sin_72deg =  31'h3F737871;  //  sin_72deg:  DFF   0.95105651629515357211643933337938
parameter sin_73deg =  31'h3F74D063;  //  sin_73deg:  DFF   0.95630475596303548133865081661842
parameter sin_74deg =  31'h3F76153F;  //  sin_74deg:  DFF   0.96126169593831886191649704855706
parameter sin_75deg =  31'h3F7746EA;  //  sin_75deg:  DFF   0.9659258262890682867497431997289
parameter sin_76deg =  31'h3F78654D;  //  sin_76deg:  DFF   0.97029572627599647230637787403399
parameter sin_77deg =  31'h3F797051;  //  sin_77deg:  DFF   0.97437006478523522853969448008827
parameter sin_78deg =  31'h3F7A67E2;  //  sin_78deg:  DFF   0.9781476007338056379285667478696
parameter sin_79deg =  31'h3F7B4BEB;  //  sin_79deg:  DFF   0.98162718344766395349650489981814
parameter sin_80deg =  31'h3F7C1C5C;  //  sin_80deg:  DFF   0.98480775301220805936674302458952
parameter sin_81deg =  31'h3F7CD925;  //  sin_81deg:  DFF   0.98768834059513772619004024769344
parameter sin_82deg =  31'h3F7D8235;  //  sin_82deg:  DFF   0.99026806874157031508377486734485
parameter sin_83deg =  31'h3F7E1781;  //  sin_83deg:  DFF   0.99254615164132203498006158933058
parameter sin_84deg =  31'h3F7E98FD;  //  sin_84deg:  DFF   0.99452189536827333692269194498057
parameter sin_85deg =  31'h3F7F069E;  //  sin_85deg:  DFF   0.99619469809174553229501040247389
parameter sin_86deg =  31'h3F7F605C;  //  sin_86deg:  DFF   0.99756405025982424761316268064426
parameter sin_87deg =  31'h3F7FA62F;  //  sin_87deg:  DFF   0.99862953475457387378449205843944
parameter sin_88deg =  31'h3F7FD814;  //  sin_88deg:  DFF   0.99939082701909573000624344004393
parameter sin_89deg =  31'h3F7FF605;  //  sin_89deg:  DFF   0.99984769515639123915701155881391
parameter sin_90deg =  31'h3F800000;  //  sin_90deg:  DFF   1.0
                                      //
// tangent                            //
parameter tan_0deg  =  32'h00000000;  //  tan_0deg:   DFF   0.0                                   
parameter tan_1deg  =  31'h3C8EFDED;  //  tan_1deg:   DFF   0.01745506492821758576512889521973    
parameter tan_2deg  =  31'h3D0F0915;  //  tan_2deg:   DFF   0.03492076949174773050040262577373    
parameter tan_3deg  =  31'h3D56A98A;  //  tan_3deg:   DFF   0.05240777928304120403880582447398    
parameter tan_4deg  =  31'h3D8F35CA;  //  tan_4deg:   DFF   0.06992681194351041366692106032318    
parameter tan_5deg  =  31'h3DB32D42;  //  tan_5deg:   DFF   0.08748866352592400522201866943496    
parameter tan_6deg  =  31'h3DD740E4;  //  tan_6deg:   DFF   0.10510423526567646251150238013988     
parameter tan_7deg  =  31'h3DFB7679;  //  tan_7deg:   DFF   0.12278456090290459113423113605286    
parameter tan_8deg  =  31'h3E0FE9F0;  //  tan_8deg:   DFF   0.14054083470239144683811769343281    
parameter tan_9deg  =  31'h3E222F88;  //  tan_9deg:   DFF   0.15838444032453629383888309269437    
parameter tan_10deg =  31'h3E348F0F;  //  tan_10deg:  DFF   0.17632698070846497347109038686862    
parameter tan_11deg =  31'h3E470BA2;  //  tan_11deg:  DFF   0.19438030913771848424319422497682    
parameter tan_12deg =  31'h3E59A86D;  //  tan_12deg:  DFF   0.21255656167002212525959166057008    
parameter tan_13deg =  31'h3E6C68B6;  //  tan_13deg:  DFF   0.23086819112556311174814561347445     
parameter tan_14deg =  31'h3E7F4FD7;  //  tan_14deg:  DFF   0.24932800284318069162403993780486    
parameter tan_15deg =  31'h3E8930A3;  //  tan_15deg:  DFF   0.26794919243112270647255365849413    
parameter tan_16deg =  31'h3E92D04B;  //  tan_16deg:  DFF   0.28674538575880794004275806273267     
parameter tan_17deg =  31'h3E9C88BB;  //  tan_17deg:  DFF   0.30573068145866035573454195899655    
parameter tan_18deg =  31'h3EA65BE0;  //  tan_18deg:  DFF   0.32491969623290632615587141221513    
parameter tan_19deg =  31'h3EB04BB5;  //  tan_19deg:  DFF   0.34432761328966524195726583938311    
parameter tan_20deg =  31'h3EBA5A4E;  //  tan_20deg:  DFF   0.36397023426620236135104788277683    
parameter tan_21deg =  31'h3EC489D4;  //  tan_21deg:  DFF   0.38386403503541579597144840810327    
parameter tan_22deg =  31'h3ECEDC87;  //  tan_22deg:  DFF   0.40402622583515681132234814357991     
parameter tan_23deg =  31'h3ED954C3;  //  tan_23deg:  DFF   0.42447481620960474202353206294252    
parameter tan_24deg =  31'h3EE3F504;  //  tan_24deg:  DFF   0.44522868530853616392236703064567     
parameter tan_25deg =  31'h3EEEBFE1;  //  tan_25deg:  DFF   0.46630765815499859283000619479956    
parameter tan_26deg =  31'h3EF9B816;  //  tan_26deg:  DFF   0.48773258856586142277311112661696    
parameter tan_27deg =  31'h3F027043;  //  tan_27deg:  DFF   0.50952544949442881051370691125066    
parameter tan_28deg =  31'h3F081E1C;  //  tan_28deg:  DFF   0.53170943166147874807591587184006    
parameter tan_29deg =  31'h3F0DE733;  //  tan_29deg:  DFF   0.55430905145276891782076309233813    
parameter tan_30deg =  31'h3F13CD3A;  //  tan_30deg:  DFF   0.57735026918962576450914878050196                                   
parameter tan_31deg =  31'h3F19D200;  //  tan_31deg:  DFF   0.60086061902756041487866442635466    
parameter tan_32deg =  31'h3F1FF770;  //  tan_32deg:  DFF   0.62486935190932750978051082794944    
parameter tan_33deg =  31'h3F263F93;  //  tan_33deg:  DFF   0.64940759319751057698206291131145    
parameter tan_34deg =  31'h3F2CAC97;  //  tan_34deg:  DFF   0.67450851684242663214246086199461    
parameter tan_35deg =  31'h3F3340CD;  //  tan_35deg:  DFF   0.70020753820970977945852271944483    
parameter tan_36deg =  31'h3F39FEB1;  //  tan_36deg:  DFF   0.72654252800536088589546675748062    
parameter tan_37deg =  31'h3F40E8EB;  //  tan_37deg:  DFF   0.75355405010279415707395644862159    
parameter tan_38deg =  31'h3F480256;  //  tan_38deg:  DFF   0.78128562650671739706294997196227    
parameter tan_39deg =  31'h3F4F4E02;  //  tan_39deg:  DFF   0.80978403319500714803699137423577    
parameter tan_40deg =  31'h3F56CF3C;  //  tan_40deg:  DFF   0.83909963117728001176312729812318    
parameter tan_41deg =  31'h3F5E8993;  //  tan_41deg:  DFF   0.86928673781622666220009563870394    
parameter tan_42deg =  31'h3F6680E1;  //  tan_42deg:  DFF   0.90040404429783994512047720388537    
parameter tan_43deg =  31'h3F6EB94F;  //  tan_43deg:  DFF   0.93251508613766170561218562742619    
parameter tan_44deg =  31'h3F773761;  //  tan_44deg:  DFF   0.96568877480707404595802729970068    
parameter tan_45deg =  31'h3F800000;  //  tan_45deg:  DFF   1.0                                      
parameter tan_46deg =  31'h3F848C42;  //  tan_46deg:  DFF   1.0355303137905695069588325512481
parameter tan_47deg =  31'h3F894361;  //  tan_47deg:  DFF   1.0723687100246825329460277480726
parameter tan_48deg =  31'h3F8E288D;  //  tan_48deg:  DFF   1.1106125148291928701434819641651
parameter tan_49deg =  31'h3F933F46;  //  tan_49deg:  DFF   1.1503684072210095558763310255696
parameter tan_50deg =  31'h3F988B62;  //  tan_50deg:  DFF   1.1917535925942099587053080718604
parameter tan_51deg =  31'h3F9E111C;  //  tan_51deg:  DFF   1.2348971565350513985561746953759
parameter tan_52deg =  31'h3FA3D521;  //  tan_52deg:  DFF   1.279941632193078780311029847572
parameter tan_53deg =  31'h3FA9DC9B;  //  tan_53deg:  DFF   1.3270448216204100371594725740869
parameter tan_54deg =  31'h3FB02D48;  //  tan_54deg:  DFF   1.3763819204711735382072095819109
parameter tan_55deg =  31'h3FB6CD8E;  //  tan_55deg:  DFF   1.4281480067421145021606184849985
parameter tan_56deg =  31'h3FBDC48F;  //  tan_56deg:  DFF   1.4825609685127402547871571491544
parameter tan_57deg =  31'h3FC51A4C;  //  tan_57deg:  DFF   1.5398649638145829048267969726028
parameter tan_58deg =  31'h3FCCD7C3;  //  tan_58deg:  DFF   1.6003345290410503553267330811834
parameter tan_59deg =  31'h3FD5071C;  //  tan_59deg:  DFF   1.6642794823505179110304961700348
parameter tan_60deg =  31'h3FDDB3D7;  //  tan_60deg:  DFF   1.7320508075688772935274463415059
parameter tan_61deg =  31'h3FE6EB09;  //  tan_61deg:  DFF   1.804047755271423937381784748237
parameter tan_62deg =  31'h3FF0BBA5;  //  tan_62deg:  DFF   1.8807264653463320123608375958293
parameter tan_63deg =  31'h3FFB36D2;  //  tan_63deg:  DFF   1.9626105055051505823046404262119
parameter tan_64deg =  31'h4003382E;  //  tan_64deg:  DFF   2.0503038415792962168990110705415
parameter tan_65deg =  31'h40093F9A;  //  tan_65deg:  DFF   2.1445069205095586163562607910459
parameter tan_66deg =  31'h400FBF11;  //  tan_66deg:  DFF   2.2460367739042160541633214384164
parameter tan_67deg =  31'h4016C649;  //  tan_67deg:  DFF   2.3558523658237528339395866623439
parameter tan_68deg =  31'h401E67D3;  //  tan_68deg:  DFF   2.4750868534162958252400132460762
parameter tan_69deg =  31'h4026B9C7;  //  tan_69deg:  DFF   2.6050890646938015362584123364335
parameter tan_70deg =  31'h402FD6AC;  //  tan_70deg:  DFF   2.7474774194546222787616640264977
parameter tan_71deg =  31'h4039DE97;  //  tan_71deg:  DFF   2.9042108776758228025793255345271
parameter tan_72deg =  31'h4044F8C4;  //  tan_72deg:  DFF   3.0776835371752534025702905760369
parameter tan_73deg =  31'h405155A6;  //  tan_73deg:  DFF   3.2708526184841408653088562573054
parameter tan_74deg =  31'h405F31CC;  //  tan_74deg:  DFF   3.4874144438409086506962242250994
parameter tan_75deg =  31'h406ED9EC;  //  tan_75deg:  DFF   3.7320508075688772935274463415059
parameter tan_76deg =  31'h40805851;  //  tan_76deg:  DFF   4.0107809335358447163457151294634
parameter tan_77deg =  31'h408A9B73;  //  tan_77deg:  DFF   4.3314758742841555455461677545574
parameter tan_78deg =  31'h40968C54;  //  tan_78deg:  DFF   4.7046301094784542335862345374029
parameter tan_79deg =  31'h40A4A030;  //  tan_79deg:  DFF   5.1445540159703101347232207171292
parameter tan_80deg =  31'h40B57B24;  //  tan_80deg:  DFF   5.671281819617709530994418439864
parameter tan_81deg =  31'h40CA0A41;  //  tan_81deg:  DFF   6.3137515146750430989794642447682
parameter tan_82deg =  31'h40E3B11C;  //  tan_82deg:  DFF   7.1153697223842087482305661436316
parameter tan_83deg =  31'h41024F3E;  //  tan_83deg:  DFF   8.1443464279745940238256613949797
parameter tan_84deg =  31'h41183AD6;  //  tan_84deg:  DFF   9.5143644542225849296839714549457
parameter tan_85deg =  31'h4136E17F;  //  tan_85deg:  DFF   11.430052302761343067210855549163
parameter tan_86deg =  31'h4164CF87;  //  tan_86deg:  DFF   14.300666256711927910128053347586
parameter tan_87deg =  31'h4198A62B;  //  tan_87deg:  DFF   19.081136687728211063406748734365
parameter tan_88deg =  31'h41E5170C;  //  tan_88deg:  DFF   28.636253282915603550756509320946
parameter tan_89deg =  31'h426528EC;  //  tan_89deg:  DFF   57.289961630759424687278147537113
parameter tan_90deg =  31'h7F7FFFEE;  //  tan_90deg:  DFF   3.40282e38

reg [31:0] sin;
reg [31:0] cos;
reg [31:0] tan;
reg [31:0] cot;
reg enable;
reg coenable;
 
wire sign; 
wire cosign; 
wire [9:0] x;
wire [9:0] absltx;
wire [9:0] mod180;
wire [8:0] deg;
wire [8:0] codeg;
wire [9:0] cox;
wire [9:0] comod180;
wire [9:0] absltcox;

// for sin and tan
assign absltx = x[9] ? (10'h000 - x) : x;           //get absolute value of input x
assign mod180 = 10'd180 - absltx;                   //confine it to modulus 180
assign sign = x[9] ^ mod180[9];                     //determine sign
assign deg = absltx[8:0];                           //truncate sign position

// for cos and cot
assign cox =  x - 10'd090;                          //adjust for -90deg phase shift
assign absltcox = cox[9] ? (10'h000 - cox) : cox;   //get absolute value of cox
assign comod180 = 10'd180 - absltcox;               //confine it to modulus 180
assign cosign = ~(cox[9] ^ comod180[9]);               //determine sign
assign codeg = absltcox[8:0];                       //truncate sign position


always @(opcode_q2) begin
        if ((opcode_q2 == SIN_) || (opcode_q2 == TAN_)) enable <= 1'b1;
        else enable <= 1'b0;
        if ((opcode_q2 == COS_) || (opcode_q2 == COT_)) coenable <= 1'b1;
        else coenable <= 1'b0;
end    
 
always @(*) begin
    if (enable) 
        case (deg) 
             9'h000,
             9'h0B4,
             9'h168 : begin
                        sin = sin_0deg;                
                        tan = tan_0deg;                
                      end  
             
             9'h001,
             9'h0B3,
             9'h0B5,
             9'h167 : begin
                        sin = {sign, sin_1deg};        
                        tan = {sign, tan_1deg};        
                      end  
             
             9'h002,
             9'h0B2,
             9'h0B6,
             9'h166 : begin
                        sin = {sign, sin_2deg};        
                        tan = {sign, tan_2deg};        
                      end  

             9'h003,
             9'h0B1,
             9'h0B7,
             9'h165 : begin
                        sin = {sign, sin_3deg};        
                        tan = {sign, tan_3deg};        
                      end  

             9'h004,
             9'h0B0,
             9'h0B8,
             9'h164 : begin
                        sin = {sign, sin_4deg};        
                        tan = {sign, tan_4deg};        
                      end  

             9'h005,
             9'h0AF,
             9'h0B9,
             9'h163 : begin
                        sin = {sign, sin_5deg};        
                        tan = {sign, tan_5deg};        
                      end  

             9'h006,
             9'h0AE,
             9'h0BA,
             9'h162 : begin
                        sin = {sign, sin_6deg};        
                        tan = {sign, tan_6deg};        
                      end  

             9'h007,
             9'h0AD,
             9'h0BB,
             9'h161 : begin
                        sin = {sign, sin_7deg};        
                        tan = {sign, tan_7deg};        
                      end  

             9'h008,
             9'h0AC,
             9'h0BC,
             9'h160 : begin
                        sin = {sign, sin_8deg};        
                        tan = {sign, tan_8deg};        
                      end  

             9'h009,
             9'h0AB,
             9'h0BD,
             9'h15F : begin
                        sin = {sign, sin_9deg};        
                        tan = {sign, tan_9deg};        
                      end  

             9'h00A,
             9'h0AA,
             9'h0BE,
             9'h15E : begin
                        sin = {sign, sin_10deg};       
                        tan = {sign, tan_10deg};       
                      end  

             9'h00B,
             9'h0A9,
             9'h0BF,
             9'h15D : begin
                        sin = {sign, sin_11deg};       
                        tan = {sign, tan_11deg};       
                      end  

             9'h00C,
             9'h0A8,
             9'h0C0,
             9'h15C : begin
                        sin = {sign, sin_12deg};       
                        tan = {sign, tan_12deg};       
                      end  

             9'h00D,
             9'h0A7,
             9'h0C1,
             9'h15B : begin
                        sin = {sign, sin_13deg};       
                        tan = {sign, tan_13deg};       
                      end  

             9'h00E,
             9'h0A6,
             9'h0C2,
             9'h15A : begin
                        sin = {sign, sin_14deg};       
                        tan = {sign, tan_14deg};       
                      end  

             9'h00F,
             9'h0A5,
             9'h0C3,
             9'h159 : begin
                        sin = {sign, sin_15deg};       
                        tan = {sign, tan_15deg};       
                      end  

             9'h010,
             9'h0A4,
             9'h0C4,
             9'h158 : begin
                        sin = {sign, sin_16deg};       
                        tan = {sign, tan_16deg};       
                      end  

             9'h011,
             9'h0A3,
             9'h0C5,
             9'h157 : begin
                        sin = {sign, sin_17deg};       
                        tan = {sign, tan_17deg};       
                      end  

             9'h012,
             9'h0A2,
             9'h0C6,
             9'h156 : begin
                        sin = {sign, sin_18deg};       
                        tan = {sign, tan_18deg};       
                      end  

             9'h013,
             9'h0A1,
             9'h0C7,
             9'h155 : begin
                        sin = {sign, sin_19deg};       
                        tan = {sign, tan_19deg};       
                      end  

             9'h014,
             9'h0A0,
             9'h0C8,
             9'h154 : begin
                        sin = {sign, sin_20deg};      
                        tan = {sign, tan_20deg};      
                      end  

             9'h015,
             9'h09F,
             9'h0C9,
             9'h153 : begin
                        sin = {sign, sin_21deg};       
                        tan = {sign, tan_21deg}; 
                      end        
             
             9'h016,
             9'h09E,
             9'h0CA,
             9'h152 : begin
                        sin = {sign, sin_22deg};       
                        tan = {sign, tan_22deg};       
                      end  

             9'h017,
             9'h09D,
             9'h0CB,
             9'h151 : begin
                        sin = {sign, sin_23deg};       
                        tan = {sign, tan_23deg};       
                      end  

             9'h018,
             9'h09C,
             9'h0CC,
             9'h150 : begin
                        sin = {sign, sin_24deg};       
                        tan = {sign, tan_24deg};       
                      end  

             9'h019,
             9'h09B,
             9'h0CD,
             9'h14F : begin
                        sin = {sign, sin_25deg};       
                        tan = {sign, tan_25deg};       
                      end  

             9'h01A,
             9'h09A,
             9'h0CE,
             9'h14E : begin
                        sin = {sign, sin_26deg};       
                        tan = {sign, tan_26deg};       
                      end  

             9'h01B,
             9'h099,
             9'h0CF,
             9'h14D : begin
                        sin = {sign, sin_27deg};       
                        tan = {sign, tan_27deg};       
                      end  

             9'h01C,
             9'h098,
             9'h0D0,
             9'h14C : begin
                        sin = {sign, sin_28deg};       
                        tan = {sign, tan_28deg};       
                      end  

             9'h01D,
             9'h097,
             9'h0D1,
             9'h14B : begin
                        sin = {sign, sin_29deg};       
                        tan = {sign, tan_29deg};       
                      end  

             9'h01E,
             9'h096,
             9'h0D2,
             9'h14A : begin
                        sin = {sign, sin_30deg};       
                        tan = {sign, tan_30deg};       
                      end  

             9'h01F,
             9'h095,
             9'h0D3,
             9'h149 : begin
                        sin = {sign, sin_31deg};       
                        tan = {sign, tan_31deg};       
                      end  

             9'h020,
             9'h094,
             9'h0D4,
             9'h148 : begin
                        sin = {sign, sin_32deg};       
                        tan = {sign, tan_32deg};       
                      end  

             9'h021,
             9'h093,
             9'h0D5,
             9'h147 : begin
                        sin = {sign, sin_33deg};       
                        tan = {sign, tan_33deg};       
                      end  

             9'h022,
             9'h092,
             9'h0D6,
             9'h146 : begin
                        sin = {sign, sin_34deg};       
                        tan = {sign, tan_34deg};       
                      end  

             9'h023,
             9'h091,
             9'h0D7,
             9'h145 : begin
                        sin = {sign, sin_35deg};       
                        tan = {sign, tan_35deg};       
                      end  

             9'h024,
             9'h090,
             9'h0D8,
             9'h144 : begin
                        sin = {sign, sin_36deg};       
                        tan = {sign, tan_36deg};       
                      end  

             9'h025,
             9'h08F,
             9'h0D9,
             9'h143 : begin
                        sin = {sign, sin_37deg};       
                        tan = {sign, tan_37deg};       
                      end  

             9'h026,
             9'h08E,
             9'h0DA,
             9'h142 : begin
                        sin = {sign, sin_38deg};       
                        tan = {sign, tan_38deg};       
                      end  

             9'h027,
             9'h08D,
             9'h0DB,
             9'h141 : begin
                        sin = {sign, sin_39deg};       
                        tan = {sign, tan_39deg};       
                      end  

             9'h028,
             9'h08C,
             9'h0DC,
             9'h140 : begin
                        sin = {sign, sin_40deg};       
                        tan = {sign, tan_40deg};       
                      end  

             9'h029,
             9'h08B,
             9'h0DD,
             9'h13F : begin
                        sin = {sign, sin_41deg};       
                        tan = {sign, tan_41deg};       
                      end  

             9'h02A,
             9'h08A,
             9'h0DE,
             9'h13E : begin
                        sin = {sign, sin_42deg};       
                        tan = {sign, tan_42deg};       
                      end  

             9'h02B,
             9'h089,
             9'h0DF,
             9'h13D : begin
                        sin = {sign, sin_43deg};       
                        tan = {sign, tan_43deg};       
                      end  

             9'h02C,
             9'h088,
             9'h0E0,
             9'h13C : begin
                        sin = {sign, sin_44deg};       
                        tan = {sign, tan_44deg};       
                      end  

             9'h02D,
             9'h087,
             9'h0E1,
             9'h13B : begin
                        sin = {sign, sin_45deg};       
                        tan = {sign, tan_45deg};       
                      end  

             9'h02E,
             9'h086,
             9'h0E2,
             9'h13A : begin
                        sin = {sign, sin_46deg};       
                        tan = {sign, tan_46deg};       
                      end  

             9'h02F,
             9'h085,
             9'h0E3,
             9'h139 : begin
                        sin = {sign, sin_47deg};       
                        tan = {sign, tan_47deg};       
                      end  

             9'h030,
             9'h084,
             9'h0E4,
             9'h138 : begin
                        sin = {sign, sin_48deg};       
                        tan = {sign, tan_48deg};       
                      end  

             9'h031,
             9'h083,
             9'h0E5,
             9'h137 : begin
                        sin = {sign, sin_49deg};       
                        tan = {sign, tan_49deg};       
                      end  

             9'h032,
             9'h082,
             9'h0E6,
             9'h136 : begin
                        sin = {sign, sin_50deg};       
                        tan = {sign, tan_50deg};       
                      end  

             9'h033,
             9'h081,
             9'h0E7,
             9'h135 : begin
                        sin = {sign, sin_51deg};       
                        tan = {sign, tan_51deg};       
                      end  

             9'h034,
             9'h080,
             9'h0E8,
             9'h134 : begin
                        sin = {sign, sin_52deg};       
                        tan = {sign, tan_52deg};       
                      end  

             9'h035,
             9'h07F,
             9'h0E9,
             9'h133 : begin
                        sin = {sign, sin_53deg};       
                        tan = {sign, tan_53deg};       
                      end  

             9'h036,
             9'h07E,
             9'h0EA,
             9'h132 : begin
                        sin = {sign, sin_54deg};       
                        tan = {sign, tan_54deg};       
                      end  

             9'h037,
             9'h07D,
             9'h0EB,
             9'h131 : begin
                        sin = {sign, sin_55deg};       
                        tan = {sign, tan_55deg};       
                      end  

             9'h038,
             9'h07C,
             9'h0EC,
             9'h130 : begin
                        sin = {sign, sin_56deg};       
                        tan = {sign, tan_56deg};       
                      end  

             9'h039,
             9'h07B,
             9'h0ED,
             9'h12F : begin
                        sin = {sign, sin_57deg};       
                        tan = {sign, tan_57deg};       
                      end  

             9'h03A,
             9'h07A,
             9'h0EE,
             9'h12E : begin
                        sin = {sign, sin_58deg};       
                        tan = {sign, tan_58deg};       
                      end  

             9'h03B,
             9'h079,
             9'h0EF,
             9'h12D : begin
                        sin = {sign, sin_59deg};       
                        tan = {sign, tan_59deg};       
                      end  

             9'h03C,
             9'h078,
             9'h0F0,
             9'h12C : begin
                        sin = {sign, sin_60deg};       
                        tan = {sign, tan_60deg};       
                      end  

             9'h03D,
             9'h077,
             9'h0F1,
             9'h12B : begin
                        sin = {sign, sin_61deg};       
                        tan = {sign, tan_61deg};       
                      end  

             9'h03E,
             9'h076,
             9'h0F2,
             9'h12A : begin
                        sin = {sign, sin_62deg};       
                        tan = {sign, tan_62deg};       
                      end  

             9'h03F,
             9'h075,
             9'h0F3,
             9'h129 : begin
                        sin = {sign, sin_63deg};       
                        tan = {sign, tan_63deg};       
                      end  

             9'h040,
             9'h074,
             9'h0F4,
             9'h128 : begin
                        sin = {sign, sin_64deg};       
                        tan = {sign, tan_64deg};       
                      end  

             9'h041,
             9'h073,
             9'h0F5,
             9'h127 : begin
                        sin = {sign, sin_65deg};       
                        tan = {sign, tan_65deg};       
                      end  

             9'h042,
             9'h072,
             9'h0F6,
             9'h126 : begin
                        sin = {sign, sin_66deg};       
                        tan = {sign, tan_66deg};       
                      end  

             9'h043,
             9'h071,
             9'h0F7,
             9'h125 : begin
                        sin = {sign, sin_67deg};       
                        tan = {sign, tan_67deg};       
                      end  

             9'h044,
             9'h070,
             9'h0F8,
             9'h124 : begin
                        sin = {sign, sin_68deg};       
                        tan = {sign, tan_68deg};       
                      end  

             9'h045,
             9'h06F,
             9'h0F9,
             9'h123 : begin
                        sin = {sign, sin_69deg};       
                        tan = {sign, tan_69deg};       
                      end  

             9'h046,
             9'h06E,
             9'h0FA,
             9'h122 : begin
                        sin = {sign, sin_70deg};       
                        tan = {sign, tan_70deg};       
                      end  

             9'h047,
             9'h06D,
             9'h0FB,
             9'h121 : begin
                        sin = {sign, sin_71deg};       
                        tan = {sign, tan_71deg};       
                      end  

             9'h048,
             9'h06C,
             9'h0FC,
             9'h120 : begin
                        sin = {sign, sin_72deg};       
                        tan = {sign, tan_72deg};       
                      end  

             9'h049,
             9'h06B,
             9'h0FD,
             9'h11F : begin
                        sin = {sign, sin_73deg};       
                        tan = {sign, tan_73deg};       
                      end  

             9'h04A,
             9'h06A,
             9'h0FE,
             9'h11E : begin
                        sin = {sign, sin_74deg};       
                        tan = {sign, tan_74deg};       
                      end  

             9'h04B,
             9'h069,
             9'h0FF,
             9'h11D : begin
                        sin = {sign, sin_75deg};       
                        tan = {sign, tan_75deg};       
                      end  

             9'h04C,
             9'h068,
             9'h100,
             9'h11C : begin
                        sin = {sign, sin_76deg};       
                        tan = {sign, tan_76deg};       
                      end  

             9'h04D,
             9'h067,
             9'h101,
             9'h11B : begin
                        sin = {sign, sin_77deg};       
                        tan = {sign, tan_77deg};       
                      end  

             9'h04E,
             9'h066,
             9'h102,
             9'h11A : begin
                        sin = {sign, sin_78deg};       
                        tan = {sign, tan_78deg};       
                      end  

             9'h04F,
             9'h065,
             9'h103,
             9'h119 : begin
                        sin = {sign, sin_79deg};       
                        tan = {sign, tan_79deg}; 
                      end        
             
             9'h050,
             9'h064,
             9'h104,
             9'h118 : begin
                        sin = {sign, sin_80deg};       
                        tan = {sign, tan_80deg};       
                      end  

             9'h051,
             9'h063,
             9'h105,
             9'h117 : begin
                        sin = {sign, sin_81deg};       
                        tan = {sign, tan_81deg};       
                      end  

             9'h052,
             9'h062,
             9'h106,
             9'h116 : begin
                        sin = {sign, sin_82deg};       
                        tan = {sign, tan_82deg};       
                      end  

             9'h053,
             9'h061,
             9'h107,
             9'h115 : begin
                        sin = {sign, sin_83deg};       
                        tan = {sign, tan_83deg};       
                      end  

             9'h054,
             9'h060,
             9'h108,
             9'h114 : begin
                        sin = {sign, sin_84deg};       
                        tan = {sign, tan_84deg};       
                      end  

             9'h055,
             9'h05F,
             9'h109,
             9'h113 : begin
                        sin = {sign, sin_85deg};       
                        tan = {sign, tan_85deg};       
                      end  

             9'h056,
             9'h05E,
             9'h10A,
             9'h112 : begin
                        sin = {sign, sin_86deg};       
                        tan = {sign, tan_86deg};       
                      end  

             9'h057,
             9'h05D,
             9'h10B,
             9'h111 : begin
                        sin = {sign, sin_87deg};       
                        tan = {sign, tan_87deg};       
                      end  

             9'h058,
             9'h05C,
             9'h10C,
             9'h110 : begin
                        sin = {sign, sin_88deg};       
                        tan = {sign, tan_88deg};       
                      end  

             9'h059,
             9'h05B,
             9'h10D,
             9'h10F : begin
                        sin = {sign, sin_89deg};       
                        tan = {sign, tan_89deg};       
                      end  

             9'h05A,
             9'h10E : begin
                        sin = {sign, sin_90deg};       
                        tan = {sign, tan_90deg};       
                      end  

            default : begin
                        sin =  32'h00000000;   
                        tan =  32'h00000000;   
                      end  

        endcase 
    else begin
            sin = 32'h00000000; 
            tan = 32'h00000000;       
         end  

end         
 
always @(codeg or coenable or cosign) begin
    if (coenable) 
        case (codeg) 
             9'h000,
             9'h0B4,
             9'h168 : begin
                        cos = sin_0deg;                
                        cot = tan_0deg;                
                      end  
             
             9'h001,
             9'h0B3,
             9'h0B5,
             9'h167 : begin
                        cos = {cosign, sin_1deg};        
                        cot = {cosign, tan_1deg};        
                      end  
             
             9'h002,
             9'h0B2,
             9'h0B6,
             9'h166 : begin
                        cos = {cosign, sin_2deg};        
                        cot = {cosign, tan_2deg};        
                      end  

             9'h003,
             9'h0B1,
             9'h0B7,
             9'h165 : begin
                        cos = {cosign, sin_3deg};        
                        cot = {cosign, tan_3deg};        
                      end  

             9'h004,
             9'h0B0,
             9'h0B8,
             9'h164 : begin
                        cos = {cosign, sin_4deg};        
                        cot = {cosign, tan_4deg};        
                      end  

             9'h005,
             9'h0AF,
             9'h0B9,
             9'h163 : begin
                        cos = {cosign, sin_5deg};        
                        cot = {cosign, tan_5deg};        
                      end  

             9'h006,
             9'h0AE,
             9'h0BA,
             9'h162 : begin
                        cos = {cosign, sin_6deg};        
                        cot = {cosign, tan_6deg};        
                      end  

             9'h007,
             9'h0AD,
             9'h0BB,
             9'h161 : begin
                        cos = {cosign, sin_7deg};        
                        cot = {cosign, tan_7deg};        
                      end  

             9'h008,
             9'h0AC,
             9'h0BC,
             9'h160 : begin
                        cos = {cosign, sin_8deg};        
                        cot = {cosign, tan_8deg};        
                      end  

             9'h009,
             9'h0AB,
             9'h0BD,
             9'h15F : begin
                        cos = {cosign, sin_9deg};        
                        cot = {cosign, tan_9deg};        
                      end  

             9'h00A,
             9'h0AA,
             9'h0BE,
             9'h15E : begin
                        cos = {cosign, sin_10deg};       
                        cot = {cosign, tan_10deg};       
                      end  

             9'h00B,
             9'h0A9,
             9'h0BF,
             9'h15D : begin
                        cos = {cosign, sin_11deg};       
                        cot = {cosign, tan_11deg};       
                      end  

             9'h00C,
             9'h0A8,
             9'h0C0,
             9'h15C : begin
                        cos = {cosign, sin_12deg};       
                        cot = {cosign, tan_12deg};       
                      end  

             9'h00D,
             9'h0A7,
             9'h0C1,
             9'h15B : begin
                        cos = {cosign, sin_13deg};       
                        cot = {cosign, tan_13deg};       
                      end  

             9'h00E,
             9'h0A6,
             9'h0C2,
             9'h15A : begin
                        cos = {cosign, sin_14deg};       
                        cot = {cosign, tan_14deg};       
                      end  

             9'h00F,
             9'h0A5,
             9'h0C3,
             9'h159 : begin
                        cos = {cosign, sin_15deg};       
                        cot = {cosign, tan_15deg};       
                      end  

             9'h010,
             9'h0A4,
             9'h0C4,
             9'h158 : begin
                        cos = {cosign, sin_16deg};       
                        cot = {cosign, tan_16deg};       
                      end  

             9'h011,
             9'h0A3,
             9'h0C5,
             9'h157 : begin
                        cos = {cosign, sin_17deg};       
                        cot = {cosign, tan_17deg};       
                      end  

             9'h012,
             9'h0A2,
             9'h0C6,
             9'h156 : begin
                        cos = {cosign, sin_18deg};       
                        cot = {cosign, tan_18deg};       
                      end  

             9'h013,
             9'h0A1,
             9'h0C7,
             9'h155 : begin
                        cos = {cosign, sin_19deg};       
                        cot = {cosign, tan_19deg};       
                      end  

             9'h014,
             9'h0A0,
             9'h0C8,
             9'h154 : begin
                        cos = {cosign, sin_20deg};      
                        cot = {cosign, tan_20deg};      
                      end  

             9'h015,
             9'h09F,
             9'h0C9,
             9'h153 : begin
                        cos = {cosign, sin_21deg};       
                        cot = {cosign, tan_21deg}; 
                      end        
             
             9'h016,
             9'h09E,
             9'h0CA,
             9'h152 : begin
                        cos = {cosign, sin_22deg};       
                        cot = {cosign, tan_22deg};       
                      end  

             9'h017,
             9'h09D,
             9'h0CB,
             9'h151 : begin
                        cos = {cosign, sin_23deg};       
                        cot = {cosign, tan_23deg};       
                      end  

             9'h018,
             9'h09C,
             9'h0CC,
             9'h150 : begin
                        cos = {cosign, sin_24deg};       
                        cot = {cosign, tan_24deg};       
                      end  

             9'h019,
             9'h09B,
             9'h0CD,
             9'h14F : begin
                        cos = {cosign, sin_25deg};       
                        cot = {cosign, tan_25deg};       
                      end  

             9'h01A,
             9'h09A,
             9'h0CE,
             9'h14E : begin
                        cos = {cosign, sin_26deg};       
                        cot = {cosign, tan_26deg};       
                      end  

             9'h01B,
             9'h099,
             9'h0CF,
             9'h14D : begin
                        cos = {cosign, sin_27deg};       
                        cot = {cosign, tan_27deg};       
                      end  

             9'h01C,
             9'h098,
             9'h0D0,
             9'h14C : begin
                        cos = {cosign, sin_28deg};       
                        cot = {cosign, tan_28deg};       
                      end  

             9'h01D,
             9'h097,
             9'h0D1,
             9'h14B : begin
                        cos = {cosign, sin_29deg};       
                        cot = {cosign, tan_29deg};       
                      end  

             9'h01E,
             9'h096,
             9'h0D2,
             9'h14A : begin
                        cos = {cosign, sin_30deg};       
                        cot = {cosign, tan_30deg};       
                      end  

             9'h01F,
             9'h095,
             9'h0D3,
             9'h149 : begin
                        cos = {cosign, sin_31deg};       
                        cot = {cosign, tan_31deg};       
                      end  

             9'h020,
             9'h094,
             9'h0D4,
             9'h148 : begin
                        cos = {cosign, sin_32deg};       
                        cot = {cosign, tan_32deg};       
                      end  

             9'h021,
             9'h093,
             9'h0D5,
             9'h147 : begin
                        cos = {cosign, sin_33deg};       
                        cot = {cosign, tan_33deg};       
                      end  

             9'h022,
             9'h092,
             9'h0D6,
             9'h146 : begin
                        cos = {cosign, sin_34deg};       
                        cot = {cosign, tan_34deg};       
                      end  

             9'h023,
             9'h091,
             9'h0D7,
             9'h145 : begin
                        cos = {cosign, sin_35deg};       
                        cot = {cosign, tan_35deg};       
                      end  

             9'h024,
             9'h090,
             9'h0D8,
             9'h144 : begin
                        cos = {cosign, sin_36deg};       
                        cot = {cosign, tan_36deg};       
                      end  

             9'h025,
             9'h08F,
             9'h0D9,
             9'h143 : begin
                        cos = {cosign, sin_37deg};       
                        cot = {cosign, tan_37deg};       
                      end  

             9'h026,
             9'h08E,
             9'h0DA,
             9'h142 : begin
                        cos = {cosign, sin_38deg};       
                        cot = {cosign, tan_38deg};       
                      end  

             9'h027,
             9'h08D,
             9'h0DB,
             9'h141 : begin
                        cos = {cosign, sin_39deg};       
                        cot = {cosign, tan_39deg};       
                      end  

             9'h028,
             9'h08C,
             9'h0DC,
             9'h140 : begin
                        cos = {cosign, sin_40deg};       
                        cot = {cosign, tan_40deg};       
                      end  

             9'h029,
             9'h08B,
             9'h0DD,
             9'h13F : begin
                        cos = {cosign, sin_41deg};       
                        cot = {cosign, tan_41deg};       
                      end  

             9'h02A,
             9'h08A,
             9'h0DE,
             9'h13E : begin
                        cos = {cosign, sin_42deg};       
                        cot = {cosign, tan_42deg};       
                      end  

             9'h02B,
             9'h089,
             9'h0DF,
             9'h13D : begin
                        cos = {cosign, sin_43deg};       
                        cot = {cosign, tan_43deg};       
                      end  

             9'h02C,
             9'h088,
             9'h0E0,
             9'h13C : begin
                        cos = {cosign, sin_44deg};       
                        cot = {cosign, tan_44deg};       
                      end  

             9'h02D,
             9'h087,
             9'h0E1,
             9'h13B : begin
                        cos = {cosign, sin_45deg};       
                        cot = {cosign, tan_45deg};       
                      end  

             9'h02E,
             9'h086,
             9'h0E2,
             9'h13A : begin
                        cos = {cosign, sin_46deg};       
                        cot = {cosign, tan_46deg};       
                      end  

             9'h02F,
             9'h085,
             9'h0E3,
             9'h139 : begin
                        cos = {cosign, sin_47deg};       
                        cot = {cosign, tan_47deg};       
                      end  

             9'h030,
             9'h084,
             9'h0E4,
             9'h138 : begin
                        cos = {cosign, sin_48deg};       
                        cot = {cosign, tan_48deg};       
                      end  

             9'h031,
             9'h083,
             9'h0E5,
             9'h137 : begin
                        cos = {cosign, sin_49deg};       
                        cot = {cosign, tan_49deg};       
                      end  

             9'h032,
             9'h082,
             9'h0E6,
             9'h136 : begin
                        cos = {cosign, sin_50deg};       
                        cot = {cosign, tan_50deg};       
                      end  

             9'h033,
             9'h081,
             9'h0E7,
             9'h135 : begin
                        cos = {cosign, sin_51deg};       
                        cot = {cosign, tan_51deg};       
                      end  

             9'h034,
             9'h080,
             9'h0E8,
             9'h134 : begin
                        cos = {cosign, sin_52deg};       
                        cot = {cosign, tan_52deg};       
                      end  

             9'h035,
             9'h07F,
             9'h0E9,
             9'h133 : begin
                        cos = {cosign, sin_53deg};       
                        cot = {cosign, tan_53deg};       
                      end  

             9'h036,
             9'h07E,
             9'h0EA,
             9'h132 : begin
                        cos = {cosign, sin_54deg};       
                        cot = {cosign, tan_54deg};       
                      end  

             9'h037,
             9'h07D,
             9'h0EB,
             9'h131 : begin
                        cos = {cosign, sin_55deg};       
                        cot = {cosign, tan_55deg};       
                      end  

             9'h038,
             9'h07C,
             9'h0EC,
             9'h130 : begin
                        cos = {cosign, sin_56deg};       
                        cot = {cosign, tan_56deg};       
                      end  

             9'h039,
             9'h07B,
             9'h0ED,
             9'h12F : begin
                        cos = {cosign, sin_57deg};       
                        cot = {cosign, tan_57deg};       
                      end  

             9'h03A,
             9'h07A,
             9'h0EE,
             9'h12E : begin
                        cos = {cosign, sin_58deg};       
                        cot = {cosign, tan_58deg};       
                      end  

             9'h03B,
             9'h079,
             9'h0EF,
             9'h12D : begin
                        cos = {cosign, sin_59deg};       
                        cot = {cosign, tan_59deg};       
                      end  

             9'h03C,
             9'h078,
             9'h0F0,
             9'h12C : begin
                        cos = {cosign, sin_60deg};       
                        cot = {cosign, tan_60deg};       
                      end  

             9'h03D,
             9'h077,
             9'h0F1,
             9'h12B : begin
                        cos = {cosign, sin_61deg};       
                        cot = {cosign, tan_61deg};       
                      end  

             9'h03E,
             9'h076,
             9'h0F2,
             9'h12A : begin
                        cos = {cosign, sin_62deg};       
                        cot = {cosign, tan_62deg};       
                      end  

             9'h03F,
             9'h075,
             9'h0F3,
             9'h129 : begin
                        cos = {cosign, sin_63deg};       
                        cot = {cosign, tan_63deg};       
                      end  

             9'h040,
             9'h074,
             9'h0F4,
             9'h128 : begin
                        cos = {cosign, sin_64deg};       
                        cot = {cosign, tan_64deg};       
                      end  

             9'h041,
             9'h073,
             9'h0F5,
             9'h127 : begin
                        cos = {cosign, sin_65deg};       
                        cot = {cosign, tan_65deg};       
                      end  

             9'h042,
             9'h072,
             9'h0F6,
             9'h126 : begin
                        cos = {cosign, sin_66deg};       
                        cot = {cosign, tan_66deg};       
                      end  

             9'h043,
             9'h071,
             9'h0F7,
             9'h125 : begin
                        cos = {cosign, sin_67deg};       
                        cot = {cosign, tan_67deg};       
                      end  

             9'h044,
             9'h070,
             9'h0F8,
             9'h124 : begin
                        cos = {cosign, sin_68deg};       
                        cot = {cosign, tan_68deg};       
                      end  

             9'h045,
             9'h06F,
             9'h0F9,
             9'h123 : begin
                        cos = {cosign, sin_69deg};       
                        cot = {cosign, tan_69deg};       
                      end  

             9'h046,
             9'h06E,
             9'h0FA,
             9'h122 : begin
                        cos = {cosign, sin_70deg};       
                        cot = {cosign, tan_70deg};       
                      end  

             9'h047,
             9'h06D,
             9'h0FB,
             9'h121 : begin
                        cos = {cosign, sin_71deg};       
                        cot = {cosign, tan_71deg};       
                      end  

             9'h048,
             9'h06C,
             9'h0FC,
             9'h120 : begin
                        cos = {cosign, sin_72deg};       
                        cot = {cosign, tan_72deg};       
                      end  

             9'h049,
             9'h06B,
             9'h0FD,
             9'h11F : begin
                        cos = {cosign, sin_73deg};       
                        cot = {cosign, tan_73deg};       
                      end  

             9'h04A,
             9'h06A,
             9'h0FE,
             9'h11E : begin
                        cos = {cosign, sin_74deg};       
                        cot = {cosign, tan_74deg};       
                      end  

             9'h04B,
             9'h069,
             9'h0FF,
             9'h11D : begin
                        cos = {cosign, sin_75deg};       
                        cot = {cosign, tan_75deg};       
                      end  

             9'h04C,
             9'h068,
             9'h100,
             9'h11C : begin
                        cos = {cosign, sin_76deg};       
                        cot = {cosign, tan_76deg};       
                      end  

             9'h04D,
             9'h067,
             9'h101,
             9'h11B : begin
                        cos = {cosign, sin_77deg};       
                        cot = {cosign, tan_77deg};       
                      end  

             9'h04E,
             9'h066,
             9'h102,
             9'h11A : begin
                        cos = {cosign, sin_78deg};       
                        cot = {cosign, tan_78deg};       
                      end  

             9'h04F,
             9'h065,
             9'h103,
             9'h119 : begin
                        cos = {cosign, sin_79deg};       
                        cot = {cosign, tan_79deg}; 
                      end        
             
             9'h050,
             9'h064,
             9'h104,
             9'h118 : begin
                        cos = {cosign, sin_80deg};       
                        cot = {cosign, tan_80deg};       
                      end  

             9'h051,
             9'h063,
             9'h105,
             9'h117 : begin
                        cos = {cosign, sin_81deg};       
                        cot = {cosign, tan_81deg};       
                      end  

             9'h052,
             9'h062,
             9'h106,
             9'h116 : begin
                        cos = {cosign, sin_82deg};       
                        cot = {cosign, tan_82deg};       
                      end  

             9'h053,
             9'h061,
             9'h107,
             9'h115 : begin
                        cos = {cosign, sin_83deg};       
                        cot = {cosign, tan_83deg};       
                      end  

             9'h054,
             9'h060,
             9'h108,
             9'h114 : begin
                        cos = {cosign, sin_84deg};       
                        cot = {cosign, tan_84deg};       
                      end  

             9'h055,
             9'h05F,
             9'h109,
             9'h113 : begin
                        cos = {cosign, sin_85deg};       
                        cot = {cosign, tan_85deg};       
                      end  

             9'h056,
             9'h05E,
             9'h10A,
             9'h112 : begin
                        cos = {cosign, sin_86deg};       
                        cot = {cosign, tan_86deg};       
                      end  

             9'h057,
             9'h05D,
             9'h10B,
             9'h111 : begin
                        cos = {cosign, sin_87deg};       
                        cot = {cosign, tan_87deg};       
                      end  

             9'h058,
             9'h05C,
             9'h10C,
             9'h110 : begin
                        cos = {cosign, sin_88deg};       
                        cot = {cosign, tan_88deg};       
                      end  

             9'h059,
             9'h05B,
             9'h10D,
             9'h10F : begin
                        cos = {cosign, sin_89deg};       
                        cot = {cosign, tan_89deg};       
                      end  

             9'h05A,
             9'h10E : begin
                        cos = {cosign, sin_90deg};       
                        cot = {cosign, tan_90deg};       
                      end  

            default : begin
                        cos =  32'h00000000;   
                        cot =  32'h00000000;   
                      end  

        endcase 
    else begin
            cos = 32'h00000000; 
            cot = 32'h00000000;       
         end  

end         
            
endmodule            