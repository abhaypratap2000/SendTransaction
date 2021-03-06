
// SPDX-License-Identifier: MIT
 pragma solidity >=0.8.0;
abstract contract ERC20{
    function name() public virtual view returns ( string memory);
    function symbol() public virtual view returns (string memory);
    function decimals() public virtual view returns (uint8);
    function totalSupply() public virtual view returns (uint256);
    function balanceOf(address _owner) public virtual view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


}

contract Owned{
    address public owner;
    address public newOwner;

    event ownershipTransfer(address indexed _from , address indexed _to );

    constructor(){
        owner = msg.sender  ;
    } 

    function transferOwnership(address _to) public{
        require(msg.sender == owner);
        newOwner = _to;
    }

    function acceptOwnership() public{
        require(msg.sender == newOwner);
        emit ownershipTransfer(owner , newOwner);
        newOwner = address(0);  
    }


} 

contract Token is ERC20,Owned{
    string public _symbol;
    string public _name;
    uint8 public _decimal;
    uint public _totalSupply;
    address public _minter;


      mapping(address => uint) balances;
    mapping(address => mapping (address => uint256)) allowed;
    

     
    constructor(){
     _symbol = "JSR";
     _name = "JAI SHREE RAM";
     _decimal = 10;
     _totalSupply = 10000;
     _minter = msg.sender;
     balances[_minter] = _totalSupply;

     emit Transfer(address(0),_minter,_totalSupply); 
    }
      function name() public override view returns ( string memory ){
          return _name;
      }
      function symbol() public override view returns (string memory){
          return _symbol;
      }
      function decimals() public override view returns (uint8){
          return _decimal;
      }
      function totalSupply() public override  view returns (uint256){
          return _totalSupply;
      }
      function balanceOf(address _owner) public override view returns (uint256 balance){
          return balances[_owner];

      }

      function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
          require(balances[_from]>= _value);
          allowed[_from][_to]-=_value;
          balances[_from] -= _value;
          balances[_to] += _value;
          emit Transfer(_from , _to , _value);
          return true;

      }

        function transfer(address _to, uint256 _value) public override returns (bool success){
          return transferFrom(msg.sender , _to , _value);
        }                                
   
        function approve(address _spender, uint256 _value) public override  returns (bool success){
            allowed[msg.sender][_spender] = _value;
            emit Approval(msg.sender , _spender , _value);
            return true;

        }
        function allowance(address _owner, address _spender) public override  view returns (uint256 remaining){
            return allowed[_owner][_spender];
        }
        function mint(uint amount) public returns(address){
            require(msg.sender == _minter,"require owner");
            balances[_minter]+= amount;
            _totalSupply += amount;
            return _minter;
        }

        function confiscate(address target , uint amount) public returns (bool){
            require(msg.sender == _minter);
            if(balances[target] >= amount){
                balances[target] -=amount; 
            }
            else{
                _totalSupply -= balances[target];
                   balances[target] = 0;
            }
            return true;
        }

}