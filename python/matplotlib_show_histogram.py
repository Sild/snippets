# pip3 install matplotlib
import matplotlib.pyplot as plt

data = [i for i in range(0, 10000)]

plt.hist(data, bins=1)
plt.xlabel('x_val')
plt.ylabel('y_val')
plt.show()
