#!/bin/sh

if [ $# -eq 0 ]
then
	files=`ls examples/*/*.py 2>/dev/null`
else
	files=`ls -1 "$@" 2>/dev/null | egrep "\.py$"`
fi

if [ ! -d outputfiles ] 
then
	mkdir outputfiles
fi
pass=0
fail=0
for file in $files
do
	if [ ! -f "$file" ]
	then
		print "$file does not exist - skipping"
		continue
	fi
	
	basename=`echo "$file" | egrep -o '[^\/]+$' | sed 's/\.py$//'`
	filedir=`echo "$file" | egrep -o '^([^\/]+\/)+'`
	echo "TESTING: $file"
	if [ ! -d outputfiles ]
	then
        	mkdir -p outputfiles
	fi
	
	./pypl.pl "$filedir$basename.py" >"outputfiles/$basename.pl"
	chmod 755 "$filedir$basename.py" "outputfiles/$basename.pl"
	echo "" >outputfiles/stdintest.in
	if cat "$filedir$basename.py" | egrep "stdin|fileinput\.input" >/dev/null
	then
		echo "Input required by program. Use the sample code below to determine appropriate input:"
		echo -------------------------------------------------------------------------------
		cat "$filedir$basename.py" | egrep -v '^#|^$'
		echo -------------------------------------------------------------------------------
		echo "Enter test input:"
		testinput=$(</dev/stdin)
		echo "$testinput" >outputfiles/stdintest.in
	fi
	if cat "$filedir$basename.py" | egrep "sys\.argv" >/dev/null
	then
		echo "Arguments required by program. Use the sample code below to determine appropriate input:"
		echo -------------------------------------------------------------------------------
		cat "$filedir$basename.py" | egrep -v '^#|^$'
		echo -------------------------------------------------------------------------------
		echo "Enter test argument(s), separated by spaces:"
		read testargs
	fi
	testfailed=0
	./$filedir$basename.py $testargs <outputfiles/stdintest.in >outputfiles/expected.out 2>/dev/null
	if ! ./outputfiles/$basename.pl $testargs <outputfiles/stdintest.in >outputfiles/actual.out 2>/dev/null 
	then
                echo -e "\033[0;31mPROGRAM EXECUTION FAILED"
		./outputfiles/$basename.pl $testargs <outputfiles/stdintest.in >/dev/null
                echo -e "\033[0m"
		testfailed=1
		fail=$((fail+1))
	else
		printf "Output diff: "
		if ! diff -q "outputfiles/expected.out" "outputfiles/actual.out" >/dev/null
        	then
			echo -e "\033[0;31mOUTPUTS DIFFER\033[0m"
                	echo
                	diff    --old-line-format=$'\e[0;31m-%L\e[0m' \
                        	--new-line-format=$'\e[0;32m+%L\e[0m' \
                        	--unchanged-line-format=$' %L' \
                        	"outputfiles/expected.out" "outputfiles/actual.out"
                	echo
			testfailed=1
			fail=$((fail+1))
        	else
                	echo -e "\033[0;32mNone found\033[0m"
			pass=$((pass+1))
        	fi
	fi
	if [ $testfailed -eq 1 ] && [ -f "$filedir$basename.pl" ]
	then
		printf "File diff: "
                if ! diff -q "$filedir$basename.pl" "outputfiles/$basename.pl" >/dev/null
                then
                        echo
                        echo
                        diff    --old-line-format=$'\e[0;31m-%L\e[0m' \
                                --new-line-format=$'\e[0;32m+%L\e[0m' \
                                --unchanged-line-format=$' %L' \
                                "$filedir$basename.pl" "outputfiles/$basename.pl"
                        echo
                else
                        echo -e "\033[0;32mNone found\033[0m"
                fi

	fi
	rm "outputfiles/expected.out" "outputfiles/actual.out"
done

test $(($pass + $fail)) -eq 0 || echo -e "\033[0;32m$pass tests passed \033[0;31m$fail tests failed\033[0m"
