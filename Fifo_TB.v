module priority_fifo_tb;
    reg clk = 0, reset;
    reg write_en, read_en;
    reg [7:0] data_in;
    reg priority_in;
    wire [7:0] data_out;
    wire empty, full;

    // Instantiate the FIFO
    priority_fifo uut (
        .clk(clk), .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .priority_in(priority_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generator: toggles every 5 time units (10ns period)
    always #5 clk = ~clk;

    // Initial block for simulation control
    initial begin
        //  Dump signals for GTKWave
        $dumpfile("priority_fifo.vcd");       // VCD output file
        $dumpvars(0, priority_fifo_tb);       // Dump everything in this module

        //  Console output
        $display("Time\tRead\tWrite\tPriority\tDataIn\tDataOut\tEmpty\tFull");
        $monitor("%0t\t%b\t%b\t%b\t\t%h\t%h\t%b\t%b",
                 $time, read_en, write_en, priority_in, data_in, data_out, empty, full);

        //  Reset
        reset = 1; write_en = 0; read_en = 0; data_in = 8'd0; priority_in = 0;
        #10 reset = 0;

        //  Write low-priority
        write_en = 1; priority_in = 0; data_in = 8'hAA; #10;
        data_in = 8'hCC; #10;

        //  Write high-priority
        priority_in = 1; data_in = 8'hBB; #10;
        data_in = 8'hDD; #10;

        //  Stop writing
        write_en = 0; #10;

        //  Read all
        read_en = 1;
        repeat (5) #10;
        read_en = 0;

        //  End
        #20 $finish;
    end
endmodule