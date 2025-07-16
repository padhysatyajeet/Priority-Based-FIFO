module priority_fifo #(parameter DEPTH = 8, WIDTH = 8)(
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [WIDTH-1:0] data_in,
    input priority_in, // 1 = High, 0 = Low
    output reg [WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);

    reg [WIDTH-1:0] high_fifo [0:DEPTH-1];
    reg [WIDTH-1:0] low_fifo [0:DEPTH-1];
    integer high_head = 0, high_tail = 0;
    integer low_head = 0, low_tail = 0;

    wire high_empty = (high_head == high_tail);
    wire low_empty = (low_head == low_tail);
    wire high_full  = ((high_tail + 1) % DEPTH == high_head);
    wire low_full   = ((low_tail + 1) % DEPTH == low_head);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            high_head <= 0; high_tail <= 0;
            low_head <= 0; low_tail <= 0;
            data_out <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            // Write operation
            if (write_en) begin
                if (priority_in && !high_full) begin
                    high_fifo[high_tail] <= data_in;
                    high_tail <= (high_tail + 1) % DEPTH;
                end else if (!priority_in && !low_full) begin
                    low_fifo[low_tail] <= data_in;
                    low_tail <= (low_tail + 1) % DEPTH;
                end
            end

            // Read operation (High-priority first)
            if (read_en) begin
                if (!high_empty) begin
                    data_out <= high_fifo[high_head];
                    high_head <= (high_head + 1) % DEPTH;
                end else if (!low_empty) begin
                    data_out <= low_fifo[low_head];
                    low_head <= (low_head + 1) % DEPTH;
                end
            end

            // Update status
            empty <= (high_empty && low_empty);
            full  <= (high_full && low_full);
        end
    end
endmodule