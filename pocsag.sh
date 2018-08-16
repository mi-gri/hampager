#!/bin/bash
# hampager script v 1.04 by DO3BOX
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
# Liste der zulässigen TX-Groups. Diese ist editierbar, man muss dann allerdings weiter unten (1) die Abfrage ebenfalls erweitern
OPTIONS="all dl-all dl-bb dl-be dl-bw dl-by dl-hb dl-he dl-hh dl-mv dl-ni dl-nw dl-nw-koeln dl-rp dl-sh dl-sl dl-sn dl-st dl-th ea-all f-all ha-all hb-all hs-all it-all ja-all la-all lu-all lx-all lz-all oe-all ok-all om-all on-all oz-all pa-all s5-all sm-all sp-all ua-all uk-all us-all ve-all vk-all yo-all test"
#
while true
 do
  read -p "An Call: " call
  read -p "Nachricht: " message
  echo "Bitte TX-Gruppe auswaehlen:"
  select txgroup in $OPTIONS; do
     case "$txgroup" in
        # (1) Bitte entsprechend der oben zugelassenen TX-Groups anpassen
         all|dl-all|dl-bb|dl-be|dl-bw|dl-by|dl-hb|dl-he|dl-hh|dl-mv|dl-ni|dl-nw|dl-nw-koeln|dl-rp|dl-sh|dl-sl|dl-sn|dl-st|dl-th|ea-all|f-all|ha-all|hb-all|hs-all|it-all|ja-all|la-all|lu-all|lx-all|lz-all|oe-all|ok-all|om-all|on-all|oz-all|pa-all|s5-all|sm-all|sp-all|ua-all|uk-all|us-all|ve-all|vk-all|yo-all|test)
              echo $call @ $txgroup : $message
              read -p "Korrekt (J/n)? " korrekt
              case "$korrekt" in
                    J|j|Ja|ja|Y|y|Yes|yes|"") 
		    echo "Rueckmeldung von hampager.de: "
                    # Hier wird der Ruf ausgelöst
                    curl -H "Content-Type: application/json" -X POST -u "${owncall}:${ownpass}" -d '{ "text": "'"$message"'", "callSignNames": ["'"$call"'"], "transmitterGroupNames": ["'"$txgroup"'"], "emergency": false }' http://www.hampager.de:8080/calls
                    break
                    ;;
                    *) echo "Abgebrochen"
                       break
                    ;;
              esac
        ;;
        *) echo "Bitte gueltige TX-Gruppe waehlen"
        ;;
     esac
  done
echo
read -p "Nochmal (j/N)? " again
case "$again" in
      J|j|Ja|ja|Y|y|Yes|yes) unset txgroup
      unset call
      unset message
      unset korrekt
      echo "-----"
      ;;
      *) echo "73! written by Michael Grigutsch, DO3BOX, under GNU General Public License v3.0 in 2018"
         break
      ;;
esac
done
