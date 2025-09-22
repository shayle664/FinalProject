from flask import Flask, render_template, request, redirect, url_for
import random

app = Flask(__name__)

HELLO_THEMES = [
    "theme-aurora",
    "theme-sunset",
    "theme-berry",
    "theme-mint",
    "theme-plum",
    "theme-ocean",
]
# Home Page
@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form.get("name", "").strip()
        return redirect(url_for("hello", name=name))
    return render_template("home.html", theme="theme-ocean")

# Greeting Page
@app.route("/hello/<name>")
def hello(name):
    formatted_name = name.title()
    lower_name = name.lower()

    if lower_name == "shay":
        message = "Shay, you are a champion!"
    elif lower_name == "alex":
        message = "Alex, look how awesome I am! I had an amazing teacher, give me a good grade!"
    else:
        message = f"Hello, {formatted_name}!"

    theme = random.choice(HELLO_THEMES)
    return render_template("hello.html", message=message, theme=theme)

# Custom 404
@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html", theme="theme-lava"), 404


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5007)
