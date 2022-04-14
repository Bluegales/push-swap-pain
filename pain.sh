NBR="73 66 74 63 39 26 90 48 71 36 8 79 55 4 52 72 0 42 96 54 3 22 86 44 82 34 32 78 85 43 16 75 65 69 51 30 76 9 15 45 2 18 10 91 13 58 20 68 70 60 89 11 47 81 80 92 27 49 95 21 41 31 67 61 33 35 40 97 6 38 56 94 88 59 57 23 19 12 62 29 64 46 14 99 84 83 50 25 28 93 87 53 5 17 98 7 1 24 37 77"
CMD=$( ./push_swap $NBR)
NBR_LINK=$( echo "$NBR" | sed -e "s/ /,/g" )
CMD_LINK=$( echo "$CMD" | sed -e"s/sa/a/g" -e"s/sb/b/g" -e"s/ss/c/g" \
-e"s/ra/d/g" -e"s/rb/e/g" -e"s/rr/f/g" -e"s/rra/g/g" -e"s/rrb/h/g" \
-e"s/rrr/i/g" -e"s/pa/j/g" -e"s/pb/k/g" -e"s/ //g")
echo "https://bluegales.github.io/push-swap-pain/?&nbr=$NBR_LINK&cmd=$CMD_LINK"
