OSI stands for Open Systems Interconnection model. It defines multiple standards that has to be followed by all the components involved in networking. All these components are then classified into 7 different groups or layers.

### Questions

#### 1. Why do we need a Standard that should be followed by all involved in networking?

When you send a request from a machine A to another machine B, you might not know much about the machine B's hardware and networking infrastructure. Machine B could be either of these

- A computer connecting with ethernet cable to the router
- A computer connecting with Wifi to the router
- A smartwatch connecting through Wifi to the router
- A smartphone connecting through Wifi to the router
- A IOT device connecting through Wifi to the router.  
 
All of these machines might have a different architecture CPU, different companies that made all the parts etc. Your machine might be connected through Ethernet (electric signals) or Fiber (light signals). Imagine you have to explicitly program your application so that it sends bits in the correct format(electric signals or light signals). Now, what happens when your internet connection changes from ethernet to fiber. Now, you have to change your application bits sending logic. 

Having a globally accepted standard lets us send requests the same way irrespective of the underlying CPU type (multiple arhitectures), underlying hardware type (smartphone, laptop, IOT device), Network connection type (Wifi, Fiber, Ethernet) etc. 

If there is no standard, then how does one router created by one company will be able to communicate with another router created by another company? Both should agree upon some rules to follow for communication. 

#### 2. How can we send request in any way without knowing the underlying hardware and network type ? A laptop connected through Ethernet and a smartphone connected through Wifi must have different mechnaism to handle networking? 

Smarter people have already built components that will accept any kind of request and will convert that request to match the format expected by underlying hardware and network components. This way you have a single unified API that you can use for networking. The implementation of API will differ for different hardware and network components, but this is not something you need to worry about.  

#### 3. What are different components involved in Networking?

All the protocols such as HTTP, FTP, TCP, UDP, etc, concepts such as IP Address, Mac Address, sockets etc, physical components such as Network Interface, routers, cables etc are different components involved in Networking. All these components are used in one of 7 different layers.

#### 4. What are 7 different layers of OSI Model

There are bunch of stuff that happens when we want to send some data from one computer to another. This includes things such as 

- using a proper format to represent data that is understood by both the applications running on 2 different machines
- Encoding the data using various encoding mediums such as utf-8 if needed
- maintaining some kind of state that stores information regrading the 2 computers
- Continuously checking to make sure the data reached another computer and keep trying if it doesn't
- Using some identifier to identify both the computers
- Using some identifier to identify the application this data is destined to
- and finally using the correct physical medium to transfer the data.  

OSI model groups all these activities into multiple layers.  These layers are:

- Layer 7 : Application Layer (HTTP/FTP)
- Layer 6 : Presentation Layer (Encoding/Serialization)
- Layer 5 : Session Layer (Connection Establishment/TLS)
- Layer 4 : Transport Layer (UDP/TCP)
- Layer 3 : Network/IP Layer (IP)
- Layer 2 : Data Link Layer (Mac Address/Ethernet)
- Layer 1 : Physical Layer (Electric signal/Radio Signals/Light Signals)

All these layers are built on top of one another. When computer A wants to send data to computer B, the data flows from Layer 7 to Layer 1 in computer A. The data then reaches computer B. Computer B will do this process in reverse i.e. the data will flow from Layer 1 to Layer 7. The detailed description for all the layer will be discussed shortly.

#### 5. Why do we group all the activities in 7 different layers? What is the advantage? 

As discussed above, all these layers are built on top of one another. This gives us 2 advantages.

- Debugging Issues: If some problem occurs in networking, we can identify the Layer in which the problem occurs. If the data is passing properly from Layer 5 that means the issue might be in Layer 4 or below. By minimizing the scope of issue we can then focus on components that belong to those potential issue layers, in this case layer 4 and below. 
- Making changes to a layer: If we are making changes to layer 4, we only need to worry about components that are present in Layer 3 and Layer 5. We need to make sure that our changes doesnot affect the data flow from Layer 5 and Layer 3. We dont need to care about other compilance with other Layers.
- Understanding Networking Better: By grouping all the activities of networking in groups, we can understand networking better. We will know which layer we understand better and which layer we lack the understanding. We can then focus more on the weak understanding layer.


## Explaning all Layers of OSI Model

