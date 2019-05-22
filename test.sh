#!/bin/bash

RESULT=0
TEST_UUIDS_BAD=(
	"88888888-8887-0c13-030e-2007b7b7b7b7"
	"FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"
	"11111111-1111-1111-1111-111111111111"
	"yyyyyyyz-d912-d912-c193-bzd94a392405"
	"13f41d01-d912-d912-c193-zzzzzzzzzzz5"
	"ASDF2943f3AFI348FSL9F94D1F434F1FDS93"
	""
	"    "
	"2039-jfd09i2"
	"fd0o982j-0d9fj039jfd-09=29fj-9jrf-92j"
	"120939085-3412-4312-3413-343412359fj"
	"aaaaa"
	"09f0jd0f8i540g8ijdf0f2-jf=-349t-95gfj-f-1-93"
	"13f41d01-d912-d912-c193-bzd94a392405"
	"36373070-3234-584F-5137-3332303X344F"
)
TEST_UUIDS_GOOD=(
	"13f41d01-d912-d912-c193-bfd94a392405"
	"016845FF-A211-E910-9FD4-B4BF01216703"
	"36B73070-3A34-584F-5137-3332303D344F"
)

# mock dmidecode call
function dmidecode {
	echo "$(cat .test_uuid)"
}
export -f dmidecode

for UUID in "${TEST_UUIDS_BAD[@]}" ; do
	echo "$UUID" > .test_uuid
	OUTPUT=$(bash det-hostnqn.sh 2>&1)
	if [ $? -eq 0 ] ; then
		echo "[FAILED]	BAD UUID: '${UUID}' was accpeted."
		RESULT=1
	else
		echo "[PASSED]	BAD UUID: '${UUID}' was rejected."
	fi
done

for UUID in "${TEST_UUIDS_GOOD[@]}" ; do
	echo "$UUID" > .test_uuid
	OUTPUT=$(bash det-hostnqn.sh 2>&1)
	if ! [ $? -eq 0 ] ; then
		echo "[FAILED]	GOOD UUID: '${UUID}' was rejected."
		echo "$OUTPUT"
		RESULT=1
	else
		echo "[PASSED]	GOOD UUID: '${UUID}' was accepted."
	fi
done

# clean-up:
rm .test_uuid

if [ $RESULT -eq 0 ] ; then
	echo "EVERYTHING OK!"
else
	echo "SOME TEST(S) FAILED!"
fi

exit $RESULT
