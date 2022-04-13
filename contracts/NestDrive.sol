//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/Counters.sol";

contract NestDrive{
    constructor(){
        moderators[msg.sender]=true;
        owner = msg.sender;
    }

    //::TODOs
    //create Events to log activities of upload and modify functions
    //mapping to store files
    //struct to structure the file properties
    //openzeppplin counters to keep track of the file IDs
    //function to upload/store file
    //function to fetch/log datas datas (private and public)
    //get a single file by id
    //toggle visibility of file (by moderators or and file creator ) except file is reported then only owner or moderator can
    //report file

    

    //toggle access/visibility modifier
    modifier HasRightToModify (uint256 _fileId){
        //check if the modifier is owner/creator of the file or a moderator
        require(allFiles[_fileId].uploader == msg.sender || moderators[msg.sender],"File modification is restricted to only owner of the content.");
        //check if the file is not blacklisted
        if(allFiles[_fileId].isBlacklisted){
            require(moderators[msg.sender] == true,"Access restricted! File is Blacklisted");
        }
        _;
    }

    //check if an address has access to upload files (address must not be in a blacklist)
    modifier isNotBlacklisted(){
        require(blackListedAddresses[msg.sender] == false,"Address is currently Blacklisted..");
        _;
    }
    //check if an address is a moderator
    modifier isModerator(){
        require(moderators[msg.sender] == true,"Only a moderator has access..");
        _;
    }
    //only owner call
    modifier isOwner(){
        require(msg.sender == owner,"Only a Owner can has access..");
        _;
    }
    //upload event
    event Upload(
        uint256 fileId,
        string fileHash,
        string fileName,
        uint256 uploadTime,
        bool isPublic
        );
    //modified file event:::: type casting value types in the string array
    event ModifyFile(
        uint256 fileId,
        string[] modifiedFields 
    );
    //review file event
    event ReviewFile(uint256);
    //file structure
    struct file {
        uint256 fileId;
        string fileHash;
        string fileName;
        uint256 fileSize;
        string fileType;
        string[] tags;
        string fileDescription;
        bool isPublic;
        uint256 uploadTime;
        address uploader;
        bool isBlacklisted;
        uint256 reportCount;
        address[] reportersAddress;
    }
    //owner
    address private owner;
    //moderator list 
    mapping(address =>bool) private moderators;
    //store for all file types
    mapping(uint256 =>file) private allFiles;
    //file creators track( this keeps track of all files published/uploaded by an address)
    mapping(address => file[]) private fileTrack;
    //track visibility of files created and updated.
    mapping(bool=>uint256) public visbility;
    //blacklisted address
    mapping(address => bool) public blackListedAddresses;
    //track reported files (if the counts is >5 moderators should be alerted!)
    mapping(uint256=>uint256) private reportCounterList;
    uint256[] private reportCounterFileIds;
    uint256[] private redHotFiles; //files that has gotten more than 3 reports

    //tracking ID counts of the stored files
    using Counters for Counters.Counter;
    Counters.Counter private _fileIDs;

    //helper function compare strings
    function compareStr(string memory _str, string memory str) private pure returns (bool) {
        return keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str));
    }
    //function to add moderator
    function addModerator(address _addr) public isModerator returns(bool){
        moderators[_addr]=true;
        return true;
    }
    //function to remove moderator
    function removeModerator(address _addr) public isOwner returns(bool){
        moderators[_addr]=false;
        return true;
    }
    //function to check if an address is a moderator
    function checkModeratorStatus(address _addr) public view returns(bool){
        return moderators[_addr];
    }
    //function that add address to blacklist
    function addToBlackList(address _addr) public isModerator returns(bool){
        blackListedAddresses[_addr]=true;
        return true;
    }
    //function that remove address to blacklist
    function removeFromBlackList(address _addr) public isModerator returns(bool){
        blackListedAddresses[_addr]=false;
        return true;
    }
    //function that uploads/stores files
    function uploadFile (uint256 fileId,
        string memory fileHash,
        string memory fileName,
        uint256 fileSize,
        string memory fileType,
        string[] memory tags,
        string memory fileDescription,
        bool isPublic) public isNotBlacklisted returns(bool){
        
        //=============
          //check fileId if it exist/not empty
        require(fileId>0,"All fields are required!: File ID must be specified, file ID field is required and cannot be empty");
        //check fileSize if it exist and not empty
        require(fileSize >0,"All fields are required!: File size must be specified, file size field cannot be empty");
        //check fileHash existence
        require(bytes(fileHash).length >0,"All fields are required!: File hash must be specified, file hash field cannot be empty");
        //check fileType existence
        require(bytes(fileType).length >0,"All fields are required!: File type must be specified, file type field cannot be empty");
        //check tags existence
        require(tags.length >0,"All fields are required!: At least one tage must be specified. tag field cannot be empty.");
        //check fileDescription existence
        require(bytes(fileDescription).length>0,"All fields are required!: File description cannot be empty.");
        //check the uploader existence
        require(msg.sender != address(0),"All fields are required!: Address must be provided.");
        //check visibilty of the file
        require(isPublic == true || isPublic == false,"All fields are required!: visbility must be public or private.");
       
        //=============
        
        
        uint256 currentID = _fileIDs.current(); 
        //increment counter
        _fileIDs.increment();

        //create new file and add to allFiles storage
        
        bool isBlacklisted;
        uint256 reportCount;
        address[] memory reportersAddress;


        allFiles[currentID]= file(fileId,fileHash,
        fileName,
        fileSize,
        fileType,
        tags,
        fileDescription,
        isPublic,
        block.timestamp,
        msg.sender,
        isBlacklisted=false,
        reportCount=0,
        reportersAddress
        );

        //update file track for users
        fileTrack[msg.sender].push(allFiles[currentID]);
        //update the visibility count
        visbility[allFiles[currentID].isPublic]+=1;

        //emit upload
        emit Upload(fileId,fileHash,fileName,block.timestamp,isPublic);
        return true;

    }

    //function to fetch/log datas (private and public)
    function getFileByAccessibility(string memory _accessType) public isNotBlacklisted view returns(file[] memory){
        require(compareStr(_accessType,"public")||compareStr(_accessType,"private"),"Only private and public strings are acceptable arguments.");
        //declare access type
        bool _type = compareStr(_accessType,"public");
        //current length of the mapping IDs
        uint256 totalLength = _fileIDs.current();
        //count file index tracker
        uint256 count=0;
        //create temporary file list
        file[] memory files = new file[](visbility[_type]);
        //if private ==> true else false
        for(uint256 i =0; i < totalLength;i++){
            if( allFiles[i].isPublic == _type ){
                files[count]=allFiles[i];
                count+=1;     
            }
        }
        
        return files;
    }

    //get file by ID
    function getFileById(uint256 _fileId) public isNotBlacklisted view returns(file memory){
        file memory _file = allFiles[_fileId];
        return _file;
    }
    //get all files published by current user 
    function getPublishedFiles() public isNotBlacklisted view returns(file[] memory){  
        return fileTrack[msg.sender];
    }

    //get all files published by a particular address
    function getFilesByAddress (address _addr) public isNotBlacklisted view returns(file[] memory){
        return fileTrack[_addr];
    } 

    //toggle visibility / access of files
    function toggleAccess (uint256 _fileId) public isNotBlacklisted HasRightToModify(_fileId) returns(file memory){
        //update visbility count
        visbility[allFiles[_fileId].isPublic]-=1;
        visbility[!allFiles[_fileId].isPublic]+=1;

        //change state of the current file visibility /access
        allFiles[_fileId].isPublic = ! allFiles[_fileId].isPublic;

        //update file track
        for(uint256 i =0;i<fileTrack[allFiles[_fileId].uploader].length;i++){
            if(fileTrack[allFiles[_fileId].uploader][i].fileId == _fileId){
                fileTrack[allFiles[_fileId].uploader][i].isPublic = !fileTrack[allFiles[_fileId].uploader][i].isPublic;
            }
        }
        
        return allFiles[_fileId];
    }
    
    //report a file
    function reportFile (uint256 _fileId) public isNotBlacklisted returns(bool){
        if(allFiles[_fileId].reportersAddress.length>0){
            //check if an address has previously reported a file
            for(uint256 i= 0;i<allFiles[_fileId].reportersAddress.length;i++){
                if(allFiles[_fileId].reportersAddress[i]==msg.sender){
                    require(false,"Cannot report a file twice");
                }
            }
            //get the file and update reportersAddress and report count
            allFiles[_fileId].reportCount++;
            allFiles[_fileId].reportersAddress.push(msg.sender);

            //update reportCounterList
            reportCounterList[_fileId]+=1;

            //check if fileId is already in reportCounterFileIds array else push it
            bool exist = false;
            for(uint256 i =0;i<reportCounterFileIds.length;i++){
                if(reportCounterFileIds[i]==_fileId){
                    exist=true;
                }
            }
            if(exist){
                reportCounterFileIds.push(_fileId);
            }
            //push to rehotfiles if reports exceeds 3
            bool existInReHotFiles = false;

            for(uint256 j =0;j<redHotFiles.length;j++){
               if(redHotFiles[j]==_fileId){
                   existInReHotFiles=true;
               }
            }
            
            for(uint256 i=0;i<reportCounterFileIds.length;i++){
                if(reportCounterList[reportCounterFileIds[i]]>=3 && !existInReHotFiles ){
                    redHotFiles.push(reportCounterFileIds[i]);
                }
          
            }
            

        }else{
        //get the file and update reportersAddress and report count
        allFiles[_fileId].reportCount++;
        allFiles[_fileId].reportersAddress.push(msg.sender);
        

        //update reportCounterList (map of IDs and Counts)
        reportCounterList[_fileId]+=1;
        //update reportCounterFileIds (array of fileIds)
        reportCounterFileIds.push(_fileId);
        }
        return true;
    }
  //File alert for moderators to monitor files reported by users (if report count is >5)
  function reviewFile() public view isModerator returns(uint256[] memory){
    //   uint256 greaterThanThreeLength = redHotFiles.length;
     return redHotFiles;
  }

    
}


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";


