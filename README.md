# AgreedOnThatData
Ethereum Smart Contract that validates a document approved by identified parties.

My Early works on ETH Dapps, this simulates the proof of existence of any document agreed upon by N<20 identified parties. 

#How does it work
First we create an identity to match an ethereum address to one person (struct Person object)

Then we made a function that is controled by an entity that can identify the parties with (AddPerson), each of those identified parties are now eligible to make contracts(WeMadeAContract) with others, they need to specify the Contract Document Hash (CDH) plus an array containing the parties concerned, notice that the contract is not active until all the parties concerned pushed the same data  (array & CDH)

Finaly the parties are linked with that document hash, if anyone do not honor his commitement agreed upon on the CDH, the others are able to prouve it with (IsItActivated), and apply the punishments written on the CDH.


#Pseudo CDH
==============================================
||List Person Concerned :                   ||
||    Person1                               ||
||    Person2                               ||
||    Person3                               || 
||    Person4                               ||
||                                          ||
||We agreed to do:                          ||
||  foo bar                                 ||
||                                          ||
||Punishement if someone do not honor:      ||
||  Pay the other parties 100000$           ||
||                                          ||
||Signed by all the:                        ||
||                            23/12/2013    ||
=============================================


#Screenshoots


![Alt text](./OnlyOneParty.png?raw=true "Title")

![Alt text](./TwoParties.png?raw=true "Title")


