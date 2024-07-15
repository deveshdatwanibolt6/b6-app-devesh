from flask import Flask
from .view import bp
from dotenv import load_dotenv


load_dotenv()


def create_app():
	app = Flask(__name__)
	app.register_blueprint(bp)
	return app