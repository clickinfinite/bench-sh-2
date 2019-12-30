#!/bin/bash
#####################################################################
# Benchmark Script 2 by Hidden Refuge from FreeVPS                  #
# Copyright(C) 2015 - 2019 by Hidden Refuge                         #
# Github: https://github.com/hidden-refuge/bench-sh-2               #
#####################################################################
# Original script by akamaras/camarg                                #
# Original: http://www.akamaras.com/linux/linux-server-info-script/ #
# Original Copyright (C) 2011 by akamaras/camarg                    #
#####################################################################
# The speed test was added by dmmcintyre3 from FreeVPS.us as a      #
# modification to the original script.                              #
# Modded Script: https://freevps.us/thread-2252.html                # 
# Copyright (C) 2011 by dmmcintyre3 for the modification            #
#####################################################################
sysinfo () {
	# Removing existing bench.log
	rm -rf $HOME/bench.log
	# Reading out system information...
	# Reading CPU model
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading amount of CPU cores
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	# Reading CPU frequency in MHz
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading total memory in MB
	tram=$( free -m | awk 'NR==2 {print $2}' )
	# Reading Swap in MB
	vram=$( free -m | awk 'NR==3 {print $2}' )
	# Reading system uptime
	up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading operating system and version (simple, didn't filter the strings at the end...)
	opsy=$( cat /etc/os-release | grep PRETTY_NAME | tr -d '"' | sed -e "s/^PRETTY_NAME=//" )  # Operating System & Version
	arch=$( uname -m ) # Architecture
	lbit=$( getconf LONG_BIT ) # Architecture in Bit
	hn=$( hostname ) # Hostname
	kern=$( uname -r )
	# Date of benchmark
	bdates=$( date )
	echo "Benchmark started on $bdates" | tee -a $HOME/bench.log
	echo "Full benchmark log: $HOME/bench.log" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Output of results
	echo "System Info" | tee -a $HOME/bench.log
	echo "-----------" | tee -a $HOME/bench.log
	echo "Processor	: $cname" | tee -a $HOME/bench.log
	echo "CPU Cores	: $cores" | tee -a $HOME/bench.log
	echo "Frequency	: $freq MHz" | tee -a $HOME/bench.log
	echo "Memory		: $tram MB" | tee -a $HOME/bench.log
	echo "Swap		: $vram MB" | tee -a $HOME/bench.log
	echo "Uptime		: $up" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "OS		: $opsy" | tee -a $HOME/bench.log
	echo "Arch		: $arch ($lbit Bit)" | tee -a $HOME/bench.log
	echo "Kernel		: $kern" | tee -a $HOME/bench.log
	echo "Hostname	: $hn" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
speedtest4 () {
	ipiv=$( wget -qO- ipv4.icanhazip.com ) # Getting IPv4
	# Speed test via wget for IPv4 only with 10x 100 MB files. 1 GB bandwidth will be used!
	echo "Speedtest (IPv4 only)" | tee -a $HOME/bench.log
	echo "---------------------" | tee -a $HOME/bench.log
	echo "Your public IPv4 is $ipiv" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Cachefly CDN speed test
	echo "Location		Provider	Speed		Latency" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Global" | tee -a $HOME/bench.log
	cachefly=$( wget -4 -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	cacheflyp=$( ping cachefly.cachefly.net -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "CDN			Cachefly	$cachefly	$cacheflyp" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "United States" | tee -a $HOME/bench.log
	# United States speed test
	coloatatl=$( wget -4 -O /dev/null http://speed.atl.coloat.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	coloatatlp=$( ping speed.atl.coloat.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Atlanta, GA, US		Coloat		$coloatatl 	$coloatatlp" | tee -a $HOME/bench.log
	sldltx=$( wget -4 -O /dev/null http://speedtest.dal05.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	sldltxp=$( ping speedtest.dal05.softlayer.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Dallas, TX, US		Softlayer	$sldltx 	$sldltxp" | tee -a $HOME/bench.log
	slwa=$( wget -4 -O /dev/null http://speedtest.sea01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	slwap=$( ping speedtest.sea01.softlayer.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Seattle, WA, US		Softlayer	$slwa 	$slwap" | tee -a $HOME/bench.log
	slsjc=$( wget -4 -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	slsjcp=$( ping speedtest.sjc01.softlayer.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "San Jose, CA, US	Softlayer	$slsjc	$slsjcp" | tee -a $HOME/bench.log
	slwdc=$( wget -4 -O /dev/null http://mirror.wdc1.us.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	slwdcp=$( ping mirror.wdc1.us.leaseweb.net -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Washington, DC, US	Leaseweb 	$slwdc 	$slwdcp" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Asia" | tee -a $HOME/bench.log
	# Asia speed test
	linodejp=$( wget -4 -O /dev/null http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	linodejpp=$( ping speedtest.tokyo2.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Tokyo, Japan		Linode		$linodejp	$linodejpp" | tee -a $HOME/bench.log
	slsg=$( wget -4 -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	slsgp=$( ping speedtest.sng01.softlayer.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Singapore 		Softlayer	$slsg	$slsgp" | tee -a $HOME/bench.log
	hitw=$( wget -4 -O /dev/null http://tpdb.speed2.hinet.net/test_100m.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' ) 
	hitwp=$( ping tpdb.speed2.hinet.net -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Taiwan                  Hinet           $hitw	$hitwp" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Europe" | tee -a $HOME/bench.log
	# Europe speed test
	i3d=$( wget -4 -O /dev/null http://mirror.i3d.net/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	i3dp=$( ping mirror.i3d.net -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Rotterdam, Netherlands	id3.net		$i3d	$i3dp" | tee -a $HOME/bench.log
	leaseweb=$( wget -4 -O /dev/null http://mirror.leaseweb.com/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	leasewebp=$( ping mirror.leaseweb.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Haarlem, Netherlands	Leaseweb	$leaseweb	$leasewebp" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
speedtest6 () {
	ipvii=$( wget -qO- ipv6.icanhazip.com ) # Getting IPv6
  	# Speed test via wget for IPv6 only with 10x 100 MB files. 1 GB bandwidth will be used! No CDN - Cachefly not IPv6 ready...
  	echo "Speedtest (IPv6 only)" | tee -a $HOME/bench.log
  	echo "---------------------" | tee -a $HOME/bench.log
  	echo "Your public IPv6 is $ipvii" | tee -a $HOME/bench.log
  	echo "" | tee -a $HOME/bench.log
  	echo "Location		Provider	Speed		Latency" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "United States" | tee -a $HOME/bench.log
  	# United States speed test
	v6atl=$( wget -6 -O /dev/null http://[2602:fff6:3::4:4]/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	v6atlp=$( ping6 2602:fff6:3::4:4 -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Atlanta, GA, US		QuadraNET	$v6atl	$v6atlp" | tee -a $HOME/bench.log
  	v6dal=$( wget -6 -O /dev/null http://speedtest.dallas.linode.com/100MB-dallas.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	v6dalp=$( ping6 speedtest.dallas.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Dallas, TX, US		Linode		$v6dal	$v6dalp" | tee -a $HOME/bench.log
  	v6new=$( wget -6 -O /dev/null http://speedtest.newark.linode.com/100MB-newark.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	v6newp=$( ping6 speedtest.newark.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Newark, NJ, US		Linode	 	$v6new	$v6newp" | tee -a $HOME/bench.log
	v6fre=$( wget -6 -O /dev/null http://speedtest.fremont.linode.com/100MB-fremont.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	v6frep=$( ping6 speedtest.fremont.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Fremont, CA, US		Linode	 	$v6fre	$v6frep" | tee -a $HOME/bench.log
  	v6chi=$( wget -6 -O /dev/null http://testfile.chi.steadfast.net/data.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	v6chip=$( ping6 testfile.chi.steadfast.net -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Chicago, IL, US		Steadfast	$v6chi	$v6chip" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Asia" | tee -a $HOME/bench.log
	# Asia speed test
  	v6tok=$( wget -6 -O /dev/null http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	v6tokp=$( ping6 speedtest.tokyo2.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Tokyo, Japan		Linode	 	$v6tok	$v6tokp" | tee -a $HOME/bench.log
  	v6sin=$( wget -6 -O /dev/null http://speedtest.singapore.linode.com/100MB-singapore.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	v6sinp=$( ping6 speedtest.singapore.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Singapore		Linode		$v6sin	$v6sinp" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Europe" | tee -a $HOME/bench.log
	# Europe speed test
	v6fra=$( wget -6 -O /dev/null http://speedtest.frankfurt.linode.com/100MB-frankfurt.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	v6frap=$( ping6 speedtest.frankfurt.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Frankfurt, Germany	Linode		$v6fra	$v6frap" | tee -a $HOME/bench.log
        v6lon=$( wget -6 -O /dev/null http://speedtest.london.linode.com/100MB-london.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	v6lonp=$( ping6 speedtest.london.linode.com -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "London, UK		Linode		$v6lon	$v6lonp" | tee -a $HOME/bench.log
        v6har=$( wget -6 -O /dev/null http://mirror.nl.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        v6harp=$( ping6 mirror.nl.leaseweb.net -c 4 | awk -F\/ '/rtt/ {print $5}' )
	echo "Haarlem, Netherlands	Leaseweb	$v6har	$v6harp" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
iotest () {
	command -v bc >/dev/null 2>&1 || { echo >&2 "The I/O benchmark requires bc but it's not installed. Please install bc and repeat. Aborting..."; exit 1; }
	echo "Disk Speed" | tee -a $HOME/bench.log
	echo "----------" | tee -a $HOME/bench.log
	# Measuring disk speed with DD
	io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# I/O without units for calculation (better approach with awk for non int values)
	ioraw=$( echo $io | awk 'NR==1 {print $1}' )
	ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
	ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
	# Converting possible GB/s results to MB/s value for proper calculation afterwards
	iounit=$( echo $io | awk 'NR==1 {print $2}' )
	iounit2=$( echo $io2 | awk 'NR==1 {print $2}' )
	iounit3=$( echo $io3 | awk 'NR==1 {print $2}' )
	# Converting 1st benchmark run
	if [ "$iounit" == "GB/s" ]
	then
        	ioconv=$( bc -l <<<"($ioraw * 1000)" )
        	ioconv=$( echo ${ioconv%.*} )
	else
        	ioconv=$ioraw
	fi
	# Converting 2nd benchmark run
	if [ "$iounit2" == "GB/s" ]
	then
        	ioconv2=$( bc -l <<<"($ioraw2 * 1000)" )
        	ioconv2=$( echo ${ioconv2%.*} ) 
	else
        	ioconv2=$ioraw2
	fi
	# Converting 3rd benchmark run
	if [ "$iounit3" == "GB/s" ]
	then
        	ioconv3=$( bc -l <<<"($ioraw3 * 1000)" )
        	ioconv3=$( echo ${ioconv3%.*} )
	else
        	ioconv3=$ioraw3
	fi
	# Calculating all IO results and avg IO
	ioall=$( awk 'BEGIN{print '$ioconv' + '$ioconv2' + '$ioconv3'}' )
	ioall=$( echo ${ioall%.*} )
	ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
	ioavg=$( echo ${ioavg%.*} )
	ioavggbs=$( echo "scale=2; $ioavg/1000" | bc )
	# Output of DD result
	echo "I/O (1st run)	: $io" | tee -a $HOME/bench.log
	echo "I/O (2nd run)	: $io2" | tee -a $HOME/bench.log
	echo "I/O (3rd run)	: $io3" | tee -a $HOME/bench.log
	echo "Average I/O	: $ioavg MB/s or $ioavggbs GB/s" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
hlp () {
	echo ""
	echo "(C) Bench.sh 2 by Hidden Refuge <me at hiddenrefuge got eu dot org>"
	echo ""
	echo "Usage: bench.sh <option>"
	echo ""
	echo "Available options:"
	echo "No option	: System information, IPv4 only speedtest and disk speed benchmark will be run."
	echo "-sys		: Displays system information such as CPU, amount CPU cores, RAM and more."
	echo "-io		: Runs a disk speedtest and displays the results."
	echo "-6		: System information, IPv6 only speedtest and disk speed benchmark will be run."
	echo "-46 or -64	: System information, IPv4 and IPv6 speedtest and disk speed benchmark will be run."
	echo "-h or ?		: Help page."
	echo ""
}
case $1 in
	'-sys')
		sysinfo;;
	'-io')
		iotest;;
	'-6')
		sysinfo; speedtest6; iotest;;
	'-46')
		sysinfo; speedtest4; speedtest6; iotest;;
	'-64')
		sysinfo; speedtest4; speedtest6; iotest;;
	'-h')
		hlp;;
	'?')
		hlp;;
	*)
		sysinfo; speedtest4; iotest;;
esac
#################################################################################
# Contributors:									#
# thirthy_speed https://freevps.us/thread-16943-post-191398.html#pid191398 	#
#################################################################################
