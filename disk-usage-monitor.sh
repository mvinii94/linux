#!/bin/bash
# Marcus Vinícius de Mattos Ramos
# VARS:
LIMITE="80"
EMAIL="your@email.com"

for cmd in mutt df awk; do
      type $cmd &> /dev/null || { echo "THIS SCRIPT NEEDS THE PKG: $cmd TO WORK PROPERLY"; exit 1;  }
  done

for $PART in $(df -h | awk '{print $1}'); do

    USAGE=(df -h $PART | awk '{print $5}' | grep -v Use | sort -nr | awk -F % '{print $1}' | head -n1)

    if [ $USAGE -gt "$LIMITE" ]
    then
        echo "THE DISK USAGE IT IS "$USAGE"%, PLEASE CHECK THE FILES IN THE PARTITION: $PART UNTIL THE USAGE REACH THE LIMIT." | mutt -s "USAGE WARNING" $EMAIL
    fi
done
