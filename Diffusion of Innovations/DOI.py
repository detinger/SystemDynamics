
from scipy.integrate import odeint
import matplotlib.pyplot as plt
import numpy as np


def DOI(state, t):
    x = state[0]
    y = state[1]

    TP = 10000
    AF = 0.015
    AE = 0.011
    CR = 100

    AFA = (x * AE)
    AFWOM = (x * CR * AF * (y/TP))
    AR = AFA + AFWOM

    dAD = AR
    dPA = -AR
    return [dPA, dAD]

t = np.arange(0, 8, 0.1)
state0 = [10000, 0]
state = odeint(DOI, state0, t)

plt.plot(t, state)
plt.xlabel('Time')
plt.ylabel('Results')
plt.title('Diffusion of Innovations')
plt.grid(True)
# plt.savefig("test.png", format='png', dpi=300)
# plt.savefig("test.svg", format='svg', dpi=300)
plt.show()
