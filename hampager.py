#!/usr/bin/env python3
"""
hampager script v1.07 by DO3BOX
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
The allowed TX groups are listed in OPTIONS. To add or remove groups, modify the OPTIONS variable.
"""

import requests
import getpass
import json

print("\033c")
print("hampager python script V1.00")
print("Copyright 2023 by Michael Grigutsch, DO3BOX. Published under GNU General Public License v3.0")
print()

# Abfrage der Parameter von der Kommandozeile
owncall = "owncall"  # replace with your own call sign
ownpass = "ownpass"  # replace with your own password
call = input("Bitte Zielcall eingeben: ")
message = input("Bitte Nachricht eingeben: ")


# Auswaehlen von txgroup von Liste
data = ["all", "b-all", "br-all", "ca-all", "ct-all", "dl-all", "dl-bb", "dl-be", "dl-bw", "dl-bw-freiburg", "dl-bw-karlsruhe", "dl-bw-stuttgart",
        "dl-bw-tuebingen", "dl-by", "dl-by-mittelfranken", "dl-by-niederbayern", "dl-by-oberbayern", "dl-by-unterfranken", "dl-hb", "dl-he",
        "dl-he-darmstadt", "dl-he-giessen", "dl-hh", "dl-mv", "dl-ni", "dl-nw", "dl-nw-arnsberg", "dl-nw-detmold", "dl-nw-duesseldorf",
        "dl-nw-koeln", "dl-nw-muenster", "dl-rp", "dl-sh", "dl-sh-nord", "dl-sl", "dl-sn", "dl-st", "dl-th", "ea-all", "f-all", "ha-all", "hb-all",
        "hs-all", "it-all", "ja-all", "la-all", "lu-all", "lx-all", "lz-all", "oe-all", "ok-all", "om-all", "on-all", "on-lg", "on-ov", "on-wb",
        "on-wv", "oz-all", "pa-all", "pa-br", "pa-fl", "pa-ge", "pa-lb", "pa-nh", "pa-oi", "pa-ut", "s5-all", "sm-all", "sp-all", "ua-all",
        "uk-all", "us-all", "ve-all", "vk-all", "yo-all", "z3-all", "zl-all", "4x-all", "test"]

# Ausgabe der Daten mit Paginierung
print("Bitte wählen Sie eine der folgenden Regionen für den Ruf (exit zum Beenden):")
for i, option in enumerate(data):
    if i % 30 == 0 and i != 0:
        # Nach jeder 30. Option Abfrage, ob Nutzer fortfahren oder abbrechen möchte
        user_input = input("Weiter (w) oder Beenden (b)? ")
        if user_input == "b":
            print("Die Abfrage wurde beendet.")
            break

    print(f"{i + 1}. {option}")

while True:
    # Nutzerabfrage
    user_input = input("Bitte wählen Sie eine Region aus der Liste oder geben Sie 'exit' ein, um den Ruf abzubrechen. ")

    if user_input == "exit":
        print("Der Ruf wurde abgebrochen. 73 de DO3BOX")
        exit()

    # Überprüfung auf gültige Eingabe
    if user_input.isdigit() and 1 <= int(user_input) <= len(data):
        txgroup = data[int(user_input) - 1]
        print(f"Sie haben '{txgroup}' ausgewählt.")        
        break
    else:
        print("Ungültige Eingabe. Bitte wählen Sie eine Region aus der Liste oder geben Sie 'exit' ein, um den Ruf abzubrechen. ")


# Erstellen des JSON-Datenobjekts
data = {
    "text": message,
    "callSignNames": [call],
    "transmitterGroupNames": [txgroup],
    "emergency": False
}

print(data)

# Senden des HTTP-POST-Requests an die api
url = "http://www.hampager.de/api/calls"
headers = {"Content-Type": "application/json"}
auth = (owncall, ownpass)
response = requests.post(url, headers=headers, auth=auth, data=json.dumps(data))

# Ausgabe der Antwort der api
if response.ok:
    print("Nachricht erfolgreich gesendet.")
else:
    print(f"Fehler beim Senden der Nachricht: {response.status_code} {response.reason}")
    print(response.text)

print("73 de DO3BOX")