module ff(
    input logic ce,
    input c,
    input logic d,
    output logic q
);
    always @(posedge c) begin
        if (ce==1) begin
            q <= d;
        end
    end

endmodule
