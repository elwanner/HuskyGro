from flask import Blueprint, request, jsonify, make_response, current_app
from datetime import datetime
import json
from src import db

customers = Blueprint('customers', __name__)

#get all products
@customers.route('/products')
def get_all_products():

    query = '''
        SELECT product_name, sell_price, aisle, units_in_stock
        FROM Products
        ORDER BY product_name
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)

    column_headers = [x[0] for x in cursor.description]

    json_data = []

    theData = cursor.fetchall()

    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

#get a product's aisle
@customers.route('/aisle')
def get_aisle():

    req = request.get_json()
    product_name = req['product_name']

    query = "SELECT aisle FROM Products WHERE product_name = '" + product_name + "'" 

    cursor = db.get_db().cursor()
    cursor.execute(query)

    column_headers = [x[0] for x in cursor.description]

    json_data = []

    theData = cursor.fetchall()

    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

#place a new order
@customers.route('/order', methods=['POST'])
def post_order():
    req = request.get_json()

    #determine the order_id of the most recent order
    query = "SELECT max(order_id) FROM CustOrder"
    cursor = db.get_db().cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    order_id = 0
    for row in data:
        num = row[0]
        order_id = str(num + 1)

    #retrieve insert values from request
    customer_id = req['customer_id']
    order_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    need_by_date = req['need_by_date']
    day = need_by_date[:10]
    time = need_by_date[11:22]
    formatted_date = "'" + day + " " + time + "'"
    tip = req['tip']
    paid = 1
    if req['delivery'] == 'delivery':
        delivery = 1
    else:
        delivery = 0
    address = req['address']

    #insert new row into CustOorder
    query1 = "INSERT INTO CustOrder (order_id, customer_id, need_by_date, tip, paid, delivery, address) VALUES ("
    query1 += "" + str(order_id) + ", "
    query1 += "" + str(customer_id) + ", "
    query1 += "" + formatted_date + ", "
    query1 += "" + str(tip) + ", "
    query1 += "" + str(paid) + ", "
    query1 += "" + str(delivery) + ", "
    query1 += "'" + address + "'"
    query1 += ")"
    cursor = db.get_db().cursor()
    cursor.execute(query1)
    db.get_db().commit()


    return "Success!"

#retrieve prior order
@customers.route('/past_orders', methods=['GET'])
def past_orders():
    req = request.get_json()
    customer_id = req['customer_id']

    query = "SELECT CustOrder.order_id, product_name, order_date, sell_price, CustOrderDetails.quantity from CustOrderDetails join CustOrder on CustOrderDetails.order_id = CustOrder.order_id join Products P on CustOrderDetails.product_id = P.product_id where CustOrder.customer_id = {0} ORDER BY order_date".format(customer_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)

    column_headers = [x[0] for x in cursor.description]

    json_data = []

    theData = cursor.fetchall()

    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

#get all product names 
@customers.route('/productname')
def get_product_names(): 
    cursor = db.get_db().cursor()

    cursor.execute('select product_name as label, product_id as value from Products')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#get order details for a specific order 
@customers.route('/orderdetails/<orderid>')
def get_order_details(orderid): 
    cursor = db.get_db().cursor()
    cursor.execute('select * from CustOrderDetails where order_id = {0}'.format(orderid))
    cursor = db.get_db().cursor()

    cursor.execute('select product_name, sell_price, quantity from CustOrderDetails join Products on CustOrderDetails.product_id = Products.product_id where order_id = {0}'.format(orderid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


#adds a product and quantity to order details
@customers.route('/addproduct', methods = ['POST'])
def add_product_to_cart():
    req = request.get_json()

    current_app.logger.info(req)

    order_id = req['order_id']
    product_id = req['product_id']
    quantity = req['quantity']

    query = "INSERT INTO CustOrderDetails (order_id, product_id, quantity) VALUES ("
    query += str(order_id) + ", "
    query += str(product_id) + ", "
    query += str(quantity)
    query += ")"

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!"

#get most recent order
@customers.route('/recent_order/<customerid>')
def get_recent_order(customerid):
    cursor = db.get_db().cursor()
    
    cursor.execute('select order_id as label, order_id as value from CustOrder where customer_id = {0}'.format(customerid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    
    return the_response