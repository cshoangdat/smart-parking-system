from flask import Flask, request, jsonify
import uuid
from datetime import datetime, timedelta

app = Flask(__name__)

parking_data = []

@app.route('/add_vehicle', methods=['POST'])
def add_vehicle():
    data = request.get_json()
    
    required_fields = ["plate", "date", "startTime", "endTime", "parkingLocation"]
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing fields"}), 400
    
    # Kiểm tra xem plate đã tồn tại trong parking_data chưa
    if any(vehicle['plate'] == data['plate'] for vehicle in parking_data):
        return jsonify({"error": "Vehicle with this plate is already registered"}), 404
    
    short_uuid = str(uuid.uuid4())[:7]
    data['uuid'] = short_uuid
    
    parking_data.append(data)
    
    return jsonify({"message": "Parking data added successfully", "uuid": short_uuid}), 200

@app.route('/get_parking', methods=['GET'])
def get_parking():
    return jsonify(parking_data), 200

@app.route('/check_out', methods=['POST'])
def check_out():
    data = request.get_json()
    
    # Kiểm tra các trường cần thiết
    required_fields = ["plate", "uuid", "time"]
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing fields"}), 400
    
    plate = data['plate']
    uuid_check = data['uuid']
    time_check = data['time']

    for entry in parking_data:
        if entry['plate'] == plate and entry['uuid'] == uuid_check:
            start_time = datetime.strptime(entry['startTime'], '%H:%M')
            end_time = datetime.strptime(entry['endTime'], '%H:%M')
            time_to_check = datetime.strptime(time_check, '%H:%M')
            if entry.get("check_in") is None:
                return jsonify({"error": "vehicle isn't in parking lot"}), 404
            sum_of_time = entry["check_in"] - time_to_check
            
            if start_time <= time_to_check <= end_time:
                parking_data.remove(entry)
                return jsonify({
                    "message": "Success",
                    "excess_time": "0",
                    "time" : str(sum_of_time),
                    "location" : entry['parkingLocation']
                    }), 200
            
            if time_to_check < start_time:
                return jsonify({"error": "Time is before the start time"}), 400
            else:
                excess_time = time_to_check - end_time
                parking_data.remove(entry)
                return jsonify({
                    "message": "Time exceeds the allowed duration", 
                    "excess_time": str(excess_time),
                    "time" : str(sum_of_time),
                    "location" : entry['parkingLocation']
                }), 201

    return jsonify({"error": "No matching vehicle data"}), 404

@app.route('/check_in', methods=['POST'])
def check_in():
    data = request.get_json()
    
    # Kiểm tra các trường cần thiết
    required_fields = ["plate", "time"]
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing fields"}), 400
    
    plate = data['plate']
    time_check = data['time']

    for entry in parking_data:
        if entry['plate'] == plate:
            start_time = datetime.strptime(entry['startTime'], '%H:%M')
            end_time = datetime.strptime(entry['endTime'], '%H:%M')
            time_to_check = datetime.strptime(time_check, '%H:%M')
            
            entry["check_in"] = time_to_check
            
            if start_time <= time_to_check <= end_time:
                return jsonify({"message": "Success", "location" : entry["parkingLocation"]}), 200
            
            if time_to_check < start_time:
                return jsonify({"message": "Time is before the start time"}), 201
            elif time_to_check > end_time:
                return jsonify({"message": "Out of time for parking"}), 202

    return jsonify({"error": "No matching vehicle data"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
