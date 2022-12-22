module LFSR_block #(
    parameter WIDTH=8,
    TAPS=8'b01000100,
    SEED=8'b00000000)
    
    (input ACTIVE, DATA,


    input clk, rst,

    output reg CRC, Valid
);

integer i;

reg [WIDTH-1:0] LFSR;

wire first_xor;
assign first_xor=DATA ^ LFSR[0];

always @(posedge clk or negedge rst ) begin
    if(rst)
    begin

        if (ACTIVE) 
        begin
            
            Valid<=0; //no CRC transmission
            CRC<=CRC;  //CRC flop is not changed

            LFSR[WIDTH-1]<=first_xor;

            for (i =WIDTH-2; i>=0 ; i=i-1) 
            begin
                if(TAPS[i]) //if TAPS[I] = 1 ---->this flop's i/p is xoring first_xor & the previous flop
                begin
                    LFSR[i]<=LFSR[i+1] ^ first_xor;
                end

                else
                begin
                    LFSR[i]<=LFSR[i+1];
                end
            end

        end

        else

        begin
            
            {LFSR[WIDTH-2:0],CRC}<=LFSR;   //shifting the register and transmit crc bit
            Valid<=1;   //CRC transmission has started 
        end
    end

    else
    begin
        //clearing all the flops we have
        Valid<=0;       
        CRC<=0;

        for (i=0 ;i<=WIDTH-1 ;i=i+1) 
        begin
            LFSR[i]<=0;
        end
    end
end

    
endmodule