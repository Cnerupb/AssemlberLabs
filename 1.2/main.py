"""Test assembly calculations in comparsion with Python calculation module"""

def main():
    x = float(input("x="))
    a = float(input("a="))
    # x = 5.5
    # a = 2.5
    for i in range(0, 10):
        y1 = float(3) + x if x == a else a - x
        y2 = abs(a) if a < x else abs(a) - x
        y = y1 + y2
        print()
        print('x={:5.3f}'.format(x))
        print('a={:5.3f}'.format(a))
        print('y1={:5.3f}'.format(y1))
        print('y2={:5.3f}'.format(y2))
        print('y={:5.3f}'.format(y))
        x += 1

if __name__ == "__main__":
    main()
