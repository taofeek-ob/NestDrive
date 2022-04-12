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
