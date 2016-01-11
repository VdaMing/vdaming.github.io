title: 搭建802.1x测试环境
date: 2015-10-21 21:45:27
categories: Tool
tags: [Freeradius] 
---
# **起因**
最近公司开发新功能，要用到802.1x的认证环境，所以从网上搜了一堆的教程，使用freeradius测试802.1x 的EAP_SIM 认证，下面记录一下。

# **802.1x,EAP**
WLAN 中的WPA-Enterprise，WPA2-Enterprise，802.1x认证都是使用了802.1x认证协议，需要radius server完成认证，授权，计费的功能，拓扑图如下
STA->AP->radiusServer, 当然server可以是在AP的lan端，也可以上架设在公网上使用。具体的认证使用了EAP的认证方法，包含EAP_PEAP, EAP_MD5, EAP_TLS, EAP_TTLS, EAP_SIM, EAP_AKA, EAP_AKA'等方法。

# **安装和配置freeradius**
Freeradius 是一款开源的radius server 软件，安装和配置起来都挺方便的。
## **安装Freeradius**
我使用的机器是ubuntu 14.04LTS 版本，可以直接使用APT-GET 命令安装，让ubuntu自动安装所需的软件和依赖，能使用的最新版本是2.1.12.
```
vdaming@vdaming-Lenovo-ubuntu:~$ sudo apt-get install freeradius
正在读取软件包列表... 完成
正在分析软件包的依赖关系树       
正在读取状态信息... 完成       
下列软件包是自动安装的并且现在不需要了：
  hyphen-en-us libreoffice-help-en-gb libreoffice-help-en-us
  libreoffice-help-zh-cn libreoffice-l10n-en-gb libreoffice-l10n-en-za
  libreoffice-l10n-zh-cn mythes-en-au openoffice.org-hyphenation
Use 'apt-get autoremove' to remove them.
将会安装下列额外的软件包：
  freeradius-common freeradius-utils libfreeradius2
建议安装的软件包：
  freeradius-ldap freeradius-postgresql freeradius-mysql freeradius-krb5
下列【新】软件包将被安装：
  freeradius freeradius-common freeradius-utils libfreeradius2
升级了 0 个软件包，新安装了 4 个软件包，要卸载 0 个软件包，有 1 个软件包未被升级。
需要下载 0 B/813 kB 的软件包。
解压缩后会消耗掉 3,254 kB 的额外空间。
您希望继续执行吗？ [Y/n] y
```
安装以后，freeradius是被当作service启动的，配置文件主要在/etc/freeradius/目录下。
## **配置freeradius**
在/etc/freeradius/目录下是所有的配置文件，我们主要改动的是eap.conf,clients.conf,users 文件
### **添加新用户**
```
vdaming@vdaming-Lenovo-ubuntu:/etc/freeradius$ sudo vim users
加入以下字段是给MD5，PEAP的认证添加vic用户，密码是1234
"vic"    Cleartext-Password := "1234"
         Reply-Message = "Hello, %{User-Name}"

加入以下字段是给EAP_SIM 添加sim triplets信息
"1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org" EAP-Type:=SIM
        EAP-Sim-Rand1 = 0x11111111111111111111111111111111,
        EAP-Sim-SRES1 = 0x11223344,
        EAP-Sim-KC1 = 0x1122334455667788,
        EAP-Sim-Rand2 = 0x22222222222222222222222222222222,
        EAP-Sim-SRES2 = 0x55667788,
        EAP-Sim-KC2 = 0x8877665544332211,
        EAP-Sim-Rand3 = 0x33333333333333333333333333333333,
        EAP-Sim-SRES3 = 0x11335577,
        EAP-Sim-KC3 = 0x2233445566778899
```

