// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TestUniswapLiquidity {
    address private constant FACTORY =
        0xd9145CCE52D386f254917e481eB44e9943F39138;
    address private constant ROUTER =
        0xf8e81D47203A594245E36C48e151709F0C19fBe8;
    address private constant WETH = 0xeC7Da43fdd2Afb20853A8f625F6Da515b01bD9A5;

    function addLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 _amountA,
        uint256 _amountB
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
        IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

        IERC20(_tokenA).approve(ROUTER, _amountA);
        IERC20(_tokenB).approve(ROUTER, _amountB);

        (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        ) = IUniswapV2Router(ROUTER).addLiquidity(
                _tokenA,
                _tokenB,
                _amountA,
                _amountB,
                1,
                1,
                address(this),
                block.timestamp
            );
        return (amountA,amountB,liquidity);
    }

    function removeLiquidity(address _tokenA, address _tokenB) external returns (
            uint256,
            uint256
        ){
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        uint256 liquidity = IERC20(pair).balanceOf(address(this));
        IERC20(pair).approve(ROUTER, liquidity);

        (uint256 amountA, uint256 amountB) = IUniswapV2Router(ROUTER)
            .removeLiquidity(
                _tokenA,
                _tokenB,
                liquidity,
                1,
                1,
                address(this),
                block.timestamp
            );
            return (amountA,amountB);
    }
}

interface IUniswapV2Router {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);
}

interface IUniswapV2Factory {
    function getPair(address token0, address token1)
        external
        view
        returns (address);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}