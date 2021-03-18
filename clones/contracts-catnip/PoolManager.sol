pragma solidity 0.5.12;

import "./BFactory.sol";
import "./BPool.sol";
import "./test/TToken.sol";


contract PoolManager {
    address public owner;
    address public factory;

    event PoolCreated(address bpoolAddress);
    event TokenBound(address currentPool, address token, uint balance, uint denorm);
    event TokenRebound(address currentPool, address token, uint balance, uint denorm);
    event TokenUnbound(address currentPool, address token);

    event TokenApproved(address token, address currentPoolAddress, uint balance);

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(address _factory) public {
        owner = msg.sender;
        factory = _factory;
    }

    //@dev creates a new smart pool that will be controlled by pool manager
    function createPool()
        public
        onlyOwner
        returns(BPool)
    {
        BFactory bfactory = BFactory(factory);
        BPool bpool = bfactory.newBPool();
        address poolAddress = address(bpool);
        emit PoolCreated(poolAddress);
        return bpool;
    }

    //@dev approves a new token for binding by a smart pool
    function approveToken(address _token, address _currentPoolAddress, uint _balance)
        public
        onlyOwner
    {
        TToken token = TToken(_token);
        token.approve(_currentPoolAddress, _balance);
        emit TokenApproved(_token, _currentPoolAddress, _balance);
    }

    //@dev checks whether a token is bound to the current smart pool
    function checkToken(address _currentPoolAddress, address _token)
        external
        view
        returns(bool)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.isBound(_token);
    }

    //@dev returns the normalized weight of a token
    function normalizedWeight(address _currentPoolAddress, address _token)
        external
        view
        returns(uint)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.getNormalizedWeight(_token);
    }

    //@dev returns the denormalized weight of a token
    function denormalizedWeight(address _currentPoolAddress, address _token)
        external
        view
        returns(uint)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.getDenormalizedWeight(_token);
    }

    //@dev returns the balance of a token
    function tokenBalance(address _currentPoolAddress, address _token)
        external
        view
        returns(uint)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.getBalance(_token);
    }

    //@dev returns array of tokens bound to the current smart pool
    function currentTokens(address _currentPoolAddress)
        public
        view
        returns(address[] memory)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.getCurrentTokens();
    }

    //@dev binds a new token to the smart pool that is current being managed
    function bindToken(address _currentPoolAddress, address _token, uint _balance, uint _denorm)
        public
        onlyOwner
    {
        BPool currentPool = BPool(_currentPoolAddress);
        currentPool.bind(_token, _balance, _denorm);
        emit TokenBound(_currentPoolAddress, _token, _balance, _denorm);
    }

    //@dev rebinds a token to the smart pool, changing the weight and/or balance
    function rebindToken(address _currentPoolAddress, address _token, uint _balance, uint _denorm)
        public
        onlyOwner
    {
        BPool currentPool = BPool(_currentPoolAddress);
        currentPool.rebind(_token, _balance, _denorm);
        emit TokenRebound(_currentPoolAddress, _token, _balance, _denorm);
    }

    //@dev unbinds a token from the smart pool
    function unbindToken(address _currentPoolAddress, address _token)
        public
        onlyOwner
    {
        BPool currentPool = BPool(_currentPoolAddress);
        currentPool.unbind(_token);
        emit TokenUnbound(_currentPoolAddress, _token);
    }

    //@dev sets the swap fee
    function setFee(address _currentPoolAddress, uint _fee)
        public
        onlyOwner
    {
        BPool currentPool = BPool(_currentPoolAddress);
        currentPool.setSwapFee(_fee);
    }

    //@dev returns the swap fee of the current smart pool
    function swapFee(address _currentPoolAddress)
        public
        view
        returns(uint)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.getSwapFee();
    }

    //@dev sets the current pool public
    function setPublic(address _currentPoolAddress, bool _public)
        public
        onlyOwner
    {
        BPool currentPool = BPool(_currentPoolAddress);
        currentPool.setPublicSwap(_public);
    }

    //@dev returns true if the current smart pool is public
    function isPublic(address _currentPoolAddress)
        public
        view
        returns(bool)
    {
        BPool currentPool = BPool(_currentPoolAddress);
        return currentPool.isPublicSwap();
    }
}
