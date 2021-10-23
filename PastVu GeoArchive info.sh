while true; do
	N=$(echo "SELECT count(*) FROM \"PastVu\".\"GeoPhoto\";" | psql -A -t -q -d 'Геоинформационная система');
	zenity --info --text="$N";
done;
