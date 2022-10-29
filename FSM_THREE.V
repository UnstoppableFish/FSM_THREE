module FSM_THREE (
    input   wire            rstn,
    input   wire            clk,
    input   wire    [1:0]   sel,
    output  reg     [2:0]   out    
);
reg [4:0]state;
parameter   IDLE    = 5'b000_01,
            RD_S1   = 5'b000_10,
            RD_S2   = 5'b001_00,
            WR_S1   = 5'b010_00,
            WR_S2   = 5'b100_00;

reg    [4:0]NEXT;

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        state <= IDLE;
    else
        state <= NEXT;
end

always @(*) begin
    NEXT = state;
    if(!rstn)
        NEXT = IDLE;
    else case(state)
            IDLE    :if(sel[0])
                        NEXT = RD_S1;
                    else if(sel[1])
                        NEXT = WR_S1;
                    else
                        NEXT = NEXT;

            RD_S1   :if(sel[1])
                        NEXT = WR_S2;
                    else 
                        NEXT = RD_S2;

            RD_S2   :if(sel[1])
                        NEXT = WR_S1;
                    else 
                        NEXT = IDLE;

            WR_S1   :NEXT = WR_S2;

            WR_S2   :NEXT = IDLE;
        default     :NEXT = 3'bz;
    endcase
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        out <= 0;
    else case(state)
            IDLE    :if(sel[0])
                        out <= 3'b011;
                    else if(sel[1])
                        out <= 3'b001;
                    else
                        out <= 3'b000;

            RD_S1   :if(sel[1])
                        out <= 3'b010;
                    else if(!sel[1])
                        out <= 3'b100;
                    else
                        out <= 3'b011;

            RD_S2   :if(sel[1])
                        out <= 3'b001;
                    else if(!sel[1])
                        out <= 3'b000;
                    else
                        out <= 3'b100;

            WR_S1   :out <= 3'b010;

            WR_S2   :out <= 3'b000;

    endcase
end
endmodule //FSM_THREE