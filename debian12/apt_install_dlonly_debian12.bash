#!/bin/bash

function custom_error_exit() {
 echo error $1 abort/exit
 exit $1
}


mkdir --parents --verbose /var/cache/apt/custom_save/root/var/cache/apt/archives
mkdir --parents --verbose /var/cache/apt/custom_save/root/var/lib

echo -n doing sync...
sync
echo DONE


if test -d /var/cache/apt/custom_save/root/var/lib/apt ; then
 echo /var/cache/apt/custom_save/root/var/lib/apt exists, skipping copying
else
 rsync -aH /var/lib/apt /var/cache/apt/custom_save/root/var/lib/
 echo -n doing sync...
 sync
 echo DONE
fi

if test \! -e /var/cache/apt/custom_save/root/var/cache/apt/pkrcache.bin ; then
 cp -nv /var/cache/apt/pkgcache.bin /var/cache/apt/custom_save/root/var/cache/apt/
fi
if test \! -e /var/cache/apt/custom_save/root/var/cache/apt/srcpkrcache.bin ; then
 cp -nv /var/cache/apt/srcpkgcache.bin /var/cache/apt/custom_save/root/var/cache/apt/
fi

echo -n sync...
sync
echo DONE

# hex = unexistent package


dpkg-divert  --add  --local  --rename  /etc/ssh/sshd_config
sync
echo sync DONE. sleep 4...
sleep 4

# debian 12 only: polkitd polkitd-pkla
# absent in LMDE5 (based on debian 11): debian-policy debmake doc
# absent in debian12: remmina-plugin-nx remmina-plugin-spice openshot firefox scrcpy  acetoneiso gnome-themes-standard 
#install these:
package_list="firefox-esr firefox-esr-l10n-ru parted memtest86+ isenkram isenkram-cli inxi python3 sane sane-utils xsane skanlite simple-scan gscan2pdf skanpage qreator qtqr qrencode wifi-qr concalc ipcalc-ng ipcalc ipqalc ipv6calc kmplot sipcalc cppreference-doc-en-html p7zip-full file-roller xarchiver  compiz compizconfig-settings-manager rsync vlock nano-tiny grub-pc-bin \
 mousepad  task-xfce-desktop lightdm-settings lightdm \
 lightdm-gtk-greeter lightdm-gtk-greeter-settings manpages-ru  info  links2 \
 gedit  amd64-microcode intel-microcode gdebi-core gdebi net-tools grub-pc-bin grub-efi-amd64-bin rsync info lightdm-settings lightdm-gtk-greeter lightdm-gtk-greeter-settings    policykit-1 policykit-1-gnome debian-policy  debian-handbook debmake-doc  doc-debian debian-refcard debian-kernel-handbook developers-reference developers-reference-ru debian-history debian-faq debian-faq-ru doc-rfc doc-rfc-*  thunar-volman gvfs-backends dbus-x11 gvfs-daemons gvfs-libs gvfs dbus dbus-bin dbus-daemon tmux tilda  htop vlock screen pwgen mc gparted audacity gimp krita inkscape karbon calligrastage calligrawords calligrasheets abiword gnumeric mousepad geany gedit pluma img2pdf imagemagick imagemagick-doc ffmpeg ffmpeg-doc kdenlive flowblade shotcut  simplescreenrecorder recordmydesktop vokoscreen vokoscreen-ng kazam peek obs-studio vlc yt-dlp flac lame lame-doc k3b k3b-i18n gimp-help-en gimp-help-ru xsane sane sane-utils qemu-utils guvcview     brasero xorriso aqemu ovmf mousepad links2 falkon  task-xfce-desktop compiz compizconfig-settings-manager  nano-tiny  lsscsi iotop cpuid links2  lshw lshw-gtk  iotop-c powertop remmina  remmina-plugin-rdp remmina-plugin-vnc   remmina-plugin-secret xtightvncviewer tigervnc-viewer libvirt-daemon libvirt-daemon-system libvirt-daemon-system-systemd  libvirt-doc  virt-manager  virt-viewer libvirt-clients  spice-client-gtk  spice-client-glib-usb-acl-helper  build-essential  g++ gcc-doc gcc valgrind gdb gdb-doc  bash-doc  minidjvu  djvubind djvulibre-bin  djvulibre-desktop djview4  evince atril qpdfview pdf2svg  pdf2djvu  a2ps html2ps html2text html2wml html-xml-utils  uuid-runtime simple-scan  pdfchain  libpcre3-dev sshfs archivemount squashfs-tools squashfs-tools-ng  zstd hplip-gui hplip-doc  hplip  openssl openvpn gnutls-bin  gnutls-doc  strace ltrace apt-file  command-not-found  bash-completion  geeqie gwenview xarchiver  file-roller  catfish libspice-client-gtk-3.0-5 libspice-client-glib-2.0-8 smplayer smplayer-l10n vlc mplayer pidgin gajim evolution geary  simple-ccsm  mc  valgrind  nmap nmapsi4 ldnsutils mtr-tiny gparted netcat-openbsd fdisk gdisk gnome-disk-utility gnome-system-tools gddrescue gsmartcontrol  vim artha  mc p7zip-full   grub-efi-amd64-bin  guvcview uvccapture v4l-conf v4l-utils  adb fastboot  openssh-server aria2 lftp  gftp gftp-gtk gftp-text filezilla rtorrent mktorrent ctorrent qbittorrent transmission transmission-cli transmission-gtk gucharmap mdf2iso  calc xscreensaver basez xchm kchmviewer  pmount jdupes cpufrequtils  tilda  okteta  basez  \
 adwaita-icon-theme adwaita-qt gnome-themes-extra  \
 manpages-ru nedit \
 lightdm-settings lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
 slick-greeter gnome-multi-writer xscreensaver \
  \