对于eap_sim的sim卡信息需要根据不同的SIM卡生成出来，搞一个SIM卡的读卡器，使用软件[agsim](http://agsm.sourceforge.net/download.html)生成3组值添加到users文件即可，用户名的话是IMSI加上对应的后缀，后缀中的mnc001, mcc460, 是取了IMSI的钱5位分割出来的。

### **添加允许radius client ip地址**
这个要编辑文件clients.conf
```
vdaming@vdaming-Lenovo-ubuntu:/etc/freeradius$ sudo vim clients.conf
添加如下字段，是通过192.168网段的所有client，密钥是1234, 这个密钥就是AP上要填写的radius key。
client 192.168.0.0/16 {
        secret          = 1234
        shortname       = private-network-2
}

```

### **添加EAP_SIM的支持**
这个要更改eap.conf
```
vdaming@vdaming-Lenovo-ubuntu:/etc/freeradius$ sudo vim eap.conf
在md5{}后添加如下字段即可。
sim {}
```
<!--more-->
### **测试改动是否OK**
使用freeradius的测试命令来模拟一个客户端给server发送EAP-REQUEST, 检查server是否能正常回复。
```
先要重启一下freeradius service 让配置的改动生效，或者是把当前的freeradius service先top掉，再手动启动freeradius带上-X的参数打开所有的debug信息。

vdaming@vdaming-Lenovo-ubuntu:/etc/freeradius$ sudo service freeradius stop
freeradius stop/waiting
vdaming@vdaming-Lenovo-ubuntu:/etc/freeradius$ sudo freeradius -X
FreeRADIUS Version 2.1.12, for host i686-pc-linux-gnu, built on Aug 26 2015 at 14:47:37
Copyright (C) 1999-2009 The FreeRADIUS server project and contributors. 
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. 
You may redistribute copies of FreeRADIUS under the terms of the 
GNU General Public License v2. 
Starting - reading configuration files ...
including configuration file /etc/freeradius/radiusd.conf
including configuration file /etc/freeradius/proxy.conf
including configuration file /etc/freeradius/clients.conf
including files in directory /etc/freeradius/modules/
including configuration file /etc/freeradius/modules/always
including configuration file /etc/freeradius/modules/krb5
including configuration file /etc/freeradius/modules/perl
including configuration file /etc/freeradius/modules/otp
including configuration file /etc/freeradius/modules/ldap
including configuration file /etc/freeradius/modules/files
including configuration file /etc/freeradius/modules/rediswho
including configuration file /etc/freeradius/modules/acct_unique
including configuration file /etc/freeradius/modules/unix
including configuration file /etc/freeradius/modules/pam
including configuration file /etc/freeradius/modules/mac2ip
including configuration file /etc/freeradius/modules/cui
including configuration file /etc/freeradius/modules/smsotp
including configuration file /etc/freeradius/modules/wimax
including configuration file /etc/freeradius/modules/counter
including configuration file /etc/freeradius/modules/linelog
including configuration file /etc/freeradius/modules/mac2vlan
including configuration file /etc/freeradius/modules/sqlcounter_expire_on_login
including configuration file /etc/freeradius/modules/exec
including configuration file /etc/freeradius/modules/pap
including configuration file /etc/freeradius/modules/detail.example.com
including configuration file /etc/freeradius/modules/detail.log
including configuration file /etc/freeradius/modules/inner-eap
including configuration file /etc/freeradius/modules/preprocess
including configuration file /etc/freeradius/modules/echo
including configuration file /etc/freeradius/modules/detail
including configuration file /etc/freeradius/modules/replicate
including configuration file /etc/freeradius/modules/passwd
including configuration file /etc/freeradius/modules/sql_log
including configuration file /etc/freeradius/modules/logintime
including configuration file /etc/freeradius/modules/checkval
including configuration file /etc/freeradius/modules/expr
including configuration file /etc/freeradius/modules/policy
including configuration file /etc/freeradius/modules/attr_filter
including configuration file /etc/freeradius/modules/sradutmp
including configuration file /etc/freeradius/modules/dynamic_clients
including configuration file /etc/freeradius/modules/digest
including configuration file /etc/freeradius/modules/attr_rewrite
including configuration file /etc/freeradius/modules/realm
including configuration file /etc/freeradius/modules/chap
including configuration file /etc/freeradius/modules/radutmp
including configuration file /etc/freeradius/modules/opendirectory
including configuration file /etc/freeradius/modules/etc_group
including configuration file /etc/freeradius/modules/soh
including configuration file /etc/freeradius/modules/expiration
including configuration file /etc/freeradius/modules/ippool
including configuration file /etc/freeradius/modules/redis
including configuration file /etc/freeradius/modules/ntlm_auth
including configuration file /etc/freeradius/modules/smbpasswd
including configuration file /etc/freeradius/modules/mschap
including configuration file /etc/freeradius/eap.conf
including configuration file /etc/freeradius/policy.conf
including files in directory /etc/freeradius/sites-enabled/
including configuration file /etc/freeradius/sites-enabled/inner-tunnel
including configuration file /etc/freeradius/sites-enabled/default
main {
	user = "freerad"
	group = "freerad"
	allow_core_dumps = no
}
including dictionary file /etc/freeradius/dictionary
main {
	name = "freeradius"
	prefix = "/usr"
	localstatedir = "/var"
	sbindir = "/usr/sbin"
	logdir = "/var/log/freeradius"
	run_dir = "/var/run/freeradius"
	libdir = "/usr/lib/freeradius"
	radacctdir = "/var/log/freeradius/radacct"
	hostname_lookups = no
	max_request_time = 30
	cleanup_delay = 5
	max_requests = 1024
	pidfile = "/var/run/freeradius/freeradius.pid"
	checkrad = "/usr/sbin/checkrad"
	debug_level = 0
	proxy_requests = yes
 log {
	stripped_names = no
	auth = no
	auth_badpass = no
	auth_goodpass = no
 }
 security {
	max_attributes = 200
	reject_delay = 1
	status_server = yes
 }
}
radiusd: #### Loading Realms and Home Servers ####
 proxy server {
	retry_delay = 5
	retry_count = 3
	default_fallback = no
	dead_time = 120
	wake_all_if_all_dead = no
 }
 home_server localhost {
	ipaddr = 127.0.0.1
	port = 1812
	type = "auth"
	secret = "testing123"
	response_window = 20
	max_outstanding = 65536
	require_message_authenticator = yes
	zombie_period = 40
	status_check = "status-server"
	ping_interval = 30
	check_interval = 30
	num_answers_to_alive = 3
	num_pings_to_alive = 3
	revive_interval = 120
	status_check_timeout = 4
  coa {
	irt = 2
	mrt = 16
	mrc = 5
	mrd = 30
  }
 }
 home_server_pool my_auth_failover {
	type = fail-over
	home_server = localhost
 }
 realm example.com {
	auth_pool = my_auth_failover
 }
 realm LOCAL {
 }
radiusd: #### Loading Clients ####
 client localhost {
	ipaddr = 127.0.0.1
	require_message_authenticator = no
	secret = "testing123"
	nastype = "other"
 }
 client 192.168.0.0/16 {
	require_message_authenticator = no
	secret = "1234"
	shortname = "private-network-2"
 }
radiusd: #### Instantiating modules ####
 instantiate {
 Module: Linked to module rlm_exec
 Module: Instantiating module "exec" from file /etc/freeradius/modules/exec
  exec {
	wait = no
	input_pairs = "request"
	shell_escape = yes
  }
 Module: Linked to module rlm_expr
 Module: Instantiating module "expr" from file /etc/freeradius/modules/expr
 Module: Linked to module rlm_expiration
 Module: Instantiating module "expiration" from file /etc/freeradius/modules/expiration
  expiration {
	reply-message = "Password Has Expired  "
  }
 Module: Linked to module rlm_logintime
 Module: Instantiating module "logintime" from file /etc/freeradius/modules/logintime
  logintime {
	reply-message = "You are calling outside your allowed timespan  "
	minimum-timeout = 60
  }
 }
radiusd: #### Loading Virtual Servers ####
server { # from file /etc/freeradius/radiusd.conf
 modules {
  Module: Creating Auth-Type = digest
  Module: Creating Post-Auth-Type = REJECT
 Module: Checking authenticate {...} for more modules to load
 Module: Linked to module rlm_pap
 Module: Instantiating module "pap" from file /etc/freeradius/modules/pap
  pap {
	encryption_scheme = "auto"
	auto_header = no
  }
 Module: Linked to module rlm_chap
 Module: Instantiating module "chap" from file /etc/freeradius/modules/chap
 Module: Linked to module rlm_mschap
 Module: Instantiating module "mschap" from file /etc/freeradius/modules/mschap
  mschap {
	use_mppe = yes
	require_encryption = no
	require_strong = no
	with_ntdomain_hack = no
	allow_retry = yes
  }
 Module: Linked to module rlm_digest
 Module: Instantiating module "digest" from file /etc/freeradius/modules/digest
 Module: Linked to module rlm_unix
 Module: Instantiating module "unix" from file /etc/freeradius/modules/unix
  unix {
	radwtmp = "/var/log/freeradius/radwtmp"
  }
 Module: Linked to module rlm_eap
 Module: Instantiating module "eap" from file /etc/freeradius/eap.conf
  eap {
	default_eap_type = "md5"
	timer_expire = 60
	ignore_unknown_eap_types = no
	cisco_accounting_username_bug = no
	max_sessions = 4096
  }
 Module: Linked to sub-module rlm_eap_md5
 Module: Instantiating eap-md5
 Module: Linked to sub-module rlm_eap_sim
 Module: Instantiating eap-sim
 Module: Linked to sub-module rlm_eap_leap
 Module: Instantiating eap-leap
 Module: Linked to sub-module rlm_eap_gtc
 Module: Instantiating eap-gtc
   gtc {
	challenge = "Password: "
	auth_type = "PAP"
   }
 Module: Linked to sub-module rlm_eap_tls
 Module: Instantiating eap-tls
   tls {
	rsa_key_exchange = no
	dh_key_exchange = yes
	rsa_key_length = 512
	dh_key_length = 512
	verify_depth = 0
	CA_path = "/etc/freeradius/certs"
	pem_file_type = yes
	private_key_file = "/etc/freeradius/certs/server.key"
	certificate_file = "/etc/freeradius/certs/server.pem"
	CA_file = "/etc/freeradius/certs/ca.pem"
	private_key_password = "whatever"
	dh_file = "/etc/freeradius/certs/dh"
	random_file = "/dev/urandom"
	fragment_size = 1024
	include_length = yes
	check_crl = no
	cipher_list = "DEFAULT"
	make_cert_command = "/etc/freeradius/certs/bootstrap"
	ecdh_curve = "prime256v1"
    cache {
	enable = no
	lifetime = 24
	max_entries = 255
    }
    verify {
    }
    ocsp {
	enable = no
	override_cert_url = yes
	url = "http://127.0.0.1/ocsp/"
    }
   }
 Module: Linked to sub-module rlm_eap_ttls
 Module: Instantiating eap-ttls
   ttls {
	default_eap_type = "md5"
	copy_request_to_tunnel = no
	use_tunneled_reply = no
	virtual_server = "inner-tunnel"
	include_length = yes
   }
 Module: Linked to sub-module rlm_eap_peap
 Module: Instantiating eap-peap
   peap {
	default_eap_type = "mschapv2"
	copy_request_to_tunnel = no
	use_tunneled_reply = no
	proxy_tunneled_request_as_eap = yes
	virtual_server = "inner-tunnel"
	soh = no
   }
 Module: Linked to sub-module rlm_eap_mschapv2
 Module: Instantiating eap-mschapv2
   mschapv2 {
	with_ntdomain_hack = no
	send_error = no
   }
 Module: Checking authorize {...} for more modules to load
 Module: Linked to module rlm_preprocess
 Module: Instantiating module "preprocess" from file /etc/freeradius/modules/preprocess
  preprocess {
	huntgroups = "/etc/freeradius/huntgroups"
	hints = "/etc/freeradius/hints"
	with_ascend_hack = no
	ascend_channels_per_line = 23
	with_ntdomain_hack = no
	with_specialix_jetstream_hack = no
	with_cisco_vsa_hack = no
	with_alvarion_vsa_hack = no
  }
 Module: Linked to module rlm_realm
 Module: Instantiating module "suffix" from file /etc/freeradius/modules/realm
  realm suffix {
	format = "suffix"
	delimiter = "@"
	ignore_default = no
	ignore_null = no
  }
 Module: Linked to module rlm_files
 Module: Instantiating module "files" from file /etc/freeradius/modules/files
  files {
	usersfile = "/etc/freeradius/users"
	acctusersfile = "/etc/freeradius/acct_users"
	preproxy_usersfile = "/etc/freeradius/preproxy_users"
	compat = "no"
  }
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-Rand1" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-SRES1" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-KC1" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-Rand2" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-SRES2" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-KC2" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-Rand3" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-SRES3" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:203 WARNING! Check item "EAP-Sim-KC3" 	found in reply item list for user "1460022515241423@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-Rand1" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-SRES1" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-KC1" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-Rand2" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-SRES2" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-KC2" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-Rand3" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-SRES3" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:206 WARNING! Check item "EAP-Sim-KC3" 	found in reply item list for user "1460029518819922@wlan.mnc002.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-Rand1" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-SRES1" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-KC1" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-Rand2" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-SRES2" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-KC2" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-Rand3" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-SRES3" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
[/etc/freeradius/users]:209 WARNING! Check item "EAP-Sim-KC3" 	found in reply item list for user "1460012461077202@wlan.mnc001.mcc460.3gppnetwork.org". 	This attribute MUST go on the first line with the other check items
 Module: Checking preacct {...} for more modules to load
 Module: Linked to module rlm_acct_unique
 Module: Instantiating module "acct_unique" from file /etc/freeradius/modules/acct_unique
  acct_unique {
	key = "User-Name, Acct-Session-Id, NAS-IP-Address, Client-IP-Address, NAS-Port"
  }
 Module: Checking accounting {...} for more modules to load
 Module: Linked to module rlm_detail
 Module: Instantiating module "detail" from file /etc/freeradius/modules/detail
  detail {
	detailfile = "/var/log/freeradius/radacct/%{%{Packet-Src-IP-Address}:-%{Packet-Src-IPv6-Address}}/detail-%Y%m%d"
	header = "%t"
	detailperm = 384
	dirperm = 493
	locking = no
	log_packet_header = no
  }
 Module: Linked to module rlm_radutmp
 Module: Instantiating module "radutmp" from file /etc/freeradius/modules/radutmp
  radutmp {
	filename = "/var/log/freeradius/radutmp"
	username = "%{User-Name}"
	case_sensitive = yes
	check_with_nas = yes
	perm = 384
	callerid = yes
  }
 Module: Linked to module rlm_attr_filter
 Module: Instantiating module "attr_filter.accounting_response" from file /etc/freeradius/modules/attr_filter
  attr_filter attr_filter.accounting_response {
	attrsfile = "/etc/freeradius/attrs.accounting_response"
	key = "%{User-Name}"
	relaxed = no
  }
 Module: Checking session {...} for more modules to load
 Module: Checking post-proxy {...} for more modules to load
 Module: Checking post-auth {...} for more modules to load
 Module: Instantiating module "attr_filter.access_reject" from file /etc/freeradius/modules/attr_filter
  attr_filter attr_filter.access_reject {
	attrsfile = "/etc/freeradius/attrs.access_reject"
	key = "%{User-Name}"
	relaxed = no
  }
 } # modules
} # server
server inner-tunnel { # from file /etc/freeradius/sites-enabled/inner-tunnel
 modules {
 Module: Checking authenticate {...} for more modules to load
 Module: Checking authorize {...} for more modules to load
 Module: Checking session {...} for more modules to load
 Module: Checking post-proxy {...} for more modules to load
 Module: Checking post-auth {...} for more modules to load
 } # modules
} # server
radiusd: #### Opening IP addresses and Ports ####
listen {
	type = "auth"
	ipaddr = *
	port = 0
}
listen {
	type = "acct"
	ipaddr = *
	port = 0
}
listen {
	type = "auth"
	ipaddr = 127.0.0.1
	port = 18120
}
 ... adding new socket proxy address * port 48305
Listening on authentication address * port 1812
Listening on accounting address * port 1813
Listening on authentication address 127.0.0.1 port 18120 as server inner-tunnel
Listening on proxy address * port 1814
Ready to process requests.

正常启动的话会有最后的Ready to process requests打印出，再使用命令发送 eap request包
vdaming@vdaming-Lenovo-ubuntu:~$ radtest vic 1234 localhost 0 testing123
Sending Access-Request of id 103 to 127.0.0.1 port 1812
	User-Name = "vic"
	User-Password = "1234"
	NAS-IP-Address = 127.0.1.1
	NAS-Port = 0
	Message-Authenticator = 0x00000000000000000000000000000000
rad_recv: Access-Accept packet from host 127.0.0.1 port 1812, id=103, length=32
	Reply-Message = "Hello, vic"

如果正常显示reply message 表示设置OK了。

```


# **测试手机sim卡认证**
配置和简单测试OK后，开始使用手机来模拟测试。
1. 在AP上配置使用WPA/WPA2,或者802.1x的认证方法，输入radius server的IP和密钥。
2. 使用支持EAP_SIM的手机，基本上android4.0的手机都支持，然后搜索到设置好的SSID，连接时选择EAP_SIM的认证方法，选择正确的sim卡（如果是双卡槽的话），链接即可。
3. 如果sim卡的信息都填写正确的话，就能够顺利的连接上了，但是一般不会那么顺利，这时就可以参考radius server上打印的debug信息查看错误发生在了哪里，或者使用wireshark抓包检查认证流程，参考**RFC4186**.

# **END**
OK， 就到这里了，并没有深入研究freeradius 使用mysql来配置用户，计费等信息的方法，以后用到的时候再了解吧，另外对于EAP_SIM,802.1x的介绍及基本的拓扑结构，认证流程都能在网上搜索的到，这里不再赘述。
