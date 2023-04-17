from flask import Blueprint, request, jsonify, make_response
import json
from src import db
from datetime import datetime

customers = Blueprint('customers', __name__)

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

@customers.route('/order', methods=['POST'])
def post_order():
    req = request.get_json()

    customer_id = req['customer_id']
    order_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    need_by_date = req['need_by_date']
    tip = req['tip']
    paid = 1
    delivery = 0
    if req['delivery'] == 'delivery':
        delivery = 1
    address = req['address']


    #HAVE TO RELOAD CONTAINERS FOR CHANGES MADE TO BOOTSTRAP - date for need by date and autoincrement for order_id
    query = "INSERT INTO CustOrder (order_id, customer_id, need_by_date, tip, paid, delivery, address) VALUES ("
    query += "'" + str(5) + "', "
    query += "'" + customer_id + "', "
    query += "'" + need_by_date + "', "
    query += "'" + tip + "', "
    query += "'" + str(paid) + "', "
    query += "'" + str(delivery) + "', "
    query += "'" + address + "'"
    query += ")"

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!"

@customers.route('/past_orders', methods=['GET'])
def post_order():
    req = request.get_json()
    order_id = req['order_id']

    query = "SELECT product_name, quantity, unit_price from CustOrderDetails join Products where order_id = {0}".format(order_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)

    column_headers = [x[0] for x in cursor.description]

    json_data = []

    theData = cursor.fetchall()

    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)