"

# only in debian 11 and LMDE5?
package_list_dlonly_dependencies_for_vbox_6_0_24_ubuntu_eoan="\
 libpython2-stdlib \
 libpython2.7-stdlib \
 libpython2.7-minimal \
 libqt5opengl5 \
 libqt5printsupport5 \
 libqt5x11extras5 \
 libsdl1.2debian \
 python-is-python2 \
 python2 \
 python2-minimal \
 python2.7 \
 python2.7-minimal \
 "

# absent in debian12: curlftpfs remmina-plugin-nx remmina-plugin-spice gip
package_list_dl_only=" \
 dte dav-text mle yudit  tea  bless \
 bind9 isc-dhcp-server uni2ascii unicode unifont-bin uniutils utf8gen utfcheck utfout zint zint-qt yudit yudit-doc youtube-dl yt-dlp ugrep teckit tcs numconv kcharselect \
 vsftpd minidlna samba \
 x11vnc remmina remmina-plugin-vnc  \
 remmina-plugin-secret remmina-plugin-rdp \
 directvnc gitso gnome-remote-desktop gvncviewer hydra hydra-gtk \
 krdc krfb ncrack patator ssvnc tigervnc-viewer tigervnc-standalone-server \
 tigervnc-scraping-server tigervnc-xorg-extension \
 tightvnc-java tightvncserver vinagre vino \
  virt-manager virt-viewer \
 vncsnapshot vtgrab \
 x11vnc x2vnc xpra xrdp xtightvncviewer \
 ipcalc ipcalc-ng ipqalc ipv6calc sipcalc subnetcalc  \
 kmplot sendip  asused qbrew tilem  \
 concalc calc  \
 x11-apps \
 ircd-ircu  \
 pagekite \
 vtun openvpn openssl gnutls-bin \
 openssh-sftp-server openssh-server \
 atftp atftpd cadaver  \
 dnsmasq erlang-tftp filezilla \
 ftpcopy  \
"

# absent in debian12: gatling tftpd 
package_list_dl_only_00="apache2 nginx bind9 isc-dhcp-server \
 openssh-server \
  ftpwatch  git-ftp  inetsim jftp \
 lftp mc mysecureshell netrw netcat-openbsd  \
 netwox netwox-doc \
    tor vsftpd \
 webdeploy webfs \
 weex wget curl wget2 wput \
 \
 x264 ffcvt obs-studio x265 libx265-doc \
 tnftp tftp yafc putty-tools pterm putty putty-doc  \
 ircd-irc2 \
 udfclient  \
 webcam webcamd  \
 sshfs archivemount  \
 jigdo-file \
 k4dirstat  \
 diod \
 x11-xkb-utils ldnsutils artha  \
 davfs2 \
 vorbis-tools dir2ogg  lltag mp3splt mp3splt-gtk normalize-audio \
 oggvideotools  pacpl \
 rygel \
 cifs-utils qweborf avfs  filetea fex  gvfs-backends \
 httpdirfs httpfs2 \
 integrit \
 info2www \
 hardlink \
 gocryptfs \
 obexftp \
 xfsprogs  \
 gdebi gdebi-core   \
 tmux tmuxinator tmuxp  screenie iselect byobu \
 filetea peony-share bindfs mate-user-share task-mate-desktop task-lxqt-desktop tilda \
 qweborf ncdc rtorrent \
 aria2 biglybt btcheck btfs buildtorrent deluge-gtk kget ktorrent mat2 mktorrent \
 qbittorrent qbittorrent-nox rhash unworkable  ctorrent \
 deluge deluge-console lftp rtorrent transmission transmission-cli transmission-gtk \
 transmission-qt \
 twatch  \
 "  # absent in debian12: bitstormlite  ffmpeg2theora 

