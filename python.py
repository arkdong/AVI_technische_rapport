class Sudoku:
    def __init__(self, filename):
        self.grid = self.read_file(filename)

    def read_file(self, filename):
        with open(filename, 'r') as f:
            lines = f.readlines()
            grid = [[int(num) for num in line.split()] for line in lines]
            return grid

    def print_grid(self):
        for row in self.grid:
            print(row)

    def find_empty(self):
        for i in range(9):
            for j in range(9):
                if self.grid[i][j] == 0:
                    return (i, j)
        return None

    def is_valid(self, num, pos):
        # Check row
        for i in range(9):
            if self.grid[pos[0]][i] == num and pos[1] != i:
                return False
        # Check column
        for i in range(9):
            if self.grid[i][pos[1]] == num and pos[0] != i:
                return False
        # Check square
        box_x = pos[1] // 3
        box_y = pos[0] // 3
        for i in range(box_y*3, box_y*3 + 3):
            for j in range(box_x * 3, box_x*3 + 3):
                if self.grid[i][j] == num and (i,j) != pos:
                    return False
        return True

    def solve(self):
        empty = self.find_empty()
        if not empty:
            return True
        else:
            row, col = empty
        for i in range(1,10):
            if self.is_valid(i, (row, col)):
                self.grid[row][col] = i
                if self.solve():
                    return True
                self.grid[row][col] = 0
        return False


if __name__ == '__main__':
    sudoku = Sudoku('hard_sudoku_2.txt')
    print('Original puzzle:')
    sudoku.print_grid()
    sudoku.solve()
    print('\nSolved puzzle:')
    sudoku.print_grid()
