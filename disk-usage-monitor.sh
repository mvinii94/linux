#!/bin/bash
# Marcus Vinícius de Mattos Ramos
# VARS:
LIMITE="80"
EMAIL="your@email.com"

for $PART in $(awk '{print $1}'); do
    USAGE=(df -h $PART | awk '{print $5}' | grep -v Use | sort -nr | awk -F % '{print $1}' | head -n1)

    if [ $USAGE -gt "$LIMITE" ]
    then
        echo "THE DISK USAGE IT IS "$USAGE"%, PLEASE CHECK THE FILES IN THE PARTITION: $PART UNTIL THE USAGE REACH THE LIMIT." | mutt -s "USAGE WARNING" $EMAIL
    fi
done