# absent in debian12: shatag gnome-books xreader
package_list_dl_only_01="\
 biglybtd \
 dnstwist duperemove ed2k-hash fsverity git gperf caja-gtkhash hashcat hashcheck \
 hashdeep hashid hashrat hcxtools john gostsum extract \
 microdc2 mtree-netbsd tree nettle-bin gnutls-bin dhtnode patator \
 qcalcfilehash rhash rmlint rmlint-doc rmlint-gui  steghide steghide-doc \
 tpm-tools xxhash \
 gtkhash   \
 nemo-gtkhash \
 thunar-gtkhash \
 strace ltrace \
 encfs sirikali gocryptfs tomb  \
 epub-utils fbreader epubcheck flightcrew  mupdf mupdf-tools \
 okular-extra-backends pageedit pandoc sigil sisu  \
 abw2epub ebook2epub mwaw2epub pages2epub qxp2epub sd2epub wpd2epub wps2epub \
 zmf2epub xmlto bookworm \
 fbless fbreader pfb2t1c2pfb \
 qpdf pdfchain evince atril xpdf wv weasyprint qpdfview qpdfview-djvu-plugin \
 qpdfview-ps-plugin qpdfview-translations \
 page-crunch okular okular-mobile \
 katarakt \
 gscan2pdf img2pdf  \
 apg \
 apt-doc apt-offline apt-offline-gui \
 ninja-build meson \
 " # dc3dd? rkhunter? samdump2?

# absent in debian12: pagetools kmplayer mppenc nemo-filename-repairer drawtiming
package_list_dl_only_02="\
 apt-build apt-move apt-rdepends \
 gnome-system-tools gddrescue gnome-disk-utility gsmartcontrol \
 grub-pc grub-efi-amd64-bin  smb4k smbclient cifs-utils \
 bochs bochsbios \
 sane sane-utils xsane unpaper skanlite simple-scan scanbd gscan2pdf \
 pdfsandwich pct-scanner-scripts  \
 psrip \
 qtqr qreator qrencode wifi-qr zbar-tools zbarcam-qt zbarcam-gtk \
 gdebi \
 ree \
 rmlint rmlint-doc rmlint-gui \
 symlinks \
 testdisk diskscan baobab  \
 caribou \
 sslscan \
 guvcview uvccapture uvcdynctrl \
 dov4l dv4l fswebcam  vlc megapixels motion qv4l2 yavta \
 v4l-conf v4l-utils \
 vgrabbj \
 ustreamer  \
 netpbm libpcre3-dev \
 netcat-openbsd \
 attr xattr \
 qt5ct base58 x264 x265 mkvtoolnix mkvtoolnix-gui basez \
 vorbis-tools opus-tools flac lame lame-doc speex sharutils renameutils \
 musepack-tools  mencoder guetzli flake faac aac-enc \
 png2html paps  \
 pcmanfm  lv detox convmv \
 4pane caja fdclone doublecmd-gtk krusader lfm mc nnn peony \
 spacefm  vfu xfe ytree  \
 filezilla  uget wget2  \
 elinks links2 lynx konqueror \
 file-roller \
 cargo \
 gnumeric abiword  \
 keepass2 keepass2-doc kpcli  \
 patool \
 blktool barrier blkreplay blkreplay-examples cpuinfo cutecom dash \
 ddupdate discover dmidecode   \
 efibootguard eviacam facter fake-hwclock fancontrol fssync rclone \
 hardinfo helpdev hw-probe hwb hwdata hwinfo  hwloc-nox \
 isenkram inxi  \
 indicator-sensors ioport isenkram-cli \
 iw net-tools light linux-cpupower lm-sensors \
 lmbench lshw lshw-gtk macchanger ifrename \
 makedev mbmon mbw msr-tools osinfo-db osinfo-db-tools \
 pavucontrol procinfo psensor radeontool radeontop \
 scsitools lsscsi sosreport tiptop tpm-tools tpm-tools-pkcs11 tpm2-tools \
 update-glx videogen volume-key watchdog wavemon monit winregfs x11-utils \
 x11-xserver-utils xbase-clients xmbmon xsensors xvfb xvkbd \
 debootstrap \
 scrypt \
 cargo rustc rust-doc rust-gdb rust-src \
 alien cpuidtool cpuid cpuinfo  \
 htmldoc jo jq  linuxinfo  \
 nmon pdns-recursor power-calibrate procmail pup qemu-guest-agent \
 qemu-utils qemu-system-x86 rawtherapee sysstat \
 tardy  \
 spice-vdagent \
 mpv \
 approx  apt-listchanges apt-move apt-utils backuppc cupt daptup \
 debarchiver devscripts dput local-apt-repository mini-dinstall \
 reprepro apt-cacher apt-cacher-ng apt-doc   apt-file apt-forktracer  \
 apt-listbugs  apt-listchanges apt-listdifferences apt-mirror \
 apt-move apt-offline apt-offline-gui apt-rdepends apt-show-source \
 apt-show-versions apt-src apt-transport-https apt-transport-in-toto \
 apt-transport-s3 apt-transport-tor apt-utils apt-venv apt-xapian-index \
 aptfs aptitude aptitude-doc-ru aptitude-doc-en aptitude-robot \
 aptly aptly-api aptly-publisher  auto-apt-proxy  \
 autokey-gtk autokey-qt \
 dbus-x11 dbus-user-session \
 " # absent in debian12: apt-dpkg-ref aptdaemon apturl

 # add: lbzip2 pigz plzip 
 #?:  drbd-utils drbd-doc drbd-doc drbd-utils
 # hwloc conflicts with hwloc-nox

