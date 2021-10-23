DB='Геоинформационная система';
API_table='"PastVu"."JSON_API"';
ImgArchive='/opt/PastVu';

DB_SQL() {
echo "$1" | psql -d "$DB" -A -t -q;
}

#Crit="\"JSON\"->'user'->>'login' = '$1'";
Crit="(\"JSON\"->'regions'->-1->>'cid' = '$1' OR \"JSON\"->'regions'->-2->>'cid' = '$1')";
N=$(DB_SQL "SELECT count(*) FROM $API_table WHERE NOT \"void\" AND $Crit;");
echo "ВСЕГО $N";
DB_a=$(DB_SQL "SELECT \"Id\", \"JSON\"->>'file' \"adr\" FROM $API_table WHERE NOT \"void\" AND $Crit;");
echo "$DB_a";
echo;
echo "$DB_a" | while read phl; do
  URL=$(echo "$phl" | cut -f 2 -d '|');
  Id=$(echo "$phl" | cut -f 1 -d '|');
  DN=$(echo "$URL" | cut -f 4 -d '/');
  if [ -f "/opt/PastVu/$DN" ]; then
    echo "⭮ $Id $DN";
  else
    wget "https://pastvu.com/_p/a/$URL" -U 'Mozilla/5.0 (X11; Linux x86_64...) Gecko/20100101 Firefox/60.0' -O "$ImgArchive/$DN" && echo "🗸 $Id";
  fi
done;
