# AG_Validator
AG NodeJS Validator Service

Use qtum_deploy to quickly deploy two Qtum regtest enviroments, 'main' and 'govr' as docker containers on port 9888, and 8888 respectively. 

Using qmix deploy TransferToken to both main and govr chain (need 2 copies of qmix, use incognito to have it side by side)

Copy the addresses that the tokens deployed on in index.ts

Then use npm install to install modules, and then npm restart to build and serve project. 