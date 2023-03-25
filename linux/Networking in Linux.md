There is 2 ways of resolving DNS name in linux. The first way is to write the dns name with the IP address in the file /etc/hosts. The second way is to query a dns server. The IP address of dns server is present in the file /etc/resolv.conf. You can have as many dns server addresses as you like.

Linux first tries to resolve dns name through the mappings in /etc/hosts. If it doesnot  find the host name, then it queries the dns server. this order can however be changed. This order is described in /etc/nsswitch.conf file.

There is a public dns server run by google that contains IP address for a lot of different websites available in the Internet. The IP address of this dns server is 8.8.8.8. 

A domain can contain multiple sub domain. In this dns name, www.google.com google is domain name. there are also subdomains such as map, gmail etc which forms map.google.com, mail.google.com etc. You can also divide a sub-domain into further sub domains. 

While resolving a dns name (mail.google.com), their might be multiple dns server involved. First your request might go to a root dns server. root dns server will forward this request to another dns server that has information about .com domain names. This dns server will have IP address for google.com domain. But we want the IP address of a subdomain, app.google.com. So, this dns serwill then forward the request to another dns server that has information about the sub domain (mail). Finally server will forward the request to another dns server containing information for .com domains. Thi 