/// @author Team Resilient - Blockgames Internship 22
/// @title A Decentralized file storage Dapp
contract NestDrive {
    constructor() {
        mods[msg.sender] = true;
    }

    using Counters for Counters.Counter;

    /// @notice total number of items ever created
    /// @dev counts the number of items in the state variable `_itemIds`
    Counters.Counter private _itemIds;

    /// @notice total number of items made private
    /// @dev counts the number of items in the state variable `_itemsPrivate`
    Counters.Counter private _itemsPrivate;

    /// @notice stores the list of moderators
    /// @dev mapping outlining addresses of assigned moderators
    mapping(address => bool) public mods;

    /// @notice stores the list of files
    /// @dev mapping outlining all files created
    mapping(uint => File) public Allfiles;

    /// @notice emits a notice when a new file is uploaded
    /// @dev emit an event containing all the file details when file is uploaded
    event FileUploaded(
        uint fileId,
        string fileHash,
        uint fileSize,
        string fileType,
        string fileName,
        string fileDescription,
        uint uploadTime,
        address uploader,
        bool isPublic
    );

    /// @notice Notification when a moderator is assigned
    /// @dev Emit event when a new moderator is assigned
    event AssignMod(address adder, address newMod);

    /// @notice Notification when a moderator is removed
    /// @dev Emit event when a moderator is removed
    event RemoveMod(address remover, address newMod);

    /// @dev modifier to ensure only moderators can call selected functions.
    modifier isMod(address _user) {
        bool ismod = mods[_user];
        require(ismod, "Only Moderators Have Access!");
        _;
    }

    /// @notice defines the variables of an uploaded file
    struct File {
        uint fileId;
        string fileHash;
        uint fileSize;
        string fileType;
        string fileName;
        string fileDescription;
        uint uploadTime;
        address uploader;
        bool isPublic;
    }


    /// @notice Function to upload a file
    function uploadFile(
        string memory _fileHash,
        uint _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _fileDescription
    ) public {

        /// @dev Make sure the file hash exists
        require(bytes(_fileHash).length > 0);

        /// @dev Make sure file type exists
        require(bytes(_fileType).length > 0);
        
        /// @dev Make sure file description exists
        require(bytes(_fileDescription).length > 0);
        
        /// @dev Make sure file fileName exists
        require(bytes(_fileName).length > 0);

        /// @dev Make sure uploader address exists
        require(msg.sender != address(0));

        /// @dev Make sure file size is more than 0
        require(_fileSize > 0);

        /// @dev Increment file id
        _itemIds.increment();
        uint currentfileId = _itemIds.current();
        
        /// @notice Add File to the contract
        Allfiles[currentfileId] = File(
            currentfileId,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            block.timestamp,
            msg.sender,
            true
        );

        /// @notice Trigger an event when file is uploaded
        emit FileUploaded(
            currentfileId,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            block.timestamp,
            msg.sender,
            true
        );
    }

    /// @notice add a new moderator
    function assignMod(address _newMod) public isMod(msg.sender) {
        mods[_newMod] = true;
        
        /// @notice Emit event when a new moderator has been added
        emit AssignMod(msg.sender, _newMod );
    }

    /// @notice remove an existing moderator
    function removeMod(address _mod) public isMod(msg.sender) {
        require(mods[_mod], "Address is not a moderator.");
        mods[_mod] = false;
        
        /// Emit event when a moderator has been removed
        emit RemoveMod(msg.sender, _mod );
    }

    /// @dev Only the uploader can change file visibility
    function makeFilePrivate(uint fileId) public {

        /// @notice ensure that the uploader can change file visibility
        require(
            Allfiles[fileId].uploader == msg.sender,
            "you can only manipulate your own file"
        );

        /// @notice check that file is not public
        Allfiles[fileId].isPublic = false;

        /// @dev increase count of private files
        _itemsPrivate.increment();
    }

    /// @notice Function to retrieve all public files
    function fetchPublicFiles() public view returns (File[] memory) {
        
        /// @notice total number of items ever created
        uint totalFiles = _itemIds.current();

        uint publicFilesID = _itemIds.current() - _itemsPrivate.current();
        uint currentIndex = 0;

        File[] memory items = new File[](publicFilesID);

        /// @notice Loop through all items ever created
        for (uint i = 0; i < totalFiles; i++) {
            
            /// @notice Get only public item
            if (Allfiles[i + 1].isPublic == true) {
                uint currentId = Allfiles[i + 1].fileId;
                File storage currentItem = Allfiles[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }

    // fetch only files uploaded by the user
    function fetchUserFiles() public view returns (File[] memory) {
        uint totalFiles = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint i = 0; i < totalFiles; i++) {
            if (Allfiles[i + 1].uploader == msg.sender) {
                itemCount += 1;
            }
        }

        File[] memory items = new File[](itemCount);
        for (uint i = 0; i < totalFiles; i++) {
            if (Allfiles[i + 1].uploader == msg.sender) {
                uint currentId = Allfiles[i + 1].fileId;
                File storage currentItem = Allfiles[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