Each Layer in OSI Model has some specific functionalities. We will start to exploring from Layer 7 all the way to Layer 1.

### Layer 7 (Application Layer)

This layer defines the working of application that you as a developer will make. 

Lets say you have a nodejs application. The application sends a post request to a database. The request needs to include data which is this case is SQL statements. When the request reaches the database, database will look at the data and process accordingly. Here both nodejs application and Database are said to be in a Application Layer. The process of sending request from nodejs appliacation to database includes a lot of other steps. They will be defined in upcoming layers.

### Layer6 (Presentation Layer): 

The process of converting a data of a request in a way that can be sent across the network and understood by another party is done in Presentation Layer. This mainly includes Serializaton and Deserialization.

Lets take the example of same nodejs application. When you write the SQL statement as payload in the request, you do it in nodejs specific way. You will represent the payload in some kind of data structure using a specific syntax that is valid in nodejs. You cannot send the entire object through Network. The object is only represented in memory when nodejs is running.  

So, inorder to send the object across the network, it needs to be converted to normal text string. This process is called Serialization. This text data will then be sent across the network to database. Database will then interpret this text data and convert it to its own native data type. Database might format the data with its own syntax, extra spaces etc. 

### Layer5 (Session Layer)

This layer is responsible for establishing and maintaining session between 2 parties for the entire comunication period. 

Lets take the example of same nodejs application. When nodejs application wants to communicate with database application, it first needs to ask for permission from database application. If the database application gives the permission, then it is said that the session is established between nodejs application and database application.

Any request that is send by nodejs application to database application has 2 session checks. First the host machine of nodejs application checks if the session exists with the database application. If not, it first creates a session. When the request reaches to host machine of database application, it  checks if there exists a session between the nodejs application (request source) with the database application (request destination). If the session doesnot exist, the request is rejected and it never reaches the database application.

This means that the session layer is a stateful layer as it stores informaton regarding all currently active sessions. There is a terminology called TCP handshake which refers to the process of creating session between 2 machines. 

It is important to note that not all the communication requires session establishement. The requirement of session depends upon the protocol used in Layer 4. TCP layer requires session wheras UDP layer doesnot.


### Layer4 (Transport Layer)

This layer is responsible for transfering network requests from one machine to another. This layer mainly has 2 ways for transfering network requests. They are 

- TCP (Transimission Control Protocol)
- UDP (User Datagram Protocol)

Both protocols have different rules when it comes to sending network requests from one computer to another. TCP is considered more reliable as compared to UDP. TCP Protocol makes sure that every network packets are sent from one machine to another. It ensures this by receiving an acknowledgement from the receiver. If the acknowledgement is not recieved this means that the packet was lost in between. So, the protocol will send the packet once again. UDP doesnot have any such mechanism. While not having the acknowledgement mechanism, definately makes UDP less reliable, it also makes UDP more faster in data transmission.

TCP is used when the data intergrity is absolutely essential. Example: sending a document. Even if it takes more time to send document, we want to send all the network packets that combiningly represent all that document. 

UDP is used when speed is needed and data integrity is not needed. Example: Audio or Video call. You dont want to receive a packet representing video that was sent 5 seconds ago. You want to receive video in real time. Even if some packets are lost, thats not an issue.    

In our nodejs application, we should use TCP connection. The SQL statement should reach to the database correctly.


### Layer3 (Network/IP Layer)

This layer deals with the IP address of a computer. Every computer has IP address that uniquely identifies it. We need the destination computer IP address to correctly route the network packet. 

This layer adds a header(some additional metadata) in each network packet. This header contains information about source and destination IP address. Each packet is then routed correctly by router based upon the destination IP address attached to it.


### Layer2 (Data link Layer)

This layer deals with the Mac address of a computer. Every computer has Mac address that uniquely identifies it. We need the destination computer Mac address to correctly route the network packet. 

This layer adds a header(some additional metadata) in each network packet. This header contains information about source and destination Mac address. Each packet is then routed correctly by router based upon the destination Mac address attached to it.


### Layer1(Physical Layer)

This layer deals with sending the network request from one computer to another via physical medium such as wires or wireless medium such as wifi.
It converts network packets into digital bits (1 or 0) and then represent those bits in either electric signals (ethernet cables), light signal (fiber cable) or radio signal (wifi).