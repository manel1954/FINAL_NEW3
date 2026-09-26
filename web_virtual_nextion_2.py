from flask import Flask, jsonify, render_template
import serial
import re

app = Flask(__name__)

# Configuración del puerto serie
SERIAL_PORT = "/dev/virtual20"
BAUD_RATE = 9600

# Intentar abrir el puerto serie
try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
except serial.SerialException as e:
    print(f"Error al conectar con el puerto: {e}")
    ser = None

# Almacén para los últimos datos recibidos
last_data = {
    "Fecha y Hora": "N/A",
    "Estación": "N/A",
    "TX/RX": "N/A",
    "Frecuencia RX": "N/A",
    "Frecuencia TX": "N/A",
    "IP": "N/A",
    "Estado": "N/A",
    "Ber": "N/A",
    "LH": "N/A",
    "RSSI": "N/A",
    "Temp": "N/A",
    "TG": "N/A",
}

# Función para parsear datos del puerto serie
def parse_data(data_str):
    result = {}
    match_patterns = {
        "Fecha y Hora": r't2.txt="([^"]+)"',
        "Estación": r'20t0.txt="([^"]+)"',
        "TX/RX": r'50t[02]\.txt="([^"]+)"',
        "Frecuencia RX": r'\b1t30.txt="([^"]+)"\b',
        "Frecuencia TX": r'\b1t32.txt="([^"]+)"\b',
        "IP": r'\b1t3.txt="([^"]+)"\b',
        "Estado": r'\b1t0.txt="([^"]+)"\b',
        "Ber": r't[47]\.txt="([^"]+)"',
        "LH": r'50t[02]\.txt="([^"]+)"',
        "RSSI": r't[35]\.txt="([^"]+)"',
        "Temp": r'\b1t20.txt="([^"]+)"\b',
        "TG": r'\b1t[13]\.txt="([^"]+)"\b',
    }

    for key, pattern in match_patterns.items():
        match = re.search(pattern, data_str)
        if match:
            result[key] = match.group(1)
    return result

# Ruta principal para servir la interfaz HTML
@app.route('/')
def index():
    return render_template('index_2.html')

# Ruta para exponer los datos del puerto serie
@app.route('/data', methods=['GET'])
def get_data():
    global last_data

    # Leer datos del puerto serie si hay disponibles
    if ser and ser.in_waiting > 0:
        try:
            data = ser.read(ser.in_waiting).decode('utf-8', errors='ignore')
            parsed_data = parse_data(data)
            
            # Actualizar solo los campos que estén presentes en los nuevos datos
            for key, value in parsed_data.items():
                last_data[key] = value
            
        except Exception as e:
            return jsonify({"error": str(e)})

    # Siempre devuelve los últimos datos disponibles
    return jsonify(last_data)

# Iniciar el servidor Flask
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5002)
