from flask import Blueprint, request, jsonify, make_response
import json
from src import db

customers = Blueprint('customers', __name__)