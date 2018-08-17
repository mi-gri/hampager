#!/bin/bash
####################################
# hampager script v 1.07 by DO3BOX #
####################################
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    Dieses Programm ist Freie Software: Sie können es unter den Bedingungen
#    der GNU General Public License, wie von der Free Software Foundation,
#    Version 3 der Lizenz oder (nach Ihrer Wahl) jeder neueren
#    veröffentlichten Version, weiter verteilen und/oder modifizieren.
#
#    Dieses Programm wird in der Hoffnung bereitgestellt, dass es nützlich sein wird, jedoch
#    OHNE JEDE GEWÄHR,; sogar ohne die implizite
#    Gewähr der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
#    Siehe die GNU General Public License für weitere Einzelheiten.
#
#    Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
#    Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.
#
# Anleitung:
# Vor Benutzung auf hampager.de registrieren und eigene Zugangs-Daten unter owncall und ownpass eintragen.
owncall="yourcall"
ownpass="yourpass"
#
printf "\033c"
dialog --infobox "hampager bash script dialog edition V1.07
Copyright 2018 by Michael Grigutsch, DO3BOX. 
Published under GNU General Public License v3.0" 5 55
sleep 1
dialog --clear
while true
 do
  call=`dialog --title "Funkruf senden" --backtitle "hampager dialog by do3box" --ok-label "OK" --no-cancel --inputbox "Receiver/Empfänger" 8 22  3>&1 1>&2 2>&3`
  message=`dialog --title "Funkruf senden" --backtitle "hampager dialog by do3box" --ok-label "OK" --no-cancel --inputbox "Message/Nachricht" 8 80  3>&1 1>&2 2>&3`
  txgroup=`dialog --title "Funkruf senden" --backtitle "hampager dialog by do3box" --ok-label "OK" --no-cancel --menu "Please choose TX-Group / Bitte wähle TX-Gruppe" 20 80 7 \
 "all" "All" "b-all" "China" "br-all" "Brazil" "ca-all" "Chile" "ct-all" "Portugal" "dl-all" "Germany/Deutschland" "dl-bb" "Brandenburg" "dl-be" "Berlin" "dl-bw" "Baden-Württemberg" \
 "dl-bw-freiburg" "BW Bezirk Freiburg" "dl-bw-karlsruhe" "BW Bezirk Karlsruhe" "dl-bw-stuttgart" "BW Bezirk Stuttgart" "dl-bw-tuebingen" "BW Bezirk Tübingen" "dl-by" "Bayern" \
 "dl-by-mittelfranken" "BY Bezirk Mittelfranken" "dl-by-niederbayern" "BY Bezirk Mittelbayern" "dl-by-oberbayern" "BY Bezirk Oberbayern" "dl-by-unterfranken" "BY Bezirk Unterfranken" \
 "dl-hb" "Bremen" "dl-he" "Hessen" "dl-he-darmstadt" "HE Bezirk Darmstadt" "dl-he-giessen" "HE Bezirk Giessen" "dl-hh" "Hamburg" "dl-mv" "Mecklenburg-Vorpommern" "dl-ni" "Niedersachsen" \
 "dl-nw" "Nordrhein-Westfalen" "dl-nw-arnsberg" "NW Bezirk Arnsberg" "dl-nw-detmold" "NW Bezirk Detmold" "dl-nw-duesseldorf" "NW Bezirk Düsseldorf" "dl-nw-koeln" "NW Bezirk Köln" \
 "dl-nw-muenster" "NW Bezirk Münster" "dl-rp" "Rheinland-Pfalz" "dl-sh" "Schleswig-Holstein" "dl-sh-nord" "SH Nord" "dl-sl" "Saarland" "dl-sn" "Sachsen" "dl-st" "Sachsen-Anhalt" \
 "dl-th" "Thüringen" "ea-all" "Spain" "f-all" "France" "ha-all" "Hungary" "hb-all" "Schweiz" "hs-all" "Thailand" "it-all" "Italy" "ja-all" "Japan" "la-all" "Norway" \
 "lu-all" "Argentina" "lx-all" "Luxemburg" "lz-all" "Bulgaria" "oe-all" "Austria/Österreich" "ok-all" "Czech Republic" "om-all" "Slovak Republic" "on-all" "Belgium" "on-lg" "Liege" "on-ov" "Oost Vlaanderen" \
 "on-wb" "Waals-Brabant" "on-wv" "West Vlaanderen" "oz-all" "Denmark" "pa-all" "The Netherlands" "pa-br" "Brabant" "pa-fl" "Flevoland" "pa-ge" "Gelderland" "pa-lb" "Limburg" "pa-nh" "Noord Holland" "pa-oi" "Overijssel" \
 "pa-ut" "Utrecht" "s5-all" "Slowenia" "sm-all" "Sweden" "sp-all" "Poland" "ua-all" "Russia" "uk-all" "United Kingdom" "us-all" "U.S.A." "ve-all" "Canada" "vk-all" "Australia" \
 "yo-all" "Romania" "z3-all" "Macedonia" "zl-all" "New Zealand" "4x-all" "Israel" "test" "Testgroup" 3>&1 1>&2 2>&3`
  dialog --yesno "Ist \" $call @ $txgroup : $message \" korrekt?" 6 100
  korrekt=$?
  if [ $korrekt = 0 ]
    then
        # Hier wird der Ruf ausgelöst
        curl -s -H "Content-Type: application/json" -X POST -u "${owncall}:${ownpass}" -d '{ "text": "'"$message"'", "callSignNames": ["'"$call"'"], "transmitterGroupNames": ["'"$txgroup"'"], "emergency": false }' http://www.hampager.de:8080/calls|dialog --programbox 40 80
    else
        dialog --infobox "Abgebrochen" 0 0
        sleep 1
  fi
echo
dialog --yesno "Again / Nochmal?" 0 0
again=$?
if [ $again = 0 ]
   then
      unset txgroup
      unset call
      unset message
      unset korrekt
      printf "\033c"
   else
      dialog --infobox "73! Copyright 2018 by Michael Grigutsch, DO3BOX. Published under GNU General Public License v3.0" 0 0
      break
fi
done
