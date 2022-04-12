//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

contract NestDrive {
    constructor() {}

    using Counters for Counters.Counter;

    ///total number of items ever created
    Counters.Counter private _itemIds;

    ///total number of items made private
    Counters.Counter private _itemsPrivate;

    //mapping of moderators
    mapping(address => bool) public mods;

    // emit event when file is uploaded
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

    // emit event when a new moderator is assigned
    event AssignMod(address adder, address newMod);

    // emit event when a moderator is removed
    event RemoveMod(address remover, address newMod);

    //modifier to ensure only mods can call selected functions.
    modifier isMod(address _user) {
        bool ismod = mods[_user];
        require(ismod, "Only Moderators Have Access!");
        _;
    }

    // defines the variables of an uploaded file
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


    mapping(uint => File) public Allfiles;

    // function to upload a file
    function uploadFile(
        string memory _fileHash,
        uint _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _fileDescription
    ) public {
        // Make sure the file hash exists
        require(bytes(_fileHash).length > 0);
        // Make sure file type exists
        require(bytes(_fileType).length > 0);
        // Make sure file description exists
        require(bytes(_fileDescription).length > 0);
        // Make sure file fileName exists
        require(bytes(_fileName).length > 0);
        // Make sure uploader address exists
        require(msg.sender != address(0));
        // Make sure file size is more than 0
        require(_fileSize > 0);

        // Increment file id
        _itemIds.increment();
        uint currentfileId = _itemIds.current();
        
        // Add File to the contract
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

        // Trigger an event
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

    //add a moderator
    function assignMod(address _newMod) public isMod(msg.sender) {
        mods[_newMod] = true;
        
        //emit event
        emit AssignMod(msg.sender, _newMod );
    }

    //remove a moderator
    function removeMod(address _mod) public isMod(msg.sender) {
        require(mods[_mod], "Address is not a moderator.");
        mods[_mod] = false;
        
        //emit event
        emit RemoveMod(msg.sender, _mod );
    }

    // only uploader can change file visibility
    function makeFilePrivate(uint fileId) public {
        require(
            Allfiles[fileId].uploader == msg.sender,
            "you can only manipulate your own file"
        );

        Allfiles[fileId].isPublic = false;
        _itemsPrivate.increment();
    }

    // retrieve all public files
    function fetchPublicFiles() public view returns (File[] memory) {
        /// total number of items ever created
        uint totalFiles = _itemIds.current();

        uint publicFilesID = _itemIds.current() - _itemsPrivate.current();
        uint currentIndex = 0;

        File[] memory items = new File[](publicFilesID);

        ///loop through all items ever created
        for (uint i = 0; i < totalFiles; i++) {
            ///get only public item
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
