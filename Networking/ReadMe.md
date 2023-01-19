# Networking Concepts

<br>

## IP Address

If 2 devices wants to communicate with other, both will need some kind of identfier, which uniquely identifies them.

This is what a IP address does. IP stands for Internet Protocol. This means IP address falls under IP layer in OSI Model.

A computer gets an IP from the Internet Provider. If a device disconnects from Internet and connect again, the device will get a new IP address.

<hr>
<br>

## DNS Address

Remebering IP Address of another device is a tough job. So, instead we use a DNS Address.

DNS Address is a alphabetical address that maps to a IP address.

Whenever we try to visit any device in the Internet, we usually use DNS addresses, as they are easy to remeber.

<br>

## DNS Server

The mapping of DNS Address to its IP address is done by a server called DNS Server.

This server stores all DNS and its corresponding IP address.

<hr>
<br>

# Some Intresting Questions

<br>

## How does a Device Communicate to Another Device (Practical Example)

This are the steps used for communication between 2 devices.

1. Device A first identifies the DNS address of device B.
2. Device A sends a request to DNS Server to resolve the IP address of device B
3. DNS Server looks into its database and finds the IP address mapped to the DNS address. DNS server sends the IP back to Device A.
4. Device A can now communicate with Device B.

<hr>
<br>

## How does Device A knows the address of DNS Server ?

<hr>
<br>

## What if we deploy a new version of our application in another device with a different IP address ?

If we deploy our application in another device, then the only way to connect to that application is by sending request to that IP address.But the DNS server has our DNS address mapped to IP address which has previous version application. So, we need to update the DNS address mapping a well.

The problem is updating DNS address globally might take days. So, a lot of users will still connect to previous version application. That also means we also can't shut the previous version untill the DNS address mapping has propagated globally. That's when we have to use a software called "Reverse Proxy".
