from transformation import *
import os



if (not os.path.isdir('warehouse')):
    os.makedirs('warehouse')

locations = getLocations()
dates = getTimes()

customers = getCustomers()
products = getProducts()

locations.to_csv('warehouse/locations.csv', index=False)
dates.to_csv('warehouse/dates.csv', index=False)
customers.to_csv('warehouse/customers.csv', index=False)
products.to_csv('warehouse/products.csv', index=False)
getItemSales(dates, products).to_csv('warehouse/itemSales.csv', index=False)
getSalesPerItem(locations, dates, customers, products).to_csv('warehouse/salesPerItem.csv', index=False)
getSalesPerOrder(locations, dates, customers).to_csv('warehouse/salesPerOrder.csv', index=False)