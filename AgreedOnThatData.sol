pragma solidity ^0.4.4;
/*
Require a Phone App + PC application GUI friendly
Keep Personal Information on a Flash Disque THAT MUST BE KEPT SAFE, 
automatic plug means data can be accessed from that pc.
Do not use Jpeg or bmp only PNG supported or else it will ruin the hash with random pixel diffrence due to dft
*/ 
contract AgreedOnThatData{ // this tool will help lawyers get proofs of documentations, as well as vocal promises that agreed on all parties.
	
	struct 	Person { //Can make the variables more efficient
		bytes16 Name; // Asci character takes 1 byte  Giving more in arguements will give unexpected results
		bytes16 LastName;
		bytes16 PhysicalAddress;
		bytes8 PlaceDateOfBirth;
		uint8 NationalID;
		string AdditionalDataOnIPFSHASH;
		string[] H_ContractsAgreed  ;   // Once the contract Activate it will push here; 
		// any data that can identify more that person such as picture family related address etc ANYTHING with a structure also contain the data above. and its stored on a flash Disque
		//Additional data contains Rhesus
	}
	struct Contract{ // all parties must provide the same ContractHash to be Activated
		
		string ContractHash; // Will have a Layout to respect for each contract with gui its easy to make with a lawyer contain eth adresses too
        mapping (address => bool) DoesAgree;
        address[] Partners;
		bool IsActivated;
	}
	uint MaximumPartners = 20;

	mapping (address => Person) private Algerians;
	address[3]  Administrators; // can modify who is Wilaya & Lawyers ???
	address[48] private  Wilaya;
	address[20]	 private Lawyers;
	Contract[] private Contracts;

	//Admin Stuff
	function AgreedOnThatData() public {

		Administrators[0] = msg.sender;
		Contract memory Genesis ;
		Contracts.push(Genesis);
		Contracts[0].ContractHash = "GenesisContract";
		Contracts[0].IsActivated = true;
		Contracts[0].DoesAgree[msg.sender] = true;
		Contracts[0].Partners.push( msg.sender);
		/*Contracts.push(Genesis);
		Contracts[1].ContractHash = "GenesisContract2";
		Contracts[1].IsActivated = true;
		Contracts[1].DoesAgree[msg.sender] = true;
		Contracts[1].Partners.push( msg.sender);*/
	}
	modifier IsAdmin(){
		bool _Legit = false;

		for (uint i = 0 ; Administrators.length > i; i++){
			if ( msg.sender  == Administrators[i])
				_Legit = true;
				i= Administrators.length;
		}
		require(_Legit);
		
		_;
	}
	function ChangeMaxPartner(uint NewMax) IsAdmin()public returns(bool Success){
		MaximumPartners = NewMax;
		return true;
	}
	// Mairie  && Wilaya 
	function AddPerson (address _CitizenAddressAllocated,bytes16 _Name,bytes16 _LastName,bytes16 _PhysicalAddress,bytes8	 _PlaceDateOfBirth,uint8 _NationalID,string _AdditionalDataOnIPFSHASH) IsAdmin() public returns (bool Success){
		
		Person memory NewAlgerian;
		NewAlgerian.Name = _Name;
		NewAlgerian.LastName = _LastName;
		NewAlgerian.PhysicalAddress = _PhysicalAddress;
		NewAlgerian.PlaceDateOfBirth = _PlaceDateOfBirth;  
		NewAlgerian.NationalID = _NationalID ;
		NewAlgerian.AdditionalDataOnIPFSHASH =_AdditionalDataOnIPFSHASH;
		Algerians[_CitizenAddressAllocated] = NewAlgerian;
		return true;
	}

	// LAW Area

	// Can be any law paper or attestation of winning etc 
	modifier ContractConditions(address[]  _Partners,string H_ContractToAgreeOn){
				 // on limite a 20 partenaires pour éviter les boucles
		require(_Partners.length < MaximumPartners);
		bool Legit = false;
		for (uint o =0 ; _Partners.length>o ;o ++) // Pour chaque Partenaire dans le contract
		{
			if (msg.sender == _Partners[o])
			{
				Legit = true;	
				o = _Partners.length;	
			}
		}
		uint ContractNumber = getContractNumber(H_ContractToAgreeOn);
		require(Legit);  // Si ce n'est aucun des Partenaires qui ajoute le contract
		if (ContractNumber != 0 ){
	        require(Contracts[ContractNumber].IsActivated == false); // no need to activate an already activated contractt
		}	
		_;
	}
	function WeMadeAContract(address[]  _Partners ,string H_ContractToAgreeOn) ContractConditions(_Partners, H_ContractToAgreeOn)public returns(bool Success)
	{// Function that is called by each Partner Concerned of that specific contract, once all agree on the same contract(hash) the contract is "Active" and added
		uint ContractNumber = getContractNumber(H_ContractToAgreeOn);
		if (ContractNumber == 0) // if the contract does not exist yet we create a new one
		{
			Contract memory New;
			New.ContractHash = H_ContractToAgreeOn;
			Contracts.push(New);
			ContractNumber = Contracts.length - 1 ;
		}

		
		 // in each revert require etc we are losing money, make a great userGUIAPP to protect it
		 // Le partenaire Qui a call cette function est daccord pour ce contract
		Contracts[ContractNumber].DoesAgree[msg.sender] = true;
		

		uint NmbrOfPeopleThatAgree = 0;
		
		for (uint i=0 ; _Partners.length > i ; i++ ) // Pour chaque Partenaire dans le contract
		{
			if (Contracts[ContractNumber].DoesAgree[_Partners[i]] == true  )
			{
                NmbrOfPeopleThatAgree +=1;
			}
			
			Contracts[ContractNumber].Partners.push(_Partners[i]); // on enregistre les Partenaires;
		} 
		if (NmbrOfPeopleThatAgree == _Partners.length) // Si tout lesont donnez le même 
		{
		    Contracts[ContractNumber].IsActivated = true;
		}
    return true;
	}
	function getContractNumber(string _H_ContractToAgreeOn_) public constant returns( uint)
	{ // WOOOORKS

		string memory C;
	    for (uint i = 0; i < Contracts.length ;i++ ) // i = [0 1 2 3]
	    {
	        C = Contracts[i].ContractHash;
			if (  keccak256(C) ==  keccak256(_H_ContractToAgreeOn_))
			{
                return i;
			}
	    }
	    return 0; //First Contract Must be Random
	}
	//function RemoveContract
	function IsItActivated(string Contract_Hash)public constant returns (bool Activated)
	{  // Works
		uint num = getContractNumber(Contract_Hash);
		require (num != 0);
		return Contracts[num].IsActivated;
	}/*
	Admin: 
		AgreedOnThatData.deployed().then(function(instance){AOTD=instance});acc = web3.eth.accounts ;DzCoin.deployed().then(function(instance){DC=instance}) ; 
		AOTD.WeMadeAContract([acc[0]],"AA")
	*/
	function getPartners(string ContractHash) public constant returns  (address[] PartnersConcerned)
	{ // Works
		uint  _ContractNumber= getContractNumber (ContractHash);
		require (_ContractNumber != 0);
		uint length = Contracts[_ContractNumber].Partners.length;
		address[] memory  PartnersConcerned_ = new address[](length);
		for (uint i= 0;i<length;i++)
		{
		    PartnersConcerned_[i] = Contracts[_ContractNumber].Partners[i];
		}
		return PartnersConcerned_;
	}
	// can be used by any legal authority 
	function ConfirmID( string PersonsHash,address _Person) public constant returns (uint NationalID )
	{ // Works
			string memory C = Algerians[_Person].AdditionalDataOnIPFSHASH;

			if (  keccak256(C) ==  keccak256(PersonsHash))
			{
				return Algerians[_Person].NationalID;
			}
			return 0; 
		
	}

	//function AwardAttestation is the same as WeMadeAContract Student+School Contract 
}
/* issues :
1)will the system continue without internet?
	Data will be available cause ipfs but the blockchain will be frozen. So no more new contracts/interactions.
2)Data Availability  to foreign people
ipfs hash will be only provided 
3)First Contract must be clear (to return 0 in getContractNumber)
4)NationalID string better ? to avoid 0141118 turn to 141118 or make a function that controls that (string is heavier)

	ThingsToDo:
	1) code the call functions for different variables for specific READERS:
4) monthly Clearing of data storage (unActivated Contracts)
Simulation:
kill %1 ;truffle compile;testrpc -s Dz & truffle migrate --reset;echo "AgreedOnThatData.deployed().then(function(instance){AOTD=instance});acc = web3.eth.accounts ;AOTD.WeMadeAContract( [acc[0] ],\"GenenisContract\");" | xclip;truffle console
AOTD.AddPerson(acc[1],"Chebli","Zaki Omar","8 mai 45","Kouba1994",161,"QQ")
AOTD.WeMadeAContract([acc[0],acc[1]],"QQ")



Other Accounts: 
AgreedOnThatData.deployed().then(function(instance){AOTD=instance});acc = web3.eth.accounts ;DzCoin.deployed().then(function(instance){DC=instance}) ; 



Out of Gas : infinite loop contractsume all gaz or delete Build Folder!!


one two three four are different accounts in the network of the same blockchain
WeMadeAContract takes the people who are engaged on a contract as an array(account=acc) plus the contract hash
Window 1
Window 2 we check if the contract is enabled and we see False because acc 3 did not agree yet
Window 3 acc3 Agree on the same Hash
Window 2 we check again and its activated
the contract is Valid both acc2 & 3 agree on it!
Window4 we add real Person Data on teh blockchain such name etc
to identify the person we interact with
*******JS****************
//Dico
var point = { x:3, y:2 }; 
point["x"] // => 3;
point.y // => 2;
//Array
a = [1 ,2 ,3]
Samir
Rahmani
A
TRST.Dz

*/
