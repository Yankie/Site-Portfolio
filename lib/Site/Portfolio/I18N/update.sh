#/usr/bin/sh

xgettext.pl -P perl=* -P tt2=tt2 -P formfu=yml --output=messages.pot --directory=../../../../lib/ --directory=../../../../root/forms --directory=../../../../root/static/ --directory=../../../../etc/themes/default --directory=../../../../etc/themes/kristy

msgmerge --update ru.po messages.pot
msgmerge --update i_default.po messages.pot
