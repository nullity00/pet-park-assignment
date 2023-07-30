//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PetPark {

  address public owner;

  enum AnimalType { Dog, Cat, Rabbit, Fish, Parrot }
  enum GenderType {
    Male,
    Female
  }

  event Added(AnimalType animalType, uint count);
  event Borrowed(AnimalType animalType);
  event Returned(AnimalType animalType);

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can call this function");
    _;
  }

  mapping (AnimalType => uint) public animalCount;
  mapping (address => mapping (AnimalType => uint)) public detailedBorrowCount;
  mapping (address => uint) public borrowCount;

  constructor() {
    owner = msg.sender;
  }

  function add(AnimalType animalType, uint count) public onlyOwner {
    animalCount[animalType] += count;
    emit Added(animalType, count);
  }

  function borrow(uint age, GenderType gender, AnimalType animalType) public {

    require(animalCount[animalType] > 0, "No more animals of this type available");
    require(borrowCount[msg.sender] < 2, "You can only borrow 1 animal");
    
    if (gender == GenderType.Male) {
      require(animalType == AnimalType.Dog || animalType == AnimalType.Fish, "Men can only borrow Dog or Fish");
    } else {
      if (animalType == AnimalType.Cat){
        require(age >= uint(40), "Women under 40 cannot borrow Cat");
      }
    }

    detailedBorrowCount[msg.sender][animalType] += 1;
    borrowCount[msg.sender] += 1;
    emit Borrowed(animalType);

  }

  function giveBackAnimal(AnimalType animalType) public {

    require(detailedBorrowCount[msg.sender][animalType] > 0, "You have no animals to give back");
    detailedBorrowCount[msg.sender][animalType] -= 1;
    borrowCount[msg.sender] -= 1;
    emit Returned(animalType);

  }
    
}