There is 2 ways of resolving DNS name in linux. The first way is to write the dns name with the IP address in the file /etc/hosts. The second way is to query a dns server. The IP address of dns server is present in the file /etc/resolv.conf. You can have as many dns server addresses as you like.

Linux first tries to resolve dns name through the mappings in /etc/hosts. If it doesnot  find the host name, then it queries the dns server. this order can however be changed. This order is described in /etc/nsswitch.conf file.

There is a public dns server run by google that contains IP address for a lot of different websites available in the Internet. The IP address of this dns server is 8.8.8.8.

