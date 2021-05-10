# quillhash-test

This is my submission for quillhash task.

### Features
1. Token Contract. This token mints to required addresses and for the Crowdsale contract with the total supply of 50,000,000,000 tokens
2. Whitelist Contract. This contract is for managing whitelist addresses
3. Crowdsale Contract. This is the main crowdsale contract. It has an hardcap of 12.5M in USD. so I have used chainlinks price feed oracle to get the price data. 
Then several calculations are made to send the investor their appropriate amount of $QLL token considering the minimum entry fee, and after hardcap is hit, we transfer the contract balance to the ICO team.

### My Review
Nice learning, task was well written with important use case contraints. I have implemented what I gathered by learning.
