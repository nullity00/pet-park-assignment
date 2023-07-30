//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PetPark {

  address public owner;

  enum AnimalType { None, Dog, Cat, Rabbit, Fish, Parrot }
  enum Gender {
    Male,
    Female
  }

  struct BorrowDetails {
    bool borrowed;
    AnimalType animalType;
    uint age;
    Gender gender;
  }

  event Added(AnimalType animalType, uint count);
  event Borrowed(AnimalType animalType);
  event Returned(AnimalType animalType);

  mapping (AnimalType => uint) public animalCounts;
  mapping (address => BorrowDetails) public borrowed;
  mapping (AnimalType => uint) public borrowCounts;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can call this function");
    _;
  }

  function add(AnimalType animalType, uint count) public onlyOwner {
    require(animalType != AnimalType.None , "Invalid animal");
    animalCounts[animalType] += count;
    emit Added(animalType, count);
  }

  function borrow(uint _age, Gender _gender, AnimalType animalType) public {

    require(animalType != AnimalType.None , "Invalid animal type");

    if (borrowed[msg.sender].borrowed) {
        if(borrowed[msg.sender].age == _age && borrowed[msg.sender].gender == _gender){
          revert("Already adopted a pet");
        }
        if (borrowed[msg.sender].age != _age){
          revert("Invalid Age");
        }
        if (borrowed[msg.sender].gender != _gender){
          revert("Invalid Gender");
        }
      revert("Already adopted a pet");
    }

    require(_age > 0, "Age must be greater than 0");
    require(animalCounts[animalType] > 0, "Selected animal not available");
    
    if (_gender == Gender.Male) {
      require(animalType == AnimalType.Dog || animalType == AnimalType.Fish, "Invalid animal for men");
    } else {
      if (animalType == AnimalType.Cat){
        require(_age >= uint(40), "Invalid animal for women under 40");
      }
    }

    borrowed[msg.sender] = BorrowDetails(true, animalType, _age, _gender);
    animalCounts[animalType] -= 1; 
    borrowCounts[animalType] += 1; 
    emit Borrowed(animalType);

  }

  function giveBackAnimal() public {

    require(borrowed[msg.sender].borrowed, "No borrowed pets");
    borrowed[msg.sender].borrowed = false;
    animalCounts[borrowed[msg.sender].animalType] += 1; 
    borrowCounts[borrowed[msg.sender].animalType] -= 1;
    emit Returned(borrowed[msg.sender].animalType);

  }
    
}