#!/usr/bin/env bash

# weather.sh script by Laurier Rochon
# l@pwd.io

NB=$#
FILE_CITIES=cities
FILE_COUNTRIES=countries

#GET INPUT
if [ $NB -eq 1 ]
then
    A=`awk -F "\t" -v town="$1" 'tolower($3) ~ tolower(town) {print NR}' $FILE_CITIES`
fi

if [ $NB -eq 2 ]
then
A=`awk -F "\t" -v town="$1" -v state="$2" \
 'tolower($3) ~ tolower(town) && (tolower($2) ~ tolower(state) || tolower($1) ~ tolower(state)) {print NR}' $FILE_CITIES`
fi

if [ $NB -eq 3 ]
then
A=`awk -F "\t" -v town="$1" -v state="$2" -v country="$3" \
 'tolower($3) ~ tolower(town) && tolower($2) ~ tolower(state) && tolower($1) {print NR}' $FILE_CITIES`
fi

#make array of results
array=($A)
nbresults=${#array[@]}

#format url-friendly place
function parse_from_multiple(){
    if [ "$1" == "None, make a new search" ]
    then
        exit;
    fi
    url_ready_place=$(echo $1 | sed s/\'//g | sed 's/ /+/g')
    showresult
}

#make sure state contains no numbers
function check_state_validity(){
    if echo "$1" | grep '[0-9]' >/dev/null; then
        #not valid state.
        state=""
    else
        #valid state
        state="$state,"
    fi
    echo $state
}

#put together city names that have spaces (ex: "new york")
function concat_chunks(){
    city=""
    STR_ARRAY=(`echo $1 | tr "\t" "\n"`)
    i=0
    for x in "${STR_ARRAY[@]}"
    do
        if [  $i -gt $2 ]
        then
            city="$city $x"
        fi
        i=$[$i +1]
    done
    echo $city
}

function convert_country_code(){
    result=$(awk -F ";" -v code=$1 'NR > 1 && tolower($2) ~ tolower(code) {print tolower($1);}' $FILE_COUNTRIES)
    echo $result
}

#fetch the actual place
function getplace(){
    line=$1

    city=$(concat_chunks "${line}" 1)
    state=$(echo $line | awk '{print $2}')
    country=$(echo $line | awk '{print $1}')
    state=$(check_state_validity "${state}")
    country=$(convert_country_code "${country}")

    if [  $2 -gt 1 ]
    then
        city_formatted=$( echo "$city," | cut -c 1-)
        echo "'$city_formatted $state $country'"
    else
        echo "$city $state $country"
    fi
}

#make the wget request and parse the HTML
function showresult(){
    val=`wget -qO- "http://www.weather.com/search/enhancedlocalsearch?where=${url_ready_place}" | \
     awk -F '</span>' '/(wx-value)*(\"temperature-fahrenheit\")/ {print $1;}' | head -1 | tail -c 3`

    phrase=`wget -qO- "http://www.weather.com/search/enhancedlocalsearch?where=${url_ready_place}" | \
     awk -F '</span>' '/(wx-first)/ {getline; getline; getline; getline; print ;}' | head -1`

    section=$(echo $phrase | awk -F "desc=\"" '{print $NF}')
    full_f=`echo $section | sed 's/">//' | sed 's/It...//'`

    parts=`echo $full_f | sed 's/&deg...//'`
    description=""

    STR_ARRAY=(`echo $parts | tr "\t" "\n"`)
    temp_far=${STR_ARRAY[0]}

    temp_celcius=$((($temp_far-32)*5/9))
    description=$(concat_chunks "${parts}" 0)

    url_ready_place_spaces=$(echo $url_ready_place | sed 's/+/ /g')
    d=`echo $description| awk '{print tolower($0)}'`
    
    MESSAGE="\nIt's currently ${temp_celcius}°C (${temp_far}°F), $d in $url_ready_place_spaces.\n"
    COLOR='\033[01;32m'
    
    echo -e "${COLOR}${MESSAGE}"
}

#no results
if [  $nbresults -eq 0 ]
then
    echo "No results matched your city. Try another one?"
fi

#single result
if [  $nbresults -eq 1 ] 
then
    line_result=`sed -n "${array[0]}"p $FILE_CITIES`
    place=$(getplace "${line_result}" 1)
    url_ready_place=$(echo $place | sed 's/ /+/g')
    showresult
fi

#multiple results
if [  $nbresults -gt 1 ]
then
    echo "Did you mean:"
    choices=()
    for x in "${array[@]}"
    do
        line=$(echo "`sed -n ${x}p ${FILE_CITIES}`")
        place=$(getplace "${line}" 2)
        choices+=("$place")
    done
    choices+=("None, make a new search")
    select c in "${choices[@]}"; do parse_from_multiple "${c}"; break; done
fi