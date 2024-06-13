// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/EuCho.sol";

contract EuChoTest is Test {
    EuCho public euCho;

    function setUp() public {
        euCho = new EuCho();

        //Making the test account an authorised personnel to call the getSymptoms function
        euCho.addAuthorizedPersonnel(address(this));
    }

    function testSubmitSymptoms() public {
        euCho.submitSymptoms("fever, diarrhea", "Male", "Glenview", 24);

        uint256 entriesCount = euCho.getSymptomsCount();
        EuCho.SymptomEntry[] memory entries = new EuCho.SymptomEntry [] (entriesCount);
        
        for (uint256 i = 0; i < entriesCount; i++) {
            entries[i] = euCho.getSymptoms(i);
        }

        assertEq(entries.length, 1); 
        assertEq(entries[0].user, address(this));
        assertEq(entries[0].symptoms, "fever, diarrhea");
        assertEq(entries[0].gender, "Male");
        assertEq(entries[0].location, "Glenview");
        assertEq(entries[0].age, 24);
        assertApproxEqAbs(entries[0].timestamp, block.timestamp, 2);
    }

    function testAddAuthorizedPersonnel() public {
        address newAdmin = address(0x123);
        euCho.addAuthorizedPersonnel(newAdmin);
        assertTrue(euCho.authorizedPersonnel(newAdmin));
    }

    function testTriggerAlert() public {
        // Placeholder test logic for triggerAlert
    }
}
