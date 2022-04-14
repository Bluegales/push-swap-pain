NBR="0 1 2 5 6 8 7 3 4"
CMD="ra pa pb ss sa rra"
NBR_LINK=$( echo "$NBR" | sed -e "s/ /,/g" )
CMD_LINK=$( echo "$CMD" | sed -e"s/sa/a/g" -e"s/sb/b/g" -e"s/ss/c/g" \
-e"s/ra/d/g" -e"s/rb/e/g" -e"s/rr/f/g" -e"s/rra/g/g" -e"s/rrb/h/g" \
-e"s/rrr/i/g" -e"s/pa/j/g" -e"s/pb/k/g" -e"s/ //g")
echo "https://htmlpreview.github.io/?https://github.com/Bluegales\
/push-swap-pain/blob/main/index.html?nbr=$NBR_LINK&cmd=$CMD_LINK"
