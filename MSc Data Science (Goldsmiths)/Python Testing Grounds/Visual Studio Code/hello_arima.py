#%%

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA

df = pd.DataFrame({"Age" : [26, 35, 38]})

print(df)

plt.hist(df["Age"])
plt.show()

# %%
