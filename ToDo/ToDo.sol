// DESCRIPTION: A simple Task list to store daily tasks

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ToDo {
    struct Tasks {
        string weekday;
        string task;
    }

    Tasks[] public listOfTasks;

    mapping (string => string) public weekdayToTask;

    function addTask(string memory _weekday, string memory _task) public {
        listOfTasks.push( Tasks(_weekday, _task) );
        weekdayToTask[_weekday] = _task;
    }

}
