
`default_nettype none
module drv7seg_1(
    input wire [3:0]        code,
    output wire         a,b,c,d,e,f,g
);
 
    reg [6:0] t;
    always @(* )
        case (code)
            0:            t = 7'b0000000;
            1:            t = 7'b0110000;
            2:            t = 7'b1101101;
            3:            t = 7'b1111001;
            4:            t = 7'b0110011;
            5:            t = 7'b1011011;
            6:            t = 7'b1011111;
            7:            t = 7'b1110000;
            8:            t = 7'b1111111;
            9:            t = 7'b1111011;
            10:            t = 7'b1110111;
            11:            t = 7'b0011111;
            12:            t = 7'b1001110;
            13:            t = 7'b0111101;
            14:            t = 7'b1001111;
            15:            t = 7'b1000111;
            default:            t =7'b0000000;
        endcase
    
    assign a= t[6];
    assign b= t[5];
    assign c= t[4];
    assign d= t[3];
    assign e= t[2];
    assign f = t[1];
    assign g= t[0];
  endmodule

`default_nettype none
module drv7seg_varA(
    input wire [3:0]        code,
    output wire         a,b,c,d,e,f,g
);
     reg [6:0] t;
    always @(* )
        case (code)
            0:    t = 7'b0000000;
            1:    t = 7'b0110000;
            2:    t = 7'b1101101;
            3:    t = 7'b1111001;
            4:    t = 7'b0110011;
            5:    t = 7'b1011011;
            6:    t = 7'b1011111;
            7:    t = 7'b1110000;
            8:    t = 7'b1111111;
            9:    t = 7'b1111011;
            default:    t = 7'bxxxxxxxx;
        endcase
    
    assign a= t[6];
    assign b= t[5];
    assign c= t[4];
    assign d= t[3];
    assign e= t[2];
    assign f = t[1];
    assign g= t[0];
  
endmodule

`default_nettype none
module drv7seg_varB(
    input wire [3:0]        X,
    output wire        a,b,c,d,e,f,g
);
    wire [3:0]        nX;
    
    assign nX=~X;
     assign a= X[3] | X[1] | (X[0] & X[2]);
    assign b= ( X[3] | X[2] | X[1] | X[0] ) & ( nX[2] | nX[1] | X[0] ) & ( nX[2] | X[1] | nX[0] );
    assign c= X[3] | X[2] | X[0];
    assign d= X[3] | ( nX[0] & X[1] ) | ( nX[2] &X[1] ) | (X[2] & nX[1] & X[0]);
    assign e= ( X[1] & nX[0] ) | ( X[3] & nX[0] );
    assign f = ( X[3] | X[2] ) & ( nX[1] | nX[0] );
    assign g= ( X[3] | X[2] | X[1] ) & ( nX[2] | nX[1] | nX[0] );
  
endmodule

`default_nettype none
module drv7seg_OPT(
    input wire [3:0]        X,
    output wire        a,b,c,d,e,f,g
);
    wire [3:0]        nX;

    wire a0, a1, a2;
    wire b0, b1, b2;
    wire c0;
    wire d0, d1, d2, d3;
    wire e0, e1;
    wire f1, f0;
    wire g1, g0;

    assign nX=~X;

    assign a2 = X[3];
    assign a1 = X[2] & X[0];
    assign a0 = X[1];
     assign a = a2 |  a1 | a0;
    
    assign b2 = c0 | X[1];
    assign b1 = nX[2] | nX[1] | X[0];
    assign b0 = nX[2] | X[1] | nX[0];
    assign b = b2 & b1 & b0 ;

    assign c0 = f1 | X[0];
    assign c = c0; 
    
    assign d3 = X[3];
    assign d2 = X[1] & nX[0];
    assign d1 = nX[2] & X[1];
    assign d0 = a1 & nX[1] ;    
    assign d = d3 | d2 |  d1 | d0;

    assign e1 = d2;
    assign e0 = X[3] & nX[0];    
    assign e = e1 | e0;

    assign f1 = X[3] | X[2];
    assign f0 = nX[1] | nX[0];
    assign f = f1 & f0;
    
    assign g1 = f1 | X[1];
    assign g0 = nX[2] | f0;
    assign g = g1 & g0;

