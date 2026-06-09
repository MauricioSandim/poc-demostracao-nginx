from flask import Flask
import time


app = Flask(__name__)

@app.route("/slow")
def slow():
    time.sleep(1)
    return {
        "server": "app-3"
    }

@app.route("/")
def home():
    return {
        "server": "app-3"
    }

app.run(host="0.0.0.0", port=5000)