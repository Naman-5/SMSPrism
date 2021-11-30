from flask import Flask, request, jsonify
import json
import pickle
import numpy as np

app = Flask(__name__)
model = pickle.load(open('model.pkl', 'rb'))

@app.route('/predict',methods=['POST'])
def predict():
    message = request.get_json(force=True)
    prediction = model.predict(np.array(list(message.values())))

    output = prediction[0]
    return jsonify(output)

if __name__ == "__main__":
    app.run(debug=True)
