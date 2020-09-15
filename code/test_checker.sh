rm -f *.exe *.gcov *.gcda *.gcno
gcc main.c io_array.c sort.c sum_array.c -o  main.exe -std=c99 -pedantic -Wall -Wvla -Werror -Wfloat-equal -Wfloat-conversion -O0 --coverage

# tests counters
declare -i total=$(ls -1q in_* | wc -l)
declare -i passed=0

for ((i=1;i<=total;i++)); do
  # gather expected and actual strings
  expected=$(cat out_${i})
  actual=$(./main.exe < in_${i})
  #echo "$actual\n"
  #echo "$expected\n"
  if [ "$expected" = "$actual" ]; then
    passed=$(( passed + 1 ))
    echo "Test #${i}: Passed."
  else
    echo "Test #${i}: Failed."
  fi
done

echo
echo "Tests: ${total} total, ${passed} passed, $(( total - passed )) failed."

echo
echo "Gathering code coverage info..."

percentage=`gcov main.c | grep -E -o "[0-9]+\.[0-9]+"`
echo "Code executed: ${percentage}%"

# clean up everything
rm -f *.exe *gcov *.gcno *.gcda
