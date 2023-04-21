#!/usr/bin/env python3
"""
raspi temp 2 hampager script v1.0 by DO3BOX
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

To use this script, register on hampager.de and enter your access data under owncall and ownpass.
"""

import os
import requests
import json
import socket

# Funktion, um die Temperatur des Raspberry Pi auszulesen
def get_temperature():
    # Öffne die Temperaturdatei des Raspberry Pi
    with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
        # Lese die Temperatur in Milligrad Celsius (m°C) aus
        temperature = float(f.read().strip()) / 1000.0
    return temperature

# API-Zugangsdaten
owncall = "owncall"  # replace with your own call sign
ownpass = "ownpass"  # replace with your own password

# Empfängerdaten
txgroup = "dl-all"   # replace with tx group of your choice
call = "call"        # replace with recipient callsign

# URL für das Senden der Nachricht über die hampager.de API
url = "http://www.hampager.de/api/calls"

# Schwellenwerttemperatur
threshold_temperature = 45.0

# Hostname
hostname = socket.gethostname()

# Nachrichtentext mit der aktuellen Temperatur
temperature = get_temperature()
if temperature > threshold_temperature:
    message = f'Temperatur ({hostname}): {temperature}°C (Schwellenwert überschritten!)'
else:
    message = f'Temperatur ({hostname}): {temperature}°C'

# Erstellen des JSON-Datenobjekts
data = {
    "text": message,
    "callSignNames": [call],
    "transmitterGroupNames": [txgroup],
    "emergency": False
}

# Sende die Nachricht über die hampager.de API, wenn die Schwellenwerttemperatur überschritten wurde
headers = {"Content-Type": "application/json"}
auth = (owncall, ownpass)

if temperature > threshold_temperature:
    response = requests.post(url, headers=headers, auth=auth, data=json.dumps(data))
    if response.ok:
        print("Nachricht erfolgreich gesendet.")
    else:
        print(f"Fehler beim Senden der Nachricht: {response.status_code} {response.reason}")
        print(response.text)
else:
    print('Schwellenwerttemperatur nicht überschritten.')

print("73 de DO3BOX")