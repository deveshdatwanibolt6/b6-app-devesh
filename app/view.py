from flask import Blueprint
import os

bp = Blueprint("login", __name__)

@bp.route("/")
def login():
	return "VERSION" + " " + str(os.environ.get('VERSION', "1.1"))
