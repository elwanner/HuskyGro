from flask import Blueprint, request, jsonify, make_response, current_app
from datetime import datetime
import json
from src import db

employees = Blueprint('employees', __name__)

#get all employee ids 
@employees.route('/ids')
def get_ids(): 
    cursor = db.get_db().cursor()

    cursor.execute('select employee_id as label, employee_id as value from Employees')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#get all product names 
@employees.route('/products')
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

#get all order IDs 
@employees.route('/orderids')
def get_order_ids(): 
    cursor = db.get_db().cursor()

    cursor.execute('select order_id as label, order_id as value from CustOrder')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#get all open orders 
@employees.route('/orders', methods=['GET'])
def get_orders(): 
    cursor = db.get_db().cursor()

    cursor.execute('select order_id, need_by_date, employee_id \
        from CustOrder')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get all order details 
@employees.route('/details')
def get_all_order_details(): 
    cursor = db.get_db().cursor()
    cursor.execute('select order_id, product_name, quantity,\
                    aisle from CustOrderDetails join Products on CustOrderDetails.product_id = Products.product_id')
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
@employees.route('/details/<order_id>')
def get_order_details(order_id): 
    cursor = db.get_db().cursor()
    cursor.execute('select product_name, quantity from CustOrderDetails join Products where order_id = {0}'.format(order_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#get all available products 
@employees.route('/productinfo', methods=['GET'])
def get_products(): 
    cursor = db.get_db().cursor()

    cursor.execute('select product_name, sell_price, units_in_stock, aisle\
        from Products')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# update the progress of a customer order 
@employees.route("/orderprogress", methods=["PUT"])
def update_progress(): 
    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    employee_id = req_data['employee_id']
    progress = req_data['progress']
    order_id = req_data['order_id']

    update_stmt = 'UPDATE CustOrder SET employee_id = ' + str(employee_id) + ' WHERE order_id = ' + str(order_id) + ';'

    current_app.logger.info(update_stmt)

    cursor = db.get_db().cursor() 
    cursor.execute(update_stmt)
    db.get_db().commit()

    if progress == 1: 
        employee_id = req_data['employee_id']
        progress = req_data['progress']
        order_id = req_data['order_id']
        now = datetime.now()
        formatted_date = now.strftime('%Y-%m-%d %H:%M:%S')
        stmt = ' UPDATE CustOrder SET fulfillment_date = \'' + formatted_date + '\' WHERE order_id = ' + str(order_id) + ';'

        current_app.logger.info(stmt)

        cursor = db.get_db().cursor() 
        cursor.execute(stmt)
        db.get_db().commit()
    
    return "Success"

# delete a product that is no longer offered 
@employees.route("/deleteproduct", methods = ["DELETE"])
def delete_product(): 
    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    product_id = req_data['product_id']

    delete_stmt = 'DELETE FROM Products WHERE product_id = ' + str(product_id)

    current_app.logger.info(delete_stmt)

    cursor = db.get_db().cursor() 
    cursor.execute(delete_stmt)
    db.get_db().commit()
    return "Success"

# add a new product
@employees.route('/addnewproduct', methods = ["POST"])
def add_new_product():
    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    product_id = req_data['new_product_id']
    product_name = req_data['product_name']
    buy_price = req_data['buying_price']
    sell_price = req_data['selling_price']
    units_in_stock = req_data['units']

    insert_stmt = 'INSERT INTO Products (product_id, product_name, unit_price, sell_price, units_in_stock) VALUES ('
    insert_stmt += product_id + ', "' + product_name + '", ' + str(buy_price) + ', ' + str(sell_price)
    insert_stmt += ', ' + units_in_stock + ')'

    current_app.logger.info(insert_stmt)

    cursor = db.get_db().cursor()
    cursor.execute(insert_stmt)
    db.get_db().commit()
    return "Success"
    