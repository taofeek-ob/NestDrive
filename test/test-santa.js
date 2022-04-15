//implement test
const { expect } = require("chai");
const { ethers } = require("hardhat");

let fileDrive;

describe("NestDrive Deploy", function(){
    it("should deploy the nestdrive contract to the testnet", async function(){
        console.log("deploying Nestdrive contract.......")
        const NestDriveContract = await ethers.getContractFactory("NestDrive");
        const deployedNestDriveContract = await NestDriveContract.deploy();
        fileDrive = await deployedNestDriveContract.deployed();
        console.log("\n 🏵 NestDrive Contract Address:", deployedNestDriveContract.address);

    })
});

describe("Moderators() and file Restriction (blacklist,access controls)", function(){

    it("Should be able to add, remove Moderators", async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t', " Moderators Address: ", owner.address);
        assignMod = await fileDrive.connect(owner).assignMod(secondAccount.address);
        const txResult = await assignMod.wait();
        expect(txResult.status).to.equal(1);
        removeMod = await fileDrive.connect(owner).removeMod(secondAccount.address);
        const txResult2 = await removeMod.wait();
        expect(txResult2.status).to.equal(1);
        console.log("Revert if address is not a Moderator");
        await expect(fileDrive.connect(secondAccount).removeMod(thirdAccount.address)).to.be.revertedWith("Only Moderators Have Access!");
    
    })

    it("Should be able to add and remove addresses from blacklist",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t', " Moderators Address: ", owner.address);
        addToBlackList = await fileDrive.connect(owner).addToBlackList(secondAccount.address);
        const txResult = await addToBlackList.wait();
        console.log('\t',secondAccount.address ," is added to blacklist!");
        expect(txResult.status).to.equal(1);
        //attempt to access nestdrive functions should revert
        console.log('\t',"Revert if address is Blacklisted...");
        await expect(fileDrive.connect(secondAccount).fetchPublicFiles()).to.be.revertedWith("Address is currently Blacklisted..");
       
        removeFromBlackList = await fileDrive.connect(owner).removeFromBlackList(secondAccount.address);
        const txResult2 = await removeFromBlackList.wait();
        console.log('\t',secondAccount.address ," is removed from blacklist!");
        expect(txResult2.status).to.equal(1);
        console.log("Revert if address trying to remove address from blacklist is not a Moderator");
        await expect(fileDrive.connect(secondAccount).removeMod(thirdAccount.address)).to.be.revertedWith("Only Moderators Have Access!");
    
    })
});

