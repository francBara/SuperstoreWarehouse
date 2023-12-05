import pandas as pd
import numpy as np

df = pd.read_csv('superstore.csv', encoding='unicode_escape')

#print(df.columns)

def connectToDates(df, dates, date_column='Order Date'):
    df[date_column] = pd.to_datetime(df[date_column], format='%m/%d/%Y')
    df['Year'] = df[date_column].dt.year
    df['Month'] = df[date_column].dt.month
    df['Day'] = df[date_column].dt.day
    df = df.merge(dates, on=['Year', 'Month', 'Day'], how='left')
    df = df.drop([date_column, 'Year', 'Month', 'Day'], axis=1)
    df = df.rename({'Time ID': date_column}, axis=1)
    return df

def getCustomers():
    customers = df.drop_duplicates(subset='Customer ID')
    customers = customers.filter(['Customer ID', 'Customer Name', 'Segment'])
    return customers


def getLocations():
    locations = df.filter(['Country', 'City', 'State', 'Postal Code', 'Region'])
    locations = locations.drop_duplicates()
    locations = locations.reset_index()
    locations['Location ID'] = locations.index
    locations = locations[['Location ID', 'Country', 'City', 'State', 'Postal Code', 'Region']]
    return locations


def getProducts():
    products = df.drop_duplicates(subset='Product ID')
    products = products.filter(['Product ID', 'Category', 'Sub-Category', 'Product Name'])
    return products

def getTimes():
    dates = pd.DataFrame(columns=['Year', 'Month', 'Day'], dtype=object)

    for key in ['Order Date', 'Ship Date']:
        tmp = pd.DataFrame(columns=['date', 'Year', 'Month', 'Day'], dtype=object)
        tmp['date'] = pd.to_datetime(df[key], format='%m/%d/%Y')

        tmp['Year'] = tmp['date'].dt.year
        tmp['Month'] = tmp['date'].dt.month
        tmp['Day'] = tmp['date'].dt.day

        tmp = tmp.drop('date', axis=1)

        dates = pd.concat([dates, tmp])

    dates = dates.drop_duplicates()
    dates = dates.reset_index()
    dates['Time ID'] = dates.index
    dates = dates[['Time ID', 'Year', 'Month', 'Day']]

    return dates


def getItemSales(dates):
    itemSales = df.filter(['Product ID', 'Order Date', 'Quantity', 'Profit', 'Sales']).groupby(['Product ID', 'Order Date']).sum().reset_index()
    itemSales = connectToDates(itemSales, dates)
    return itemSales


def getSalesPerItem(locations, dates):
    salesPerItem = df.filter(['Product ID', 'Order Date', 'Order ID', 'Customer ID', 'Quantity', 'Profit', 'Discount', 'Sales', 'Country', 'City', 'State', 'Postal Code', 'Region'])

    salesPerItem = salesPerItem.merge(locations, on=['Country', 'City', 'State', 'Postal Code', 'Region'], how='left')
    salesPerItem = salesPerItem.drop(['Country', 'City', 'State', 'Postal Code', 'Region'], axis=1)

    salesPerItem = connectToDates(salesPerItem, dates)

    return salesPerItem

def getSalesPerOrder(locations, dates):
    salesPerOrder = df.merge(locations, on=['Country', 'City', 'State', 'Postal Code', 'Region'], how='left')
    salesPerOrder = salesPerOrder.drop(['Country', 'City', 'State', 'Postal Code', 'Region'], axis=1)

    salesPerOrder = salesPerOrder.filter(['Customer ID', 'Order ID', 'Order Date', 'Ship Date', 'Profit', 'Sales', 'Discount', 'Quantity', 'Location ID']).groupby(['Order ID', 'Customer ID', 'Order Date', 'Ship Date', 'Location ID']).agg(
        TotalProfit=('Profit', 'sum'),
        TotalSales=('Sales', 'sum'),
        TotalQuantity=('Quantity', 'sum')
    ).reset_index()

    salesPerOrder = connectToDates(salesPerOrder, dates)
    salesPerOrder = connectToDates(salesPerOrder, dates, date_column='Ship Date')

    return salesPerOrder

if __name__ == '__main__':
    locations = getLocations()
    dates = getTimes()
    print(getItemSales(dates))