endmodule

`timescale 1 ps/ 1 ps

//
// General Test Bench 
//
`default_nettype none

module GTB;

    localparam nanos        = 1000;
    localparam micros        = 1000*1000;

    reg        clk;
    reg [3:0]    icode = 0;
    wire        a,b,c,d,e,f,g;
    wire        a1,b1,c1,d1,e1,f1,g1;
    wire        a2,b2,c2,d2,e2,f2,g2;
    wire        a3,b3,c3,d3,e3,f3,g3;

    wire integer    ocode;
    wire integer    ocode_vA;
    wire integer    ocode_vB;
    wire integer    ocode_OPT;


    function integer s7toInt;
        input a,b,c,d,e,f,g;

    begin
        if ({a,b,c,d,e,f,g} == 7'b0000000)            s7toInt = 0;
        else if ({a,b,c,d,e,f,g} == 7'b0110000)            s7toInt = 1;
        else if ({a,b,c,d,e,f,g} == 7'b1101101)            s7toInt = 2;
        else if ({a,b,c,d,e,f,g} == 7'b1111001)            s7toInt = 3;
        else if ({a,b,c,d,e,f,g} == 7'b0110011)            s7toInt = 4;
        else if ({a,b,c,d,e,f,g} == 7'b1011011)            s7toInt = 5;
        else if ({a,b,c,d,e,f,g} == 7'b1011111)            s7toInt = 6;
        else if ({a,b,c,d,e,f,g} == 7'b1110000)            s7toInt = 7;
        else if ({a,b,c,d,e,f,g} == 7'b1111111)            s7toInt = 8;
        else if ({a,b,c,d,e,f,g} == 7'b1111011)            s7toInt = 9;
        else if ({a,b,c,d,e,f,g} == 7'b1110111)            s7toInt = 10;
        else if ({a,b,c,d,e,f,g} == 7'b0011111)            s7toInt = 11;
        else if ({a,b,c,d,e,f,g} == 7'b1001110)            s7toInt = 12;
        else if ({a,b,c,d,e,f,g} == 7'b0111101)            s7toInt = 13;
        else if ({a,b,c,d,e,f,g} == 7'b1001111)            s7toInt = 14;
        else if ({a,b,c,d,e,f,g} == 7'b1000111)            s7toInt = 15;
        else                             s7toInt = -1;
            
    end
    endfunction

begin
    
    always @(posedge clk)
        icode <= icode +1;

    
    drv7seg_1 drv7seg_1(
        .code (icode),
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g)
    );

    drv7seg_varA drv7seg_2(
        .code (icode),
        .a(a1), .b(b1), .c(c1), .d(d1), .e(e1), .f(f1), .g(g1)
    );
    
    drv7seg_varB drv7seg_3(
        .X (icode),
        .a(a2), .b(b2), .c(c2), .d(d2), .e(e2), .f(f2), .g(g2)
    ); 
    
    
    drv7seg_OPT drv7seg_4(
        .X (icode),
        .a(a3), .b(b3), .c(c3), .d(d3), .e(e3), .f(f3), .g(g3)
    );
    
    assign ocode = s7toInt(a,b,c,d,e,f,g);
    assign ocode_vA = s7toInt(a1,b1,c1,d1,e1,f1,g1);
    assign ocode_vB = s7toInt(a2,b2,c2,d2,e2,f2,g2);
    assign ocode_OPT = s7toInt(a3,b3,c3,d3,e3,f3,g3);
end
    
initial begin
    clk = 1'b0;
    #  (500*nanos);
    forever
        begin
            #(20000);
            clk =  ~clk;
        end
end
    

endmodule