describe("UploadFile , Change file Visibility (Public and Private)...",function(){
    it("Should be able to upload files if all file arguments are present",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        newFile = await fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "22",
            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true);
        const txResult = await newFile.wait();
        console.log('\t',secondAccount.address ," Uploading done! ;-)");
        expect(txResult.status).to.equal(1);
        getfile = await fileDrive.connect(secondAccount).fetchPublicFiles();
        console.log('\t',secondAccount.address ," Validating fetching Public files ...");
        expect(getfile[0].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK");
        expect(getfile[0].fileSize).to.equal("22");
        expect(getfile[0].fileType).to.equal("JPG");
        expect(getfile[0].fileName).to.equal("FatherChristmas");
        expect(getfile[0].fileDescription).to.equal("Picture of Santa distributing gifts :-)");
        expect(getfile[0].isPublic).to.equal(true);
        
    })
    it("Should not be able to upload files if length arguments(fileHash) is absent",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        console.log('\t',"Confirming transaction reversal....")
         await expect( fileDrive.connect(secondAccount).uploadFile("",
            "22",
            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true)).to.be.reverted;
        console.log('\t',"Reversal confirmed!...")
    })
    it("Should not be able to upload files if length arguments(fileSize) is absent",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        console.log('\t',"Confirming transaction reversal....")
         await expect( fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "",
            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true)).to.be.reverted;
        console.log('\t',"Reversal confirmed!...")
    })
    it("Should not be able to upload files if length arguments(fileType) is absent",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        console.log('\t',"Confirming transaction reversal....")
         await expect( fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "22",
            "",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true)).to.be.reverted;
        console.log('\t',"Reversal confirmed!...")
    })
    it("Should not be able to upload files if length arguments(fileName) is absent",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        console.log('\t',"Confirming transaction reversal....")
         await expect( fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "22",
            "JPG",
            "",
            "Picture of Santa distributing gifts :-)",
            true)).to.be.reverted;
        console.log('\t',"Reversal confirmed!...")
    })
    it("Should not be able to upload files if length arguments(fileDescription) is absent",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        console.log('\t',"Confirming transaction reversal....")
         await expect( fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "22",
            "JPG",
            "FatherChristmas",
            "",
            true)).to.be.reverted;
        console.log('\t',"Reversal confirmed!...")
    })
    it("Should not be able to upload files if length arguments(address of the caller is none zero) ",async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        console.log('\t',"Confirming transaction reversal....")
         await expect( fileDrive.connect(ethers.constants.AddressZero).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "22",
            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true)).to.be.reverted;
        console.log('\t',"Reversal confirmed!...")
    })

    it("Should be able to make file private",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        getfile = await fileDrive.connect(secondAccount).fetchPublicFiles();
        console.log('\t',secondAccount.address ,"Successfully fetched files ...");
        //validate visibility status is public
        console.log('\t',"Current visiblity is True! ... (isPublic === true)")
        expect(getfile[0].isPublic).to.equal(true);
        //make file private
        console.log('\t',secondAccount.address ," Making file private ...");
        makeFilePrivate = await fileDrive.connect(secondAccount).makeFilePrivate(1);
        const txResult = await makeFilePrivate.wait();
        expect(txResult.status).to.equal(1);
        console.log("Revert if address is not the owner of the file");
        await expect(fileDrive.connect(secondAccount).makeFilePrivate(2)).to.be.revertedWith("you can only manipulate your own file");
    
    })
    it("Should be able to make file public",async function(){
        const [ owner, secondAccount, thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        newFile = await fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK",
            "22",
            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            false);
        const txResult = await newFile.wait();
        console.log('\t',secondAccount.address ," Uploading done! ;-)");
        expect(txResult.status).to.equal(1);
        getfile = await fileDrive.connect(secondAccount).fetchPublicFiles();
        console.log('\t',secondAccount.address ,"Successfully fetched files ...");
        //validate visibility status is private
        console.log('\t',"Current visiblity is False! ... (isPublic === false)")
        expect(getfile[0].isPublic).to.equal(false);
        //make file public
        console.log('\t',secondAccount.address ," Making file Public ...");
        makeFilePublic = await fileDrive.connect(secondAccount).makeFilePublic(2);
        const txResult1 = await makeFilePublic.wait();
        expect(txResult1.status).to.equal(1);
        console.log("Revert if address is not the owner of the file");
        await expect(fileDrive.connect(thirdAccount).makeFilePublic(2)).to.be.revertedWith("you can only manipulate your own file");
        console.log('\t',"Passed")
    })
})

