#!/bin/zsh

# automatically print today's courses
# whchen.io
# 01.28.2016

STYLE_RESET="\e[0m"
STYLE_BOLD="\e[1m"
STYLE_BLINK="\e[5m"
STYLE_RED="\e[31m"
STYLE_YELLOW="\e[33m"
STYLE_BLUE="\e[34m"
STYLE_CYAN="\e[36m"
STYLE_LMAG="\e[95m"
STYLE_WHITE="\e[97m"

MON=('ECON 355' 'PF 118' '10:00' '10:50' 'ECON 365' 'ST 131' '12:00' '12:50')
TUE=('ECON 395' 'SB 148' '11:00' '12:15' 'ECON 395' 'SS 020' '13:00' '13:50' 'ECON 359' 'ST 139' '14:00' '15:15' 'ECON 359' 'ICT 116' '17:00' '17:50' 'ECON 403' 'MS 211' '18:00' '20:45')
WED=('ECON 355' 'PF 118' '10:00' '10:50' 'ECON 365' 'ST 131' '12:00' '12:50')
THU=('ECON 395' 'SB 148' '11:00' '12:15' 'ECON 359' 'ST 139' '14:00' '15:15')
FRI=('ECON 355' 'PF 118' '10:00' '10:50' 'ECON 365' 'ST 131' '12:00' '12:50')
SSS=()

today=("${MON[@]}")

TITLE_CSNO="Course"
TITLE_LCT="Location"
TITLE_BGN="Begin"
TITLE_END="END"
TITLE_ST="Status"
TITLE_MOON="Younghwa"
TITLE_HEART="♥"
TITLE_CHEN="Wenhao"

STATUS_ON="ON-GOING"
STATUS_UP="UPCOMING"
STATUS_DOWN="FINISHED"

WIDTH_COL='         ' # 9
LINE_COL='=========' # 9
EMPTY_COL='*        '

function getTodayList() {
  numDay=`date +%w`
  case $numDay in
    1)
      today=("${MON[@]}")
      ;;
    2)
      today=("${TUE[@]}")
      ;;
    3)
      today=("${WED[@]}")
      ;;
    4)
      today=("${THU[@]}")
      ;;
    5)
      today=("${FRI[@]}")
      ;;
    *)
      today=("${SSS[@]}")
      ;;
    esac
}

while :; do

  clear

  dateToday=`date "+%Y-%m-%d"`
  dateStart="2015-12-20"
  daysdiff=$(((`date -jf %Y-%m-%d $dateToday +%s` - `date -jf %Y-%m-%d $dateStart +%s`)/86400))

  printf "${STYLE_BOLD}${STYLE_YELLOW}%s%s " "$TITLE_CSNO" "${WIDTH_COL:${#TITLE_CSNO}}"
  printf "%s%s " "$TITLE_LCT" "${WIDTH_COL:${#TITLE_LCT}}"
  printf "%s%s " "$TITLE_BGN" "${WIDTH_COL:${#TITLE_BGN}}"
  printf "%s%s " "$TITLE_END" "${WIDTH_COL:${#TITLE_END}}"
  printf "%s%s${STYLE_RESET} " "$TITLE_ST" "${WIDTH_COL:${#TITLE_ST}}"
  printf "${STYLE_BOLD}${STYLE_WHITE}  %s${STYLE_RESET}" "`date`"
  printf "\n%s %s %s %s %s   ${STYLE_BOLD}%s${STYLE_RESET} ${STYLE_LMAG}%s${STYLE_RESET} ${STYLE_BOLD}%s${STYLE_RESET}${STYLE_BOLD}${STYLE_LMAG}%s%s${STYLE_RESET}${STYLE_BOLD}-D${STYLE_RESET}\n" $LINE_COL $LINE_COL $LINE_COL $LINE_COL $LINE_COL $TITLE_MOON $TITLE_HEART $TITLE_CHEN "${WIDTH_COL:${#daysdiff}}" "$daysdiff"

  getTodayList

  ((numCS=${#today[@]}/4))
  for ((i=0; i<numCS; i++)) {
    varCrsNo=${today[i*4+1]}
    varLct=${today[i*4+2]}
    varBeg=${today[i*4+3]}
    varEnd=${today[i*4+4]}
    printf "${STYLE_BOLD}${STYLE_CYAN}%s%s${STYLE_RESET} " "$varCrsNo" "${WIDTH_COL:${#varCrsNo}}"
    printf "%s%s " "$varLct" "${WIDTH_COL:${#varLct}}"
    printf "%s%s " "${varBeg}" "${WIDTH_COL:${#varBeg}}"
    printf "%s%s " "${varEnd}" "${WIDTH_COL:${#varEnd}}"
    timenow=`date +%H`""`date +%M`
    timebeg=${varBeg:0:2}""${varBeg:3:2}
    timeend=${varEnd:0:2}""${varEnd:3:2}
    if [[ "$timenow" -lt "$timebeg" ]]; then
      printf "${STYLE_BOLD}${STYLE_YELLOW}%s%s${STYLE_RESET}" "${STATUS_UP}" "${WIDTH_COL:${#STATUS_UP}}"
    elif [[ "$timebeg" -le "$timenow" && "$timenow" -le "$timeend" ]]; then
      printf "${STYLE_BOLD}${STYLE_RED}${STYLE_BLINK}%s%s${STYLE_RESET}" "${STATUS_ON}" "${WIDTH_COL:${#STATUS_ON}}"
    elif [[ "$timenow" -gt "$timeend" ]]; then
      printf "${STYLE_BOLD}${STYLE_BLUE}%s%s${STYLE_RESET}" "${STATUS_DOWN}" "${WIDTH_COL:${#STATUS_DOWN}}"
    fi
    if [ $i != $((numCS-1)) ]; then
      printf "\n"
    fi
  }
  for ((i=numCS; i<5; i++)) {
    printf "\n%s %s %s %s %s" "${EMPTY_COL}" "${EMPTY_COL}" "${EMPTY_COL}" "${EMPTY_COL}" "${EMPTY_COL}"
  }
  sleep 1
done
