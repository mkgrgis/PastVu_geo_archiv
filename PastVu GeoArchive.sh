DB='Геоинформационная система';
API_table='"PastVu"."JSON_API"';
API_URL='https://pastvu.com/api2?method=photo.giveForPage';

PastVuIndex() {
N=$(DB_SQL "SELECT count(*) FROM $API_table WHERE \"Id\"=$1;");
if [ "$N" == "1" ]
then
 	echo "⭮      $i";
else
	JSON=$(wget "$API_URL&params={%22cid%22:$1}" -q -O - 2>/dev/null | jq ".result.photo" | sed 's/"/\"/g' | sed "s/'/''/g");
	if [ "$JSON" == "" ]; then
        void=0;
        s='🗴';
        JSON='NULL';
    else
        s='🗸';
        if [ "$JSON" == "null" ]; then
            JSON='NULL';
            void=1;
            s='🗴';
        else
            void=0;
            JSON="'$JSON'";
        fi        
    fi
	r=$(DB_SQL "INSERT INTO $API_table (\"Id\", \"JSON\", \"void\") VALUES ($1, $JSON, $void::bool) RETURNING \"Id\";");
	echo "$s 🖧    $r $void $2";
fi
}

DB_SQL() {
echo "$1" | psql -d "$DB" -A -t -q;
}


PastVu404() {
wget "$API_URL&params={%22cid%22:$1}" -O - >/dev/null;
res="$?";
if [ "$res" == "8" ]
then
	r=$(DB_SQL "INSERT INTO $API_table (\"Id\", \"ok\", \"null\") VALUES ($1, 0::bool, 1::bool) RETURNING \"Id\";");
	echo "🗴      $r $res 404 ";
elif [ "$res" == "4" ]
then
	echo "🗴    $1 Сеть перегружена";
elif [ "$res" == "0" ]
then
	echo "🗴 $res    $1 Цикл";
	#PastVuIndex "$1" "Цикл";
else
	echo "- $res   $1";
fi
}

PastVu_diapazon (){
n=10;
for ((i=$1; i < $2; i++))
do
	i1=$(($i+$n));
	N=$(DB_SQL "SELECT count(*) FROM $API_table WHERE \"Id\">=$i AND \"Id\"<$i1;");
	if [ "$N" != "$n" ]
	then
		PastVuIndex "$i"
	else
		i=$(($i+$n-1));
		echo "- +$n  $i1";
	fi
done
echo "Диапазон обработан $1 -> $2";
}

n_iter=$3;
for ((i=$1; i < $2; i=i+$n_iter))
do
	i1=$(($i+$n_iter));
	N=$(DB_SQL "SELECT count(*) FROM $API_table WHERE \"Id\">=$i AND \"Id\"<$i1;");
	[ "$N" != "$n_iter" ] && echo "Диапазон не полностью заполнен $i" && (PastVu_diapazon "$i" "$i1" &) || echo "v Диапазон заполнен $i";
done
