`timescale 1ns / 1ps

module Core_test();

parameter DataWidth=32;
parameter AddrWidth=15;

    logic  clock;
    logic  reset;
    logic  [DataWidth-1:0]Reg_Out;
int my_array [0:119]= {495,1168,565,1176,1114,922,196,1102,800,945,831,578,1270,1483,1290,922,973,993,866,942,926,750,1360,1586,1300,828,1571,940,746,1196,1186,1078,291,983,1428,981,1062,1593,787,650,1219,1029,921,1587,1270,730,1241,1139,1525,1373,738,1609,1545,1347,1463,736,389,1109,1488,912,992,1346,394,1620,1316,679,1114,1679,765,735,578,1363,1096,638,740,1006,1296,395,575,1477,934,288,1142,895,1185,1152,1175,1036,1112,450,1573,333,1838,1191,877,739,1020,1149,1133,587,1462,1338,589,344,868,1498,1412,1356,1478,1227,1005,1843,953,533,606,956,948,881,648,1292};


Buraq_Top_RV32IM core(

    .brq_clk(clock),
    .brq_rst(reset),
    //OUTPUT//
    .Reg_Out(Reg_Out)
  );


initial begin
clock=0;
reset=1;
#2;
reset=0;
end

    always begin
        #1 clock = ~clock;  // timescale is 1ns so #5 provides 100MHz clock
    end
reg [32:0]i=0;
always @ (posedge clock) begin
       if (Reg_Out == my_array[i])begin
            $display("%d: values matched",i);
            i=i+1;
       end
end
endmodule 