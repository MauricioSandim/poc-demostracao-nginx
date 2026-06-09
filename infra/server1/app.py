from flask import Flask
import time

app = Flask(__name__)

@app.route("/slow")
def slow():
    time.sleep(3)
    return {
        "server": "app-1"
    }

@app.route("/")
def home():
    return {
        "server": "app-1"
    }

app.run(host="0.0.0.0", port=5000)