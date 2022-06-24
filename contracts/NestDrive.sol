//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/// @author Team Resilient - Blockgames Internship 22
/// @title A Decentralized file storage Dapp
contract NestDrive is Pausable {
    constructor() {
        moderator[msg.sender] = true;
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
    mapping(address => bool) public moderator;

    /// @notice stores the list of files
    /// @dev mapping outlining all files created in a state variable `Allfiles`
    mapping(uint => File) public Allfiles;

    /// @notice check if an address is blacklisted
    /// @dev mapping of blacklisted addresses
    mapping(address => bool) public blackListedAddresses;

    /// @dev array to store the list of blacklisted addresses
    address[] public blackList;

    /// @dev mapping of blacklisted addresses index
    mapping(address => uint) indexOfblackList;

    /// @notice array of reported file ids
    uint[] public reportedFiles;

    /// @notice stores the list of reported files
    /// @dev mapping outlining ids of reported files
    mapping(uint => uint) indexOfreportedFiles;

    /// @notice check if a file has already been reported
    mapping(uint => bool) public reportExist;

    /// @notice emits a notice when a new file is uploaded
    /// @dev emit an event containing all the file details when file is uploaded
    event FileUploaded(
        uint fileId,
        string fileHash,
        string fileSize,
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

    /// @notice Notification when an address is blacklisted
    /// @dev Emit event when a new address is blacklisted
    event addInBlackList(address addr);

    /// @notice Notification when a blacklisted address is removed
    /// @dev Emit event when a blacklisted address is removed
    event remInBlackList(address addr);

    /// @notice Notification when a file is reported
    /// @dev Emit event when a file is reported
    event newReport(uint _itemIds);

    /// @notice Notification when a user makes their file private
    /// @dev Emit event when a user makes their file private
    event madePrivate(uint _itemIds);

    /// @notice Notification when a user makes their file public
    /// @dev Emit when a user makes their file public
    event madePublic(uint _itemIds);

    /// @notice Notification when a moderator makes a file private as penalty
    /// @dev Emit event when a moderator makes a file private as penalty
    event madePrivateMod(uint _itemIds);

    /// @notice Ensure that only a moderator can call a specific function.
    /// @dev Modifier to check that address is an assigned moderator.
    modifier isMod(address _user) {
        bool ismod = moderator[_user];
        require(ismod, "Only Moderators Have Access!");
        _;
    }

    /// @notice modifier to check address is not blacklisted
    modifier isNotBlacklisted() {
        require(
            blackListedAddresses[msg.sender] == false,
            "Address is currently Blacklisted.."
            );
        _;
    }

    /// @notice defines the variables of an uploaded file
    struct File {
        uint fileId;
        string fileHash;
        string fileSize;
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
        string memory _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _fileDescription,
        bool _isPublic    
    )

    /// @dev check to ensure that the uploader is not blacklisted
    /// @dev check to ensure the coontract is not paused
    public whenNotPaused isNotBlacklisted {
        
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
        require(bytes(_fileSize).length > 0);

        /// @dev Increment file id
        _itemIds.increment();
        uint currentfileId = _itemIds.current();

        /// @notice Add a File to the contract
        Allfiles[currentfileId] = File(
            currentfileId,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            block.timestamp,
            msg.sender,
            _isPublic
        );

        /// @notice Trigger an event when file is uploaded
        /// @param FileUploaded Name of emitted event
        emit FileUploaded(
            currentfileId,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            block.timestamp,
            msg.sender,
            _isPublic
        );
    }

    /// @notice Only the uploader can change public file visibility to private
    /// @dev file visibility can be changed when file is not blacklisted or contract is paused
    function makeFilePrivate(uint fileId)
        public
        whenNotPaused
        isNotBlacklisted
    {
        /// @notice ensure that the uploader can change file visibility
        /// @dev Check to ensure that the person changing visibility of the file is the uploader or a moderator
        require(
            Allfiles[fileId].uploader == msg.sender,
            "you can only manipulate your own file"
        );

        /// @notice make files private
        Allfiles[fileId].isPublic = false;

        /// @dev increase count of private files
        _itemsPrivate.increment();

        /// @notice emit when a user changes a file they uploaded from public to private
        emit madePrivate(fileId);
    }

    /// @notice Only the moderator can change a reported file's visibility
    /// @dev Check to ensure the contract is not paused
    function makeReportedPrivate(uint fileId)
        public
        whenNotPaused
        /// isNotBlacklisted
    {
        /// @notice ensure that the moderator can change file visibility
        require(
             moderator[msg.sender],
            "only admin can call this function"
        );

        /// @dev check if the file is already private
        Allfiles[fileId].isPublic = false;
        uint index = indexOfreportedFiles[fileId];

        reportedFiles[index] = reportedFiles[reportedFiles.length-1];
        
        reportedFiles.pop();

        /// @dev reduce the reported file count when the reported file is made private
        reportedFiles[index] = reportedFiles[reportedFiles.length-1];
        
        /// @dev remove the private file from the list of reported files
        reportedFiles.pop();

        /// @dev increase count of private files
        _itemsPrivate.increment();

        /// @notice emit when a moderator makes a file private as penalty
        emit madePrivateMod(fileId);
    }

    /// @notice Only the uploader can change a private file visibility to public
    /// @dev file visibility can be changed when the file is not blacklisted
    /// @dev file visibility can be changed if the contract is not paused
    function makeFilePublic(uint fileId) public whenNotPaused isNotBlacklisted {
       
        /// @notice ensure that the uploader can change file visibility
        require(
            Allfiles[fileId].uploader == msg.sender,
            "you can only manipulate your own file"
        );

        /// @notice ensure that the reported files can not be made puvlic after penalty
          require(
            reportExist[fileId] == false,
            "File has been blacklisted for violation, and cannot be made public."
        );

        /// @notice make file public
        Allfiles[fileId].isPublic = true;

        /// @dev Increment public files
        _itemIds.increment();

        /// @notice emit when a user makes their file public
        emit madePublic(fileId);
    }

    /// @notice Function to retrieve all public files
    function fetchPublicFiles()
        public
        view
        whenNotPaused
        isNotBlacklisted
        returns (File[] memory)
    {
        /// @notice total number of items ever created
        /// @return list of all uploads
        uint totalFiles = _itemIds.current();

        /// @dev total files without private files
        uint publicFilesID = _itemIds.current() - _itemsPrivate.current();
        uint currentIndex = 0;

        File[] memory items = new File[](publicFilesID);

        /// @notice Loop through all items ever created
        for (
            uint i = 0;
            i < totalFiles;
            i++) {
            
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
    
    /// @notice function to  fetch only files uploaded by the user
    /// @return list of items uploaded by the user
    function fetchUserFiles()
        public
        view
        whenNotPaused
        isNotBlacklisted
        returns (File[] memory)
    {
        uint totalFiles = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        /// @dev Loop through all files and extract files uploaded by the current user, save as new struct and increment item count
        for (
            uint i = 0;
            i < totalFiles;
            i++) {
            if (Allfiles[i + 1].uploader == msg.sender) {
                itemCount += 1;
            }
        }

        File[] memory items = new File[](itemCount);

        for (
            uint i = 0;
            i < totalFiles;
            i++) {

            /// @dev Get only current user files
            if (Allfiles[i + 1].uploader == msg.sender) {
                uint currentId = Allfiles[i + 1].fileId;
                File storage currentItem = Allfiles[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    ///@dev function to pause the contract
    function pause() public isMod(msg.sender) {
        _pause();
    }

    ///@dev function to unpause the contract
    function unpause() public isMod(msg.sender) {
        _unpause();
    }

    ///@dev function to blacklist an address
    function addToBlackList(address _addr)
        public
        isMod(msg.sender)
        returns (bool)
    {
        /// @dev check if an address is in the list of blacklisted addresses
        blackListedAddresses[_addr] = true;
        blackList.push(_addr);

        /// @notice emit when a address is blacklisted
        emit addInBlackList(_addr);
        return true;
    }

    ///@dev function to remove an address from the blacklist
    function removeFromBlackList(address _addr)
        public
        isMod(msg.sender)
        returns (bool)
    {
        uint index = indexOfblackList[_addr];

        /// @dev reduce the count of blacklisted addresses
        blackList[index] = blackList[blackList.length-1];
        
        /// @dev remove the address from list of blacklisted addresses
        blackList.pop();

        /// @dev check that the address is not amongst the list of blacklisted addresses
        blackListedAddresses[_addr] = false;

        /// @notice emit when a address is removed from blacklist
        emit remInBlackList(_addr);
        return true;
    }

    /// @notice function to fetch only all blacklisted addresses
    /// @return array of blacklisted addresses
    function blackListArray()
        public  view
            isMod(msg.sender)
            returns (address[] memory)
        { 
            return blackList;
        }

    /// @dev function to return an array of  reported Files using fileId
    /// @return array of reported files
    function reportedListArray()
        public  view
            isMod(msg.sender)
            returns (uint[] memory)
        {
            return reportedFiles;
        }

    /// @notice add a new moderator
    function assignMod(address _newMod) public whenNotPaused isMod(msg.sender) {
        moderator[_newMod] = true;

        /// @notice Emit event when a new moderator has been added
        emit AssignMod(msg.sender, _newMod);
    }

    /// @notice remove an existing moderator
    function removeMod(address _mod) public whenNotPaused isMod(msg.sender) {
         moderator[_mod] = false;

        /// @notice Emit event when a moderator has been removed
        emit RemoveMod(msg.sender, _mod);
    }

    /// @dev function to  check if a connected user is a moderatore for mod's features visibility
    function checkMod(address _user) public view whenNotPaused returns(bool){
        bool ismod = moderator[_user];
        return ismod;
    }

    /// @notice Add option to report a file
        function report(uint fileId) public {
            require(
                reportExist[fileId] == false,
                "File has been reported earlier."
            );
            reportExist[fileId]= true;
        reportedFiles.push(fileId);

        /// @notice emit when a file is reported
        emit newReport(fileId);
    }

    /// @dev Option for moderator to remove a reported file
    function clearReportedFiles(uint fileId) public isMod(msg.sender) {
        
        /// @notice check that the files returned are private
        Allfiles[fileId].isPublic = false;
        
        /// @dev increase count of private files
        _itemsPrivate.increment();
        
        ///@dev clear array of reported files
        delete reportedFiles;
    }
}