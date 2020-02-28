pragma solidity ^0.5.0;

contract CertiBlocks {
    struct Certificate {
        string ipfsHash;
        string sha256Hash;
        uint256 issueDate;
        address certificateIssuer;
        address recipient;
        string notes;
        uint256 expiryDate;
    }
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


    event RegisteredNewAuthority(address indexed authority, string details);
    event RegisteredNewIssuer(address indexed issuer, string details);
    event RegisteredNewRecipient(address indexed recipient, string details);
    event IssuedNewCertificate(uint indexed certificate, address indexed issuer, address indexed recipient);


    uint currentIndex;
    constructor() public {
        issuerAuthorityDetails["initial"] = msg.sender;
        isIssuingAuthority[msg.sender] = true;
        issuerAuthorityList[msg.sender] = "initial";
        currentIndex = 1;
    }

    function AddNewIssuerAuthority(address addressOfAuthority,string memory details) public{
        require((isIssuingAuthority[msg.sender] == true), "You are not part of authority to register a new Issuer Authority.");
        issuerAuthorityDetails[details] = addressOfAuthority;
        isIssuingAuthority[addressOfAuthority] = true;
        issuerAuthorityList[addressOfAuthority] = details;
        emit RegisteredNewAuthority(msg.sender, details);
    }

    function AddNewCertificateIssuer(address addressOfIssuer,string memory details) public{
        require((isIssuingAuthority[msg.sender] == true), "You are not part of authority to register a issuer.");
        issuerDetails[details] = addressOfIssuer;
        isCertificateIssuer[addressOfIssuer] = true;
        issuersList[addressOfIssuer] = details;
        emit RegisteredNewIssuer(msg.sender, details);
    }

    function AddNewReceiver(address addressOfRecepient,string memory details) public{
        require((isIssuingAuthority[msg.sender] == true || isCertificateIssuer[msg.sender] == true), "You are not part of authority or issuer to register a receiver.");
        recipientDetails[details] = addressOfRecepient;
        isRecipient[addressOfRecepient] = true;
        recipientList[addressOfRecepient] = details;
        emit RegisteredNewRecipient(msg.sender, details);
    }
   
    function AddNewCertificate(address _recipient,string memory _ipfsHash ,string memory _sha256Value, uint256 _expiryDate, string memory _notes ) public {
        require((isCertificateIssuer[msg.sender] == true), "You are not part of issers to create a new certificte.");
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

    function getRecipientDetails(string memory _sha256Value) public view returns (address){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateAndRecipientMapper[_sha256Value];
    }
    
    function getIssuerDetails(string memory _sha256Value) public  view returns (address){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateAndIssuerMapper[_sha256Value];
    }

    function getNotes(string memory _sha256Value) public  view returns (string memory){
        require((isValidCertificate[_sha256Value] == true), "Certificate is not part of the blockchain yet.");
        return certificateAndNotesMapper[_sha256Value];
    }
    
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

    function getIssuerDetails(address _issuer) public view returns (string memory){
        require((isCertificateIssuer[_issuer] == true), "Address is not registered as issuer.");
        return issuersList[_issuer];
    }
    function getRecipientDetails(address _recipient) public view returns (string memory){
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
