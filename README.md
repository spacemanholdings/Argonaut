Table of Contents
=================

   * [Argonaut Toolkit](#argonaut-toolkit)
      * [1. Holacracy](#1-holacracy)
         * [1.2 Circle Governance](#12-circle-governance)
         * [1.3 Roles](#13-roles)
         * [1.4 Domains](#14-domains)
      * [2. Organization Name Service](#2-organization-name-service)
         * [2.2 Namehash](#22-namehash)
         * [2.3 Upgradability &amp; Lifecycle Management](#23-upgradability--lifecycle-management)
         * [2.4 Root Trust](#24-root-trust)
      * [3. Taxable Token](#3-taxable-token)
         * [3.2 Unlimited Supply &amp; Value Peg](#32-unlimited-supply--value-peg)
         * [3.3 Transfer Between Chains](#33-transfer-between-chains)
         * [3.4 Monetary Supply Control](#34-monetary-supply-control)


# Argonaut Toolkit

Abstract: AG Toolkit is a system of modular components that work together to build a system for scalable decentralized governance. This governance structure can be implemented by any type of organization. Features include a new type of Token, Taxable Token, used for continuous and sustainable funding for decentralized entities, an ENS based org and chapter topography for building robust group identity services, example smart contracts for ease of use Holacractic governance deployment, and a validtator service to transfer tokens from QtumX to Qtum Mainnet. . 

The governance contracts can all be deployed on a Qtum X PoA governance chain with validator nodes moving tokens from one chain to another. In this way all the expensive governance transactions, voting, role assigments, data storage, etc can be done fairly cheaply while still allowing a way to have a QRC20 style token on the main chain for security. 

## 1. Holacracy
Holacracy is a new way of structuring and running your organization that replaces the conventional management hierarchy. Instead of operating top-down, power is distributed throughout the organization, giving individuals and teams more freedom to self-manage, while staying aligned to the organization’s purpose. It was first written about in 2015 and has been slowing gaining attention. 


While it may or may not be righ for a given orgnaization, while reading about Holacracy, it seemed to me quite well suited for decentralized organizations. For example, consider a distributed nonprofit like the Blockchain Education Network (blockchainedu.org). There is a constitution and as long as chapters follow the constitution, any one can apply and run a chapter. There's no real geographical boundries and the structure for each chapter is up to them. There is an administrative chapter that handles the 503c status and fiat finances, but for the most part chapters police themselves. 

In such a large and sprawling organization, how can we have realtime organizational topography? A possible solution is the class feudal system, in which the administration would force every member and chapter to register with them, but this has clear drawbacks when we think globally. 

First of all, what happens if there is a change in leadership for the administrative chapter and the recordkeeping falls into dissarray? Secondly what if a bunch of chapters want to sign on to be BEN chapters, why is that bottlenecked by BEN admin? 

We can alleviate these concerns by using a global shared topography for orgnazations. But such a decentralized topogrpahy requires a system of organization that is equally flat and has a low barrier to entry. 

With our DHO contracts, anyone can create there own orgs, or create a sub org within a bigger org, maintaining their own membership and governance policies. Despite the distributed nature of governance deployment, all of it can be tied together using the Organizational Name Service, offering a root of trust. 

You can read about it <a href="https://www.holacracy.org/wp-content/uploads/2015/07/Holacracy-Constitution-v4.1.pdf">here</a>

### 1.2 Circle Governance
A “Circle” is a Role that may further break itself down by defining its own
contained Roles to achieve its Purpose, control its Domains, and enact its
Accountabilities. The Roles a Circle defines are its “Defined Roles”, and
anyone filling one of its Defined Roles is a “Circle Member” of that Circle.

A 'rootcircle' can be described as rootcircle.arg and might have roles, defined as <b>rolename.rootcircle.arg</b> or it might have subscircles (ie "Marketing", "Finance", etc) described as <b>subcircle.rootcircle.arg</b>.

These urls resolve to a Circle <i>Contract</i>, an example of which can be found in AG_Holacracy/Governance/Circle.sol

### 1.3 Roles

The Organization’s Partners will typically perform work for the Organization
by acting in an explicitly defined Role. A “Role” is an organizational construct
with a descriptive name and one or more of the following:
(a) a “Purpose”, which is a capacity, potential, or unrealizable goal that the
Role will pursue or express on behalf of the Organization.
(b) one or more “Domains”, which are things the Role may exclusively control
and regulate as its property, on behalf of the Organization.
(c) one or more “Accountabilities”, which are ongoing activities of the
Organization that the Role will enact.

### 1.4 Domains
Domains are other contracts that are part of a circle that a role has control over. For example, there might be a 'members' contract meant to keep track of non Role filling members. Or there might be a contract that holds Non Fungible Assets for the orginzation. 

## 2. Organization Name Service
The Organization Name Service is built of the amazing work done by Nick Johnson & co over at Ethereum Name Service. At it's core, it's a very simple concept, map human readable addresses to addresses on chain. It's meant to be a replacement for centralized DNS serivces that map URLs to IP addresses. But look a little deeper and you'll see a fantastic framework for contract modularity and upgradeability just waiting to be unleashed. 

Read more <a href="https://docs.ens.domains/en/latest/">here</a>

### 2.2 Namehash
Names in ENS are represented as 32 byte hashes, rather than as plain text. This simplifies processing and storage, while permitting arbitrary length domain names, and preserves the privacy of names onchain. The algorithm used to translate domain names into hashes is called namehash. The Namehash algorithm is defined in EIP137.

In order to preserve the hierarchal nature of names, namehash is defined recursively, making it possible to derive the hash of a subdomain from the namehash of the parent domain and the name or hash of the subdomain label.

First, a domain is divided into labels by splitting on periods (‘.’). So, ‘earlz.wallet.qtum’ becomes the list [‘earlz’, ‘wallet’, ‘qtum’].

The namehash function is then defined recursively as follows:

namehash([]) = 0x0000000000000000000000000000000000000000000000000000000000000000
namehash([label, …]) = keccak256(namehash(…), keccak256(label))


### 2.3 Upgradability & Lifecycle Management
One of the amazing things this allows for is soft referencing or dynamic referencing of resources on the blockchain. 

By referring to earlz.wallet.qtum whenever we want to send Qtum to earlz, it doesn't matter what he sits his address too. He can update/change it at will, and a contract that's currently deployed that needs to know his address won't have to be redeployed.

Another really important piece this allows for is lifecycle movement of roles. For example, what if your treasurer changes from Bob to Siri? Instead of having to having access permissions based per <i>person</i> we can instead define them by <i>role</i>.

As such we can make it so a certain resource can only be accessed by treasurer.group.arg, and as people change and shift roles (or multiple people take on the same role), none of our access logic needs to be reimplemented. 

### 2.4 Root Trust
Because only the root node may issue a subdomain, and subdomains issue their own subdomains, we can begin to see easy ways to check for membership and implicit trust built into the url. In the same way that we might check that, yes, dev @ spacemanholdings.com is a valid email address, therefore I must be affilated with the domain spacemanholdings, we can do the same using ENS URIs.

dev.members.chicago.blockchainedu.arg will either map to my identity contract on chain or it wont. And if it does, then I can be implicitly seen as belonging to and having gone through the membership process for the <i>Chicago</i> chapter of <i>Blockchain Edu</i> organization. All of this is done on chain without the need for anyone to to maintain email or membership servers.

Moreover, by mapping multiple URIs to the <i>same</i> identity contract, I can start to build a framework for Self Soverign Identity. 

dev.members.chicago.blockchainedu.arg and dev.members.spacemanholdings.arg could map to the <i>same</i> identity contract, without needing me to signup and replicate and fragment my information across multiple servers. Like a facebook login, but without big brother profiteering from your data. 


## 3. Taxable Token
The Taxable Token is a new specification of a type of token that is 
continously minted. During contract creation the token is pegged to a 
ratio in the native token, then anyone is able to mint new tokens by 
depositing the native token into the contract. The contract takes in a taxrate at creation and whenever new coins are minted, the taxed amount is tranferred to the beneficary's address. 

### 3.2 Unlimited Supply & Value Peg
For example, if the ratio is set 1 QTUM : 100 Tokens, with a tax rate of 
20%, then for every 1 QTUM sent to the contract, the sender will receive 
80 tokens, with 20 tokens being taxed and sent to the beneficiary. In 
the example of a non profit, you might have an admin chapter which takes 
the taxed tokens, and regular org chapters which petition for local 
events or local sponsorship, which donors could fund directly with their 
tokens.

This provides an alternative to raising funds using the ICO model for organiaztions that see such models as large risks. There is now a good way to offer a flexible price token (periods can be set for high/low taxrate changing effective price while leving the peg untouched) for potential services they can offer. 

### 3.3 Transfer Between Chains
Another part for the taxable token it is portable between sidechains and the main chain. This is very important because all the previously described governance infrastructure is *expensive*. By moving it all off chain, we can signifcantly increase adoption for using holacractic governance methods (alternative webapp applications for example have flat per user costs). We can mimic these pricing models while still allowing for nonprofits and other decentralized organizations to maintain a monetary supply token. 

### 3.4 Monetary Supply Control
A really good reason to have an QRC 20 instead of a simple Qtum/Eth wrapper token is to build in monetary supply controls. For example, what if you wanted to restrict the redeem function (converting tokens to Eth) to treasurers of organizations *only* and donors shouldn't be able to pull back their pledges? These kinds of expressive configaturations and interesting economic desicions only work if you can mess around with the structure of the money you're using.
