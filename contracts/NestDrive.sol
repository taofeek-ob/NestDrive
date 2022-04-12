//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "@openzeppelin/contracts/utils/Counters.sol";


/// @author Team Resilient - Blockgames Internship 22
/// @title A Decentralized file storage Dapp
contract NestDrive {
    constructor() {

        /// @notice Make contract deployer a moderator 
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
    /// @dev mapping to check if an address is an assigned moderator. Returns True or False
    mapping(address => bool) public mods;

    /// @notice stores the list of files
    /// @dev mapping outlining all files created in a state variable `Allfiles`
    mapping(uint => File) public Allfiles;

    /// @notice Emit an event containing all the file details when a file is uploaded
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

    /// @notice Emit event when a new moderator is assigned
    event AssignMod(address adder, address newMod);

    /// @notice Emit event when a moderator is removed
    event RemoveMod(address remover, address newMod);

    /// @notice Ensure that only a moderator can call a specific function.
    /// @dev Modifier to check that address is an assigned moderator.
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
            true
        );
    }

    /// @notice Add a new moderator
    /// @dev Ensure that only an exisiting moderator can assign new moderators
    function assignMod(address _newMod) public isMod(msg.sender) {
        mods[_newMod] = true;
        
        /// @notice Emit event when a new moderator has been added
        /// @dev Emits address of user adding the new moderator and address of moderator that was added
        /// @param AssignMod Name of emitted event
        emit AssignMod(msg.sender, _newMod );
    }

    /// @notice Remove an existing moderator
    /// @dev Ensure that only an exisiting moderator can remove a moderator
    function removeMod(address _mod) public isMod(msg.sender) {
        require(mods[_mod], "Address is not a moderator.");
        mods[_mod] = false;
        
        /// @notice Emit event when a moderator has been removed
        /// @dev Emits address of user removing the moderator and address of moderator that was removed
        /// @param RemoveMod Name of emitted event
        emit RemoveMod(msg.sender, _mod );
    }

    /// @notice Only the uploader can change if a file is publicly accessible
    /// @dev Uploader has the ability to switch file visibility from public to private
    function makeFilePrivate(uint fileId) public {

        /// @dev Ensure that only the uploader of a file can change it's visibility
        require(
            Allfiles[fileId].uploader == msg.sender,
            "you can only manipulate your own file"
        );

        /// @dev Check that file is not public
        Allfiles[fileId].isPublic = false;

        /// @dev increase count of private files
        _itemsPrivate.increment();
    }

    /// @notice Function to retrieve all public files
    function fetchPublicFiles() public view returns (File[] memory) {
        
        /// @dev total files ever uploaded
        uint totalFiles = _itemIds.current();

        uint publicFilesID = _itemIds.current() - _itemsPrivate.current();
        uint currentIndex = 0;

        File[] memory items = new File[](publicFilesID);

        /// @notice Loop through all files ever uploaded
        for (
            uint i = 0;
            i < totalFiles;
            i++) {
            
            /// @notice Get only public files
            if (Allfiles[i + 1].isPublic == true) {
                uint currentId = Allfiles[i + 1].fileId;
                File storage currentItem = Allfiles[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /// @notice Function to fetch only files uploaded by the current user
    function fetchUserFiles() public view returns (File[] memory) {
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
}