package_list_dl_only_03="inetutils-ftpd ngircd   tftp-hpa tftpd-hpa ksmbd-tools "

package_list_dl_only_04="ftpd-ssl"

package_list_dl_only_05_ignored=""

# absent in debian12: twoftpd twoftpd-run memtest86+=6.10-2~bpo11+1
package_list_dl_only_1by1="gesftpserver pure-ftpd  proftpd-core proftpd-doc ftpd \
   memtest86+   "





cp -lnv /var/cache/apt/custom_save/root/var/cache/apt/archives/*.deb /var/cache/apt/archives/ 
sync
echo sync DONE

if test "$1" = "install" ; then
 apt install   ${package_list} || custom_error_exit 3
 sync
 echo sync DONE
 cp -lnv /var/cache/apt/archives/*.deb /var/cache/apt/custom_save/root/var/cache/apt/archives/
 sync
 echo sync DONE. All DONE OK \(seems so\). exit
 exit 0
else
 if test "$1" = "reinstall" ; then
  echo DANGER. Abort. Fix this script if you want this.
  echo script full name: "$(realpath "$0")"
  #sync
  #echo sync DONE
  exit 1
  #apt reinstall   ${package_list}
 else
  if test "$1" = "dlinstall" ; then # only download installation list 
   apt install --download-only --yes  ${package_list} || custom_error_exit 8
   sync
   echo sync DONE
   cp -lnv /var/cache/apt/archives/*.deb /var/cache/apt/custom_save/root/var/cache/apt/archives/
   sync
   #echo sync DONE
   echo sync DONE. All DONE OK \(seems so\). exit
   exit 0
  else
     #apt install --download-only  --yes  ${package_list}
   apt install --download-only --yes  ${package_list} || custom_error_exit 12
   apt dist-upgrade --download-only  --yes  ${package_list} || custom_error_exit 4
   apt reinstall --download-only  --assume-yes  $(apt-mark showinstall) || custom_error_exit 5
   echo reinstall download done. Pause 4 seconds...
   sleep 4
   apt install --download-only --yes  ${package_list_dl_only} || custom_error_exit 1
   apt install --download-only --yes  ${package_list_dl_only_00} || custom_error_exit 6
   apt install --download-only --yes  ${package_list_dl_only_01} || custom_error_exit 7
   apt install --download-only --yes  ${package_list_dl_only_02} || custom_error_exit 9


   apt install --download-only --yes  ${package_list_dl_only_03} || custom_error_exit 10

   apt install --download-only --yes  ${package_list_dl_only_04} || custom_error_exit 11

   for pkgname in $package_list_dl_only_1by1 ; do
    if apt install --download-only --yes  ${pkgname} ; then
     echo \ \  \"$pkgname\": OK downloading it and it\'s dependencies
    else
     echo -n failed to download package \"$pkgname\". SKIPPING. Pause 4 seconds...
     sleep 4
     echo continuing
    fi
   done


   ##### some of them are absent in debian 12:
   ##apt install --download-only --yes   ${package_list_dlonly_dependencies_for_vbox_6_0_24_ubuntu_eoan} || custom_error_exit 2

#   exit_code="$?"
#   echo \$\?="$exit_code"

   cp -lnv /var/cache/apt/archives/*.deb /var/cache/apt/custom_save/root/var/cache/apt/archives/
   sync
   echo sync DONE. All DONE OK \(seems so\). exit
   exit 0
  fi
 fi
fi