describe("Files Handling (fetch files, report files )",function(){
    beforeEach(async function(){
        //upload different files
        const [ owner, secondAccount,thirdAccount] = await ethers.getSigners();
        console.log('\t',secondAccount.address ," Uploading new file...");
        newFile1= await fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK1",
            "22",
            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true);
        newFile2= await fileDrive.connect(thirdAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK2",
            "30",
            "JPG",
            "Beach House",
            "Holidays in Hawaii, courtesy Blockgames ;-)",
            false);
        newFile3= await fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK3",
            "12",
            "PDF",
            "Romeo & Juliet",
            "Romance (Brief story of @wande and @Pauline) :-)",
            true);

    })
    it("Should fetch public and user files (all files published by a user), Report file and clear reported files.",async function(){
        const [ owner, secondAccount,thirdAccount,fourthAccount] = await ethers.getSigners();

        ///@dev fetching files uploaded by a user... test
        console.log('\t'," Fetch all files from Address... ",secondAccount.address );
        fetchUserFiles = await fileDrive.connect(secondAccount).fetchUserFiles();
        console.log('\t',"Successfull Fetched all files from Address... ",secondAccount.address );
        console.log('\t',"Validating files uploaded by address... ",secondAccount.address );
        expect(fetchUserFiles.length).to.greaterThan(1);
        expect(fetchUserFiles[2].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK1");
        expect(fetchUserFiles[3].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK3");

        console.log('\t'," Fetch all files from Address... ",thirdAccount.address );
        fetchUserFiles1 = await fileDrive.connect(thirdAccount).fetchUserFiles();
        console.log('\t',"Successfull Fetched all files from Address... ",thirdAccount.address );
        console.log('\t',"Validating files... ",thirdAccount.address );
        expect(fetchUserFiles1.length).to.greaterThanOrEqual(1);
        console.log('\t',"Validating  files uploaded by address... ",thirdAccount.address );
        expect(fetchUserFiles1[0].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK2");
        //should return length of 0 if user address has not uploaded a file
        console.log('\t',fourthAccount.address ,"Attempting to fetch another user(s) private files... ");
        fetchPublicFiles2 = await fileDrive.connect(fourthAccount).fetchUserFiles();
        console.log("user files are:::",fetchPublicFiles2.length);
        expect(fetchPublicFiles2.length).to.equal(0);
        console.log('\t'," Passed... ");

        ///@ dev fetching all files (public)
        console.log('\t'," Fetch all files... ",secondAccount.address );
        fetchPublicFiles = await fileDrive.connect(secondAccount).fetchPublicFiles();
        console.log('\t',"Validating files... ",secondAccount.address );
        expect(fetchPublicFiles[0].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK");
        expect(fetchPublicFiles[1].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK1");
        expect(fetchPublicFiles[2].fileHash).to.equal("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK3");
        console.log('\t'," files Validated!!... ");

        ///@dev report files 
        console.log('\t'," Fetching file ID...  Report file test..." );
        reportFile = await fileDrive.connect(secondAccount).report(2);
        const txResult = await reportFile.wait();
        console.log('\t',"Validating file report ....");
        expect(txResult.status).to.equal(1);
        console.log('\t',"File ID 1 sucessfully reported!");
        
        console.log('\t',"Validated status of flagged file .... SUCCESS!");
        ///@dev clear report files
        console.log('\t',"Validate that only moderators can clear file reports....")
        await expect(fileDrive.connect(secondAccount).clearReportedFiles(2)).to.be.revertedWith("Only Moderators Have Access!");
        console.log('\t'," Deleting Reported files....");
       
        deleteReportedFile = await fileDrive.connect(owner).clearReportedFiles(2);
        const txResult1 =await deleteReportedFile.wait();
        expect(txResult1.status).to.equal(1);
        console.log('\t',"Files were successfully removed...");
    })
})
describe("Pause and Unpause contract test",function(){
    ///@dev When contract is paused
    beforeEach("Pause Contract", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //pause contract
        console.log('\t'," Pausing Contract...");
        pause =await fileDrive.connect(owner).pause();
    })
    count=0;
    it("Should not be able to upload files ", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //upload different files
        console.log('\t',"Attempting to Upload new file when paused...");
        await expect(fileDrive.connect(secondAccount).uploadFile("QmWm6MYSvkuWWjoDu62Ma9agyDPw7dyWw72WFbYNdStxQK1",
            "22",

            "JPG",
            "FatherChristmas",
            "Picture of Santa distributing gifts :-)",
            true)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to make file private ", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //making files private
        console.log('\t'," Attempting to make file private when contract is paused...");
        await expect(fileDrive.connect(secondAccount).makeFilePrivate(1)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
        
    })
    it("Should not be able to make file public ", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //making files public
        console.log('\t'," Attempting to make file public when contract is paused...");
        await expect(fileDrive.connect(secondAccount).makeFilePublic(1)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to fetch public files", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //fetching public files
        console.log('\t'," Attempting to fetch public files when contract is paused...");
        await expect(fileDrive.connect(secondAccount).fetchPublicFiles()).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to fetch user files ", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //fetching user files
        console.log('\t'," Attempting to make file private when contract is paused...");
        await expect(fileDrive.connect(secondAccount).fetchUserFiles()).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to add to blacklist", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //adding files to blacklist
        console.log('\t'," Attempting to add address to blacklist when contract is paused...");
        await expect(fileDrive.connect(owner).addToBlackList(secondAccount)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to remove from blacklist", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //removing files from blacklist
        console.log('\t'," Attempting to remove address from blacklist when contract is paused...");
        await expect(fileDrive.connect(owner).addToBlackList(secondAccount)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to add moderators", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //assigning address to moderators list
        console.log('\t'," Attempting to add address to list of moderators when contract is paused...");
        await expect(fileDrive.connect(owner).assignMod(secondAccount)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
    it("Should not be able to remove moderators", async function(){
        const [ owner, secondAccount] = await ethers.getSigners();
        //removing address from moderators list
        console.log('\t'," Attempting to remove address from list of moderators when contract is paused...");
        await expect(fileDrive.connect(owner).removeMod(secondAccount)).to.be.reverted;
        count+=1;
        console.log('\t',"Passed!...",count);
        
        unpause = await fileDrive.connect(owner).unpause();
        const txResult = await unpause.wait();
        expect(txResult.status).to.equal(1);
    })
})
