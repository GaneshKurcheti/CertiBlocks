pragma solidity ^0.5.0;

contract MerkleProof {
    function verify(
        bytes32[] memory proof, bytes32 root, bytes32 leaf, uint index
    )
        public pure returns (bool)
    {
        bytes32 hash = leaf;

        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            index = index / 2;
        }

        return hash == root;
    }
}

contract CertiBlocks {
    bytes32[] public hashes;
    // Stucture to store the certificate in the blockchain.
    struct Certificate {
        string ipfsHash;
        string sha256Hash;
        uint256 issueDate;
        address certificateIssuer;
        address recipient;
        string notes;
        uint256 expiryDate;
    }
    // Mappings are dynamically changing values in the blockchain. 
    mapping(string => address) issuerAuthorityDetails;
    mapping(string => address) issuerDetails;
    mapping(string => address) recipientDetails;
    mapping(address => string) issuersList;
    mapping(address => string) recipientList;
    mapping(address => string) issuerAuthorityList;
    mapping(uint => Certificate) certificatesList;
    mapping(uint => string) certificatesIpfsHash;
    mapping(address => uint[]) recipientCertificateIDs;
    mapping(address => uint[]) issuerCertificateIDs;
    mapping(address => bool) isIssuingAuthority;
    mapping(address => bool) isCertificateIssuer;
    mapping(address => bool) isRecipient;
    mapping(string => bool) isValidCertificate;
    mapping(string => address) certificateAndIssuerMapper;
    mapping(string => address) certificateAndRecipientMapper;
    mapping(string => string) certificateAndNotesMapper;
    mapping(string => uint256) certificateExpiryMapper;
    mapping(string => uint) certificateIDMapper;

    // Events for storing in the transaction log.
    event RegisteredNewAuthority(address indexed authority, string details);
    event RegisteredNewIssuer(address indexed issuer, string details);
    event RegisteredNewRecipient(address indexed recipient, string details);
    event IssuedNewCertificate(uint indexed certificate, address indexed issuer, address indexed recipient);

    // Used to track the index for next block that will be added to the blockchain.
    uint currentIndex;

    constructor() public {
        issuerAuthorityDetails["initial"] = msg.sender;
        isIssuingAuthority[msg.sender] = true;
        issuerAuthorityList[msg.sender] = "initial";
        currentIndex = 1;
    }

    function CalculateMerkle() public{
        for (uint i = 1; i < currentIndex; i++) {
            hashes.push(keccak256(abi.encodePacked(certificatesIpfsHash[i])));
        }

        uint n = currentIndex;
        uint offset = 0;

        while (n > 0) {
            for (uint i = 0; i < n - 1; i+=2) {
                hashes.push(
                    keccak256(abi.encodePacked(
                        hashes[offset + i],
                        hashes[offset + i + 1]
                    ))
                );
            }
            offset += n;
            n = n / 2;
        }
    }

    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

    // Adds new authority. On successfull addition of authority RegisteredNewAuthority event is emitted.
    function AddNewIssuerAuthority(address addressOfAuthority,string memory details) public{
        require((isIssuingAuthority[msg.sender] == true), "You are not part of authority to register a new Issuer Authority.");
        issuerAuthorityDetails[details] = addressOfAuthority;
        isIssuingAuthority[addressOfAuthority] = true;
        issuerAuthorityList[addressOfAuthority] = details;
        emit RegisteredNewAuthority(addressOfAuthority, details);
    }

    // Adds new issuer. On successfull addition of issuer RegisteredNewIssuer event is emitted.
    function AddNewCertificateIssuer(address addressOfIssuer,string memory details) public{
        require((isIssuingAuthority[msg.sender] == true), "You are not part of authority to register a issuer.");
        issuerDetails[details] = addressOfIssuer;
        isCertificateIssuer[addressOfIssuer] = true;
        issuersList[addressOfIssuer] = details;
        emit RegisteredNewIssuer(addressOfIssuer, details);
    }

    // Adds new receiver. On successfull addition of receiver RegisteredNewRecipient event is emitted.
    function AddNewReceiver(address addressOfRecepient,string memory details) public{
        require((isIssuingAuthority[msg.sender] == true || isCertificateIssuer[msg.sender] == true), "You are not part of authority or issuer to register a receiver.");
        recipientDetails[details] = addressOfRecepient;
        isRecipient[addressOfRecepient] = true;
        recipientList[addressOfRecepient] = details;
        emit RegisteredNewRecipient(addressOfRecepient, details);
    }
   
   // Adds new certificate. On successfull addition of certificate IssuedNewCertificate event is emitted.
    function AddNewCertificate(address _recipient,string memory _ipfsHash ,string memory _sha256Value, uint256 _expiryDate, string memory _notes ) public {
        require((isCertificateIssuer[msg.sender] == true), "You are not part of issers to create a new certificate.");
        require((isRecipient[_recipient] == true), "Recipient is not atted to recipient list yet. Please add before issuing certificate.");
        require((isValidCertificate[_sha256Value] != true), "Certificate with same hash value is alredy added in the network.");
        Certificate memory certificate;
        certificate.sha256Hash = _sha256Value;
        certificate.issueDate = now;
        certificate.certificateIssuer = msg.sender;
        certificate.recipient = _recipient;
        certificate.notes = _notes;
        certificate.ipfsHash = _ipfsHash;
        certificate.expiryDate = _expiryDate;
        uint tempId = currentIndex;
        currentIndex++;
        certificatesIpfsHash[tempId] = _ipfsHash; 
        certificatesList[tempId] = certificate;
        recipientCertificateIDs[_recipient].push(tempId);
        issuerCertificateIDs[msg.sender].push(tempId);
        isValidCertificate[_sha256Value] = true;
        certificateAndIssuerMapper[_sha256Value] = msg.sender;
        certificateAndRecipientMapper[_sha256Value] = _recipient;
        certificateAndNotesMapper[_sha256Value] = _notes;
        certificateExpiryMapper[_sha256Value] = _expiryDate;
        certificateIDMapper[_sha256Value] = tempId;
        emit IssuedNewCertificate(tempId, msg.sender, _recipient);
    }

    // Gets the details of receiver of the certificate. 
    function getRecipientDetails(string memory _sha256Value) public view returns (address){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateAndRecipientMapper[_sha256Value];
    }
    
    // Gets the details of issuer of the certificate. 
    function getIssuerDetails(string memory _sha256Value) public  view returns (address){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateAndIssuerMapper[_sha256Value];
    }

    // Gets the notes of the certificate. 
    function getNotes(string memory _sha256Value) public  view returns (string memory){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateAndNotesMapper[_sha256Value];
    }
    
    // Gets the notes of the certificate. 
    function getExpiry(string memory _sha256Value) public view returns (uint256){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateExpiryMapper[_sha256Value];
    }

    function getID(string memory _sha256Value) public view returns (uint){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateIDMapper[_sha256Value];
    }

    function getReceivedCertificates() public view returns (uint[] memory) {
        require((isRecipient[msg.sender] == true), "You must be a recepient to access your certificates");
        return recipientCertificateIDs[msg.sender];
    }

    function getIssuedCertificates() public view returns (uint[] memory) {
        require((isCertificateIssuer[msg.sender] == true), "You must be a issuer to access your issued certificates");
        return issuerCertificateIDs[msg.sender];
    }

    function getIssuerNodeDetails(address _issuer) public view returns (string memory){
        require((isCertificateIssuer[_issuer] == true), "Address is not registered as issuer.");
        return issuersList[_issuer];
    }
    function getRecipientNodeDetails(address _recipient) public view returns (string memory){
        require((isRecipient[_recipient] == true), "Address is not registered as recepient.");
        return recipientList[_recipient];
    }

    function getCertificateById(uint _id) public view returns (string memory, uint, address, address,string memory){
        require((currentIndex>_id), "Certificate is not part of the blockchain yet.");
        Certificate memory certificate = certificatesList[_id];
        return (certificate.sha256Hash, certificate.expiryDate, certificate.certificateIssuer, certificate.recipient,certificate.notes);
    }

    function getCertificateIPFSHashById(uint _id) public view returns (string memory){
        require((currentIndex>_id), "Certificate is not part of the blockchain yet.");
        return certificatesIpfsHash[_id];
    }
}
