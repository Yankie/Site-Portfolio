#/usr/bin/sh

xgettext.pl -P perl=* -P tt2=tt2 -P formfu=yml --output=messages.pot --directory=../../../../lib/ --directory=../../../../root/forms --directory=../../../../root/static/ --directory=../../../../root/themes/default

msgmerge --update ru.po messages.pot
msgmerge --update i_default.po messages.pot
