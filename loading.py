from transformation import *
import os

locations = getLocations()
dates = getTimes()

if (not os.path.isdir('warehouse')):
    os.makedirs('warehouse')

locations.to_csv('warehouse/locations.csv', index=False)
dates.to_csv('warehouse/dates.csv', index=False)
getCustomers().to_csv('warehouse/customers.csv', index=False)
getProducts().to_csv('warehouse/products.csv', index=False)
getItemSales(dates).to_csv('warehouse/itemSales.csv', index=False)
getSalesPerItem(locations, dates).to_csv('warehouse/salesPerItem.csv', index=False)
getSalesPerOrder(locations, dates).to_csv('warehouse/salesPerOrder.csv', index=False)