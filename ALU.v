module half_adder(output sum, output carry, input a, input b);
    xor(sum, a, b);
    and(carry, a, b);
endmodule

module full_adder(output sum, output carry, input a, input b, input cin);
    wire s1, c1, c2;
    half_adder h1(s1, c1, a, b);
    half_adder h2(sum, c2, s1, cin);
    or(carry, c1, c2);
endmodule

module adder_8(output [7:0] sum, output carry, input [7:0] a, b, input cin);
    wire [7:0] c;
    full_adder f0(sum[0], c[0], a[0], b[0], cin);
    full_adder f1(sum[1], c[1], a[1], b[1], c[0]);
    full_adder f2(sum[2], c[2], a[2], b[2], c[1]);
    full_adder f3(sum[3], c[3], a[3], b[3], c[2]);
    full_adder f4(sum[4], c[4], a[4], b[4], c[3]);
    full_adder f5(sum[5], c[5], a[5], b[5], c[4]);
    full_adder f6(sum[6], c[6], a[6], b[6], c[5]);
    full_adder f7(sum[7], carry, a[7], b[7], c[6]);
endmodule

module not_gate(output [7:0] out, input [7:0] in);
    not n0(out[0], in[0]);
    not n1(out[1], in[1]);
    not n2(out[2], in[2]);
    not n3(out[3], in[3]);
    not n4(out[4], in[4]);
    not n5(out[5], in[5]);
    not n6(out[6], in[6]);
    not n7(out[7], in[7]);
endmodule

module and_gate(output [7:0] out, input [7:0] a,b);
    and a0(out[0], a[0], b[0]);
    and a1(out[1], a[1], b[1]);
    and a2(out[2], a[2], b[2]);
    and a3(out[3], a[3], b[3]);
    and a4(out[4], a[4], b[4]);
    and a5(out[5], a[5], b[5]);
    and a6(out[6], a[6], b[6]);
    and a7(out[7], a[7], b[7]);
endmodule

module or_gate(output [7:0] out, input [7:0] a, b);
    or o0(out[0], a[0], b[0]);
    or o1(out[1], a[1], b[1]);
    or o2(out[2], a[2], b[2]);
    or o3(out[3], a[3], b[3]);
    or o4(out[4], a[4], b[4]);
    or o5(out[5], a[5], b[5]);
    or o6(out[6], a[6], b[6]);
    or o7(out[7], a[7], b[7]);
endmodule

module nand_gate(output [7:0] out, input [7:0] a, b);
    wire [7:0] and_out;
    and_gate g_and(and_out, a, b);
    not_gate g_not(out, and_out);
endmodule

module Rotate_right(output [7:0] out, input [7:0] in);
    assign out = {in[0], in[7:1]};
endmodule

module Rotate_left(output [7:0] out, input [7:0] in);
    assign out = {in[6:0], in[7]};
endmodule

module right_shift(output [7:0] out, input [7:0] in);
    assign out = {{1{in[7]}}, in[7:1]};
endmodule

module left_shift(output [7:0] out, input [7:0] in);
    assign out = {in[6:0], 1'b0};
endmodule

module isequal_8(output [7:0] out, input [7:0] a,b);
    assign out = (a == b) ? 8'b00000001 : 8'b00000000;
endmodule

module mux_4(output [7:0] out, input [7:0] d0, d1, d2, d3,input [1:0] sel);
	assign out = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 : d3;
endmodule

module mux_16(output [7:0] y,input [7:0] d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,input [3:0] sel);

    wire [7:0] level1_0, level1_1, level1_2, level1_3;

    mux_4 m0(level1_0, d0, d1, d2, d3, sel[1:0]);
    mux_4 m1(level1_1, d4, d5, d6, d7, sel[1:0]);
    mux_4 m2(level1_2, d8, d9, d10, d11, sel[1:0]);
    mux_4 m3(level1_3, d12, d13, d14, d15, sel[1:0]);
    mux_4 mux_total(y, level1_0, level1_1, level1_2, level1_3, sel[3:2]);
endmodule

module isequal_1(output zero, input [7:0] a, b);
    assign zero = (a == b);
endmodule

module ALU_8(output [7:0] Result, output Zero, Negative, Overflow,input [7:0] A, B, input [3:0] AluOp);
    
    wire[7:0] or_res, and_res, not_res, nand_res, rr_res, rl_res, shift_R_res, shift_L_res, equal_res, adder_first, adder_second, adder_result;
    wire adder_carr, adder_inp;
    
    and_gate g1(and_res, A, B);
    or_gate g2(or_res, A, B);
    not_gate g3(not_res, A);
    nand_gate g4(nand_res, A, B);
	
    Rotate_right g5(rr_res, A);
    Rotate_left g6(rl_res, A);
    left_shift g7(shift_L_res, B);
    right_shift g8(shift_R_res, B);
    isequal_8 g9(equal_res, A, B);
    
	assign adder_first = (AluOp == 4'b0001) ? B : A; 
    assign adder_second = (AluOp == 4'b0001) ? ~A : (AluOp == 4'b0010) ? 8'b00000001 : B; 
	assign adder_inp = (AluOp == 4'b0001) ? 1'b1 : 1'b0;
	
	adder_8 adder(adder_result,adder_carr,adder_first,adder_second,adder_inp);
	
	mux_16 mux_final(Result,adder_result,adder_result,adder_result,8'b0,8'b0,equal_res, shift_L_res,          
        shift_R_res,not_res,and_res,or_res,nand_res,rl_res,rr_res,8'b0,8'b0,AluOp);
	
    isequal_1 g13(Zero, Result, 8'b00000000);
    assign Negative = Result[7];
    assign Overflow = (AluOp[3:2] == 2'b00) ? ((adder_first[7] == adder_second[7]) && (adder_result[7] != adder_first[7])) : 1'b0;

endmodule

//======================================
module ALU_test;
    reg [7:0] A, B;
    reg [3:0] AluOp;
    wire [7:0] Result;
    wire Zero, Negative, Overflow;

    ALU_8 alu(Result, Zero, Negative, Overflow, A, B, AluOp);

    initial begin
        $display("=== Welcome to ALU simulator ===");
        $monitor("t=%0t | A=%d | B=%d | AluOp=%b | Result=%d | Zero=%b | Negative=%b | Overflow=%b ",
                 $time, A, B, AluOp, Result, Zero, Negative, Overflow);

        #10 A=8'd10; B=8'd5; AluOp=4'b0000; // Add 15
        #10 A=8'd5; B=8'd10; AluOp=4'b0001; // rev subt 5
        #10 A=8'd10; B=8'd0; AluOp=4'b0010; // 
        #10 A=8'd10; B=8'd10; AluOp=4'b0101;
      
        #10 A=8'd0; B=8'd5; AluOp=4'b0110;
        #10 A=8'd0; B=8'd10; AluOp=4'b0111;
        
        #10 A=8'b10101010; B=8'd0; AluOp=4'b1100;
        #10 A=8'b10101010; B=8'd0; AluOp=4'b1101;
        
        #10 A=8'b11110000; B=8'd0; AluOp=4'b1000;
        #10 A=8'b11110000; B=8'b11001100; AluOp=4'b1001;
        #10 A=8'b11110000; B=8'b11001100; AluOp=4'b1010;
        #10 A=8'b11110000; B=8'b11001100; AluOp=4'b1011;
        
        #10 $finish;
    end
endmodule
