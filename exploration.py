import pandas as pd
from transformation import *

superstore = pd.read_csv('superstore.csv', encoding='unicode_escape')


def productNames():
    products = superstore.filter(['Product ID', 'Product Name']).groupby(['Product ID', 'Product Name']).sum().reset_index()

    weird_products = products[~products['Product ID'].isin(products.drop_duplicates(subset='Product ID', keep=False)['Product ID'])]

    #Number of weird products
    print('Total number of weird products:')
    print(len(weird_products))

    #Percentage of entries in the dataset belonging to a weird product
    print('Number of entries belonging to a weird product:')
    print(str(round(len(superstore[superstore['Product ID'].isin(weird_products['Product ID'])]) / len(superstore) * 100, 2)) + '%')




productNames()