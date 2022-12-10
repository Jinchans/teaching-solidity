// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Example mapping to an address

contract PokemonContract {

    struct Pokemon {
        string name;
        string element;
        uint256 stamina;
        uint256 level;
    }

    mapping (uint256 => mapping(address => Pokemon)) public pokemonCollection;

    function createPokemon(string memory name, string memory element, uint256 stamina, uint256 level, uint256 id) public {

        Pokemon storage _pokemon = pokemonCollection[id][msg.sender];

        _pokemon.name = name;
        _pokemon.element = element;
        _pokemon.stamina = stamina;
        _pokemon.level = level;

    }

    function getPokemon(address user, uint256 id) public view returns (string memory, string memory, uint256, uint256) {
        Pokemon storage p = pokemonCollection[id][user];
        return (p.name, p.element, p.stamina, p.level);
    }

}
