while true; do
	N=$(echo "SELECT count(*) FROM \"GeoPhoto\";" | psql -p 5434 -A -t -q -d "PastVu");
	zenity --info --text="$N";
done;
