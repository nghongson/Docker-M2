==================================
# Setting Permission Magento 2 #

  chown -R :www-data .

  without sudo
  find . -type d -exec chmod 770 {} \; && find . -type f -exec chmod 660 {} \; && chmod u+x bin/magento

  with sudo :
  sudo find . -type d -exec chmod 770 {} \; && sudo find . -type f -exec chmod 660 {} \; && sudo chmod u+x bin/magento


  find app/code lib var generated vendor pub/static pub/media app/etc \( -type d -or -type f \) -exec chmod g+w {} \; && chmod o+rwx app/etc/env.php

  chown :www-data /public_html -R

lockfile=/initlock
if [ ! -e $lockfile ]; then
   chmod u+x /public_html/bin/magento
   find . -type d -exec chmod 775 {} \;
   find . -type f -exec chmod 664 {} \;
   touch $lockfile
fi