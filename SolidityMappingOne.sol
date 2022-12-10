// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract PokemonContract {

    struct Pokemon {
        string name;
        string element;
        uint256 stamina;
        uint256 level;
    }

    mapping (uint256 => Pokemon) pokemonCollection;
    uint256[] public pokemonId;

    function createPokemon(string memory name, string memory element, uint256 stamina, uint256 level, uint256 id) public {

        Pokemon storage _pokemon = pokemonCollection[id];

        _pokemon.name = name;
        _pokemon.element = element;
        _pokemon.stamina = stamina;
        _pokemon.level = level;

        pokemonId.push(id);
    }

    function getPokemon(uint256 id) public view returns (string memory, string memory, uint256, uint256) {
        Pokemon storage p = pokemonCollection[id];
        return (p.name, p.element, p.stamina, p.level);
    }

}
