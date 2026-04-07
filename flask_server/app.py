from flask import Flask, jsonify, request
import os

app = Flask(__name__)

# Ensure you have a folder to save uploads
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

logrotate_dir = 'logrotate_fx'
if not os.path.exists(logrotate_dir):
    os.makedirs(logrotate_dir)

@app.route("/", methods=["GET"])
def get_req():
    return jsonify({"msg": "hello"})

@app.route("/alert", methods=["POST"])
def handle_alert():
    if 'file' not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files['file']

    # 2. Check if the user actually selected a file
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file:
        # 3. Secure the filename and save it
        # In production, use werkzeug.utils.secure_filename
        file_path = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(file_path)

        return jsonify({
            "message": "File uploaded successfully",
            "filename": file.filename
        }), 200

@app.route("/logrotate", methods=["POST"])
def handle_logrotate():
    if 'file' not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files['file']

    # 2. Check if the user actually selected a file
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file:
        # 3. Secure the filename and save it
        # In production, use werkzeug.utils.secure_filename
        file_path = os.path.join(logrotate_dir, file.filename)
        file.save(file_path)

        return jsonify({
            "message": "File uploaded successfully",
            "filename": file.filename
        }), 200





if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)