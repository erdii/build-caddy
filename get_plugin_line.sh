#! env sh

IMPORT_START=$(awk  '/^import \($/ {print FNR;}' $1)

TMP=$(expr $IMPORT_START + 1)

REL_IMPORT_END=$(tail -n +$TMP $1 | awk '/^\)$/ {print FNR; exit;}')

IMPORT_END=$(expr $IMPORT_START + $REL_IMPORT_END)

echo $(expr $IMPORT_END - 1)