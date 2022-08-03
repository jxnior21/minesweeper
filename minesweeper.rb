=begin
Write your code for the 'Minesweeper' exercise in this file. Make the tests in
`minesweeper_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/minesweeper` directory.
=end

class Board
    # Returns an Array containing each board frame transformed to
    # show the number of mines near each open slot.
    #

    def self.transform(board)
        output = [board.first]
        board_size = board.first.size
        board.each_with_index do |frame, index|
            raise ArgumentError if invalid_frame(board_size, frame)

            unless [0, board.size - 1].include?(index)
                output << transform_frame(board, frame, index)
            end
        end
        output << board.last
        output
    end

    private

    # Returns an Array of each frame slot transformed to 
    # show the number of mines near each open slot in the frame.
    #

    def self.transform_frame(board, frame, index)
        frame_output = []
        frame.each_char.with_index do |slot, i|
            raise ArgumentError if ![' ', '*', '|', '+'].include?(slot)

            unless [0, frame.size - 1].include?(i)
                nearby_slots = self.nearby_slots(board, index, i)
                count_of_mines = self.count_mines(nearby_slots)
                frame_output << self.format_output(slot, count_of_mines)
            end
        end
        "|#{frame_output.join}|"
    end

    # Returns the correct output format needed for each slot depending if 
    # it is a mine or not. If it is a mine then it returns the mine again.
    # If it is not a mine, it returns the count of nearby mines if the count 
    # is greater than 0 or it just returns an empty space.
    #

    def self.format_output(slot, count_of_mines)
        return slot if slot == '*' 

        if count_of_mines.zero? 
            ' ' 
        else
            count_of_mines
        end
    end

    # Returns an Array of slots directly touching a specific slot.
    # It returns the slot on top, bottom, right, left, top-right,
    # top-left, bottom-right, bottom-left.
    #

    def self.nearby_slots(board, board_index, frame_index)
        next_frame = board_index + 1
        last_frame = board_index - 1
        next_item = frame_index + 1
        last_item = frame_index - 1
        [
            board[next_frame][frame_index], 
            board[next_frame][last_item],
            board[next_frame][next_item],
            board[board_index][next_item],
            board[board_index][last_item],
            board[last_frame][frame_index], 
            board[last_frame][last_item],
            board[last_frame][next_item]
        ]
    end

    # Returns the number of mines in an Array.
    #  

    def self.count_mines(nearby_slots)
        nearby_slots.count do |slot|
            slot === '*'
        end
    end

    # Returns true if the size of a frame does not match
    # initial size set by the first board frame or 
    # if any of the frames have incorrect borders.
    #

    def self.invalid_frame(board_size, frame)
        (board_size != frame.size) || 
        (frame[0] != frame[frame.size - 1]) 
    end
end