`timescale 1us/1us

module LFSR_block_tb #(
    parameter WIDTH =8,
    TAPS=8'b01000100,
    SEED=8'b00000000
)();

reg active_tb, data_tb;
reg clk_tb,rst_tb;

wire crc_tb,valid_tb;

LFSR_block lfsr0 (
    .ACTIVE(active_tb),
    .DATA(data_tb),
    .clk(clk_tb),
    .rst(rst_tb),
    .CRC(crc_tb),
    .Valid(valid_tb)
);

always #5 clk_tb = ~clk_tb;

initial 
begin
    $dumpfile("LFSR.vcd");
    $dumpvars;
    clk_tb=1'b0;

    reset_assertion();               //time=1
    #2                               //time =3

    enter_data(1'b1, 8'b1100_0100);  //time =8
    #5
    enter_data(1'b1, 8'b1010_0110);  //time =18
    #5
    enter_data(1'b0, 8'b0101_0011);  //time =28
    #5
    enter_data(1'b0, 8'b1110_1101);  //time =38
    #5
    enter_data(1'b0, 8'b1011_0010);  //time =48
    #5
    enter_data(1'b0, 8'b0101_1001);  //time =58
    #5
    enter_data(1'b1, 8'b0010_1100);  //time =68
    #5
    enter_data(1'b1, 8'b1101_0010);  //time =78
    
    $display("1-byte has been transnmitted through data line !!");
    
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);
    #5
    sending_crc(lfsr0.LFSR[0]);

    
    $display("LFSR= %b" ,lfsr0.LFSR);
    #5
    $finish;


end

task reset_assertion();
begin 
    rst_tb=1'b0;
    #1
    if(lfsr0.LFSR == 0)
    $display("reset assertion succeeds !!");
end

endtask



task enter_data(input in_data, input [7:0] expected_op);

begin
    active_tb=1;
    
    data_tb=in_data;
    
    rst_tb=1'b1;
    #5
    if(lfsr0.LFSR == expected_op)
    begin
        $display("test passed !! LFSR=%d" ,lfsr0.LFSR );
    end

    else
    begin
        $display("test failed !! LFSR=%d" ,lfsr0.LFSR );
    end
    
end

endtask

task sending_crc(input expected_crc);

begin
    active_tb=0;
    rst_tb=1'b1;
    #5 

    if(crc_tb == expected_crc && valid_tb==1)
    $display("crc bit is sent successfully!! crc_tb=%d , valid_tb=%d",crc_tb, valid_tb);
    else
    $display("crc bit is not sent successfully!! crc_tb=%d , valid_tb=%d",crc_tb, valid_tb);
  

end
endtask
endmodule