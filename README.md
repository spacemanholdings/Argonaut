# Argonaut Toolkit

Abstract: Decentralized Governance for Nonprofits and other entities 
based around Holacratic ideas of flat governance and role definitions. 
Features a new type of token, Taxable Token, used for continuous and 
sustainable funding for decentralized entities and ENS based org and 
chapter topography for identification. Deployed on QtumX PoA chain with 
Plasma ERC20 support to tether funding and token balances on Qtum 
mainnet allowing governance transactions to be free and complex while 
tokens and funding can be secured by Qtum mainnet. 

# Taxable Token QRC-20 Mintable
The Taxable Token is a new specification of a type of token that is 
continously minted. During contract creation the token is pegged to a 
ratio in the native token, then anyone is able to mint new tokens by 
depositing the native token into the contract. The contract also takes 
in a taxrate at the begining of 

For example, if the ratio is set 1 QTUM : 100 Tokens, with a tax rate of 
20%, then for every 1 QTUM sent to the contract, the sender will receive 
80 tokens, with 20 tokens being taxed and sent to the beneficiary. In 
the example of a non profit, you might have an admin chapter which takes 
the taxed tokens, and regular org chapters which petition for local 
events or local sponsorship, which donors could fund directly with their 
tokens. <br />
[More Info To Be Added Later]

## TODO
- Write tests to ensure the bounds of the contract work as expected
- Add multi beneficiary support

# Decentralized Holocratic Organization
[ More Info To Be Added Later]
## TODO

# POA Bridge Implementation
Allows for free transactions on the governance chain, allowing for 
increased role based transactions to be delegated there without drawing 
on funds. Also insures that fund allocation is still secure on the 
mainnet chain. <br />
[ More Info To Be Added Later]
## Todo
