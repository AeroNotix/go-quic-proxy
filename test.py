import pandas as pd
import matplotlib.pyplot as plt
   
# data = {'Unemployment_Rate': [6.1,5.8,5.7,5.7,5.8,5.6,5.5,5.3,5.2,5.2],
#         'Stock_Index_Price': [1500,1520,1525,1523,1515,1540,1545,1560,1555,1565]
#        }
  
# df = pd.DataFrame(data,columns=['Unemployment_Rate','Stock_Index_Price'])
# df.plot(x ='Unemployment_Rate', y='Stock_Index_Price', kind = 'scatter')


# Read in the custom CSV made by vegeta with the extra 'request rate' column
csv = pd.read_csv('load-test.csv', header=None, names=["timestamp", "code", "latency", "bytesout", "bytesin", "error", "bas64Res", "name", "sequence", "method", "url", "bas64body",  "loss"], index_col=[0])

# Pandas nicely knows how to handle nanosecond epoch timestamps
csv.index = pd.to_datetime(csv.index, unit='ns')

# Convert latency nanoseconds -> seconds for legibility
csv['latency'] = csv.latency.apply(lambda x: x / 1e9)

# resample data set to 30 second 'chunks' with key columns
# Use the 90th percentile to help remove outliers
df = pd.DataFrame()
df['latency'] = csv.latency.resample('1S').agg(lambda x: x.quantile(.90))
df['loss'] = csv.loss.resample('1S').max()

# plot it, with the request rate on it's own axis
df.loss.plot()
df.latency.plot(secondary_y=True)

plt.savefig('bank_data.png')
