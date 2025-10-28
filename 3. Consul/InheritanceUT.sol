// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Inheritance exercise - single file implementation + deployer
/// @notice Implements Employee (abstract), Salaried, Hourly, Manager, Salesperson, EngineeringManager
///         and a small deployer that creates Salesperson and EngineeringManager with the
///         example values from the Base exercise and then deploys InheritanceSubmission.

abstract contract Employee {
    uint public idNumber;
    uint public managerId;

    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint);
}

contract Salaried is Employee {
    uint public annualSalary;

    constructor(uint _annualSalary, uint _idNumber, uint _managerId) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view virtual override returns (uint) {
        return annualSalary;
    }
}

contract Hourly is Employee {
    uint public hourlyRate;

    constructor(uint _hourlyRate, uint _idNumber, uint _managerId) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view virtual override returns (uint) {
        // Annual cost = hourlyRate * 2080
        return hourlyRate * 2080;
    }
}

contract Manager {
    uint[] public employeeIds;

    function addReport(uint _id) public {
        employeeIds.push(_id);
    }

    function resetReports() public {
        delete employeeIds;
    }

    // helper: get number of reports
    function reportsCount() public view returns (uint) {
        return employeeIds.length;
    }
}

contract Salesperson is Hourly {
    // inherits Hourly which inherits Employee
    constructor(uint _hourlyRate, uint _idNumber, uint _managerId)
        Hourly(_hourlyRate, _idNumber, _managerId)
    {}
}

contract EngineeringManager is Salaried, Manager {
    // Note: Salaried already initializes Employee via its constructor
    constructor(uint _annualSalary, uint _idNumber, uint _managerId)
        Salaried(_annualSalary, _idNumber, _managerId)
    {}
}

contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}

/// @notice Small helper contract that deploys the example Salesperson and EngineeringManager
///         with the values from the exercise and then deploys InheritanceSubmission.
/// Values used (from exercise):
/// - Salesperson: hourlyRate = 20, id = 55555, managerId = 12345
/// - EngineeringManager: annualSalary = 200000, id = 54321, managerId = 11111
contract DeployContracts {
    address public salesPerson;
    address public engineeringManager;
    address public submission;

    constructor() {
        // Deploy Salesperson (hourly rate 20, id 55555, manager 12345)
        Salesperson s = new Salesperson(20, 55555, 12345);
        salesPerson = address(s);

        // Deploy EngineeringManager (annual salary 200000, id 54321, manager 11111)
        EngineeringManager e = new EngineeringManager(200000, 54321, 11111);
        engineeringManager = address(e);

        // Deploy the InheritanceSubmission using those addresses
        InheritanceSubmission sub = new InheritanceSubmission(salesPerson, engineeringManager);
        submission = address(sub);
    }
}
