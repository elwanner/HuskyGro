from flask import Blueprint, request, jsonify, make_response
import json
from src import db

employees = Blueprint('employees', __name